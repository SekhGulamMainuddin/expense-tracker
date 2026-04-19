# Expense Tracker: AI Development Guidelines

This document serves as the single source of truth for all AI assistants (Antigravity, Claude, Cursor, Codex, etc.) working on the Expense Tracker project.

---

## 1. Core Architecture: MVVM + DI (GetIt)
- **Layered Structure**: Keep code strictly separated into `domain` (interfaces/entities), `data` (implementations/DTOs), and `presentation` (UI/Cubits).
- **Dependency Injection (GetIt)**:
    - **NO BlocProvider**: Never use `BlocProvider` or `context.read<Cubit>()`.
    - **Registration**: All dependencies must be registered in `lib/core/di/service_locator.dart`.
    - **Singletons**: Use `LazySingleton` for global state (Finance, Settings).
    - **Factories**: Use `Factory` for screen-specific state (Login, AddExpense).
    - **Usage**: Access via `getIt<CubitType>()`. Pass explicitly to `bloc:` in `BlocBuilder`/`BlocListener`.
    - **Lifecycle**: If using a factory Cubit, use a `StatefulWidget` and call `cubit.close()` in `dispose()`.

## 2. Data Flow & Error Handling: Result Pattern
- **Result Type**: All repository methods must return `ResultFuture<T>` or `ResultVoid` for asynchronous operations.
    - `ResultFuture<T>` is an alias for `Future<Result<T, Failure>>`.
    - `ResultVoid` is an alias for `ResultFuture<void>`.
- **Sealed Result**: Use the custom `Result` sealed class in `lib/core/error/result.dart`.
- **Failure Types**: Use specialized failures like `AuthFailure` or `ServerFailure`.
- **Cubit Integration**: Use `.fold()` to handle results and emit atomic states.

## 3. State Management: Atomic Sealed States
- **Sealed Classes**: All Cubit states must be `sealed class MyState`.
- **NO Equatable for States**: Do NOT use `Equatable` for Cubit states. This ensures every state emission (even with identical data) triggers a UI rebuild if needed.
- **NO const Constructors for ANY States**: Do NOT add `const` constructors to the base `sealed class` or any of its subclasses (even those with parameters). For empty states, just define the class with no explicit constructor (e.g., `final class Loading extends MyState {}`). Never use the `const` keyword when emitting states.
- **No Flags**: Do not use multiple boolean flags in a single state class.

## 4. UI/UX & Responsive Design
- **Responsive Scaling**: Use `flutter_screenutil` for ALL numeric values:
    - `16.w` for widths, `24.h` for heights, `12.r` for radii.
    - **Text Scaling**: All font sizes MUST use `.sp` (e.g., `fontSize: 18.sp`).
- **Theming**:
    - Always use `context.theme` from `lib/core/utils/ui_extensions.dart`.
    - Support both Light and Dark modes from `lib/core/styles/app_theme.dart`.
- **Aesthetics**: Premium look with harmonious colors (`AppPalette`), smooth animations, and Google Fonts.

## 5. Coding Standards
- **Equatable**: Use for all Entities and Models to ensure value equality. **CRITICAL: Always ask the user before adding Equatable to a class; do not do it yourself.** Do NOT use it for States.
- **Interfaces**: Prefer using `abstract interface class` for interface-like behavior (e.g., Repositories, Services).
- **Navigation (go_router)**: Never use hardcoded string paths (like `'/login'`) when using `context.go()`, `context.push()`, etc. Always use the static `routeName` property defined on the target screen (e.g., `context.go(LoginScreen.routeName)`).
- **Components**: Keep widgets small and reusable. Use custom widgets from `core/widgets`.
- **Auth**: Follow the Firebase + Google Sign-In event-driven flow (v7.2.0+).
- **Data Models vs. Entities**:
    - **Models (Data Layer)**: MUST use `@JsonSerializable()` if they are used by Retrofit, Hive, or Database classes.
    - **Entities (Domain Layer)**: MUST NOT use any serialization annotations (e.g., `json_serializable`). They should be pure Dart classes.
    - **Mappers**: Always provide mappers (e.g., `toEntity()` and `fromEntity()`) in the model classes to convert between layers.
- **API & Local DB Call Flow**:
    - **Tools**: Mandatory use of **Retrofit** for REST APIs and **Drift/Hive** for local storage.
    - **Hierarchy**: `UI -> Cubit -> Repository Interface (Domain) -> Repository Implementation (Data) -> Local/Remote DataSource`.
    - **Restriction**: NO direct API or Database calls in the UI, Cubit, or Repository. All data access logic must reside in a `DataSource`.

---

## Folder Structure Reference
- `lib/core/`: Global styles, widgets, and utilities.
- `lib/features/<name>/domain/`: Interfaces and entities.
- `lib/features/<name>/data/`: Implementations and data sources.
- `lib/features/<name>/presentation/`: Cubits and UI components.
