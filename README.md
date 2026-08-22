# Expense Tracker

An offline-first personal expense tracker for Android and iOS. Your data lives in a local SQLite database on your device; signing in with Google adds an automatic backup to a private folder in your own Google Drive.

---

## What it does

### See where your money goes
- **Dashboard** — this month's spend against your budget, plus daily and weekly totals and a month-over-month trend.
- **Category breakdown** — a donut chart of spending per category, switchable between daily, weekly, monthly, and all-time. Subcategory spend rolls up into its parent.
- **Recent transactions** — your latest ten expenses on the home screen; tap any one to view, edit, or delete it.

### Log expenses quickly
- Large-key amount entry, capped at two decimal places.
- Pick a category and subcategory in two taps.
- Leave the title blank and it fills in as `Category | Subcategory`.

### Find anything
- Full transaction list with infinite scroll.
- Filter by date (today, last 7 days, last 30 days, or a custom range) and by any combination of categories — selecting a parent selects its children.
- Search by title.
- Swipe a row to delete it.

### Stay on budget
- Set daily, weekly, and monthly spending limits.
- Tune the "safe", "caution", and "danger" thresholds that colour the budget indicators.
- Edits are staged, so you can review before saving or discard them.

### Make it yours
- Create, rename, recolour, and re-icon categories and subcategories. Deleting a category moves its expenses to the parent rather than losing them.
- Icon picker spanning Material, Remix, Tabler, Phosphor, Heroicons, Feather, and Font Awesome, plus your own custom icons.
- Light and dark themes, or follow the system.

### Multi-currency
- 13 currencies. Pick the one you want to see totals in and switch any time.
- Rates refresh automatically from [Frankfurter](https://frankfurter.dev) (ECB data, no API key) and are cached for 12 hours, so the app works offline. Settings shows when rates were last synced and lets you force a refresh; approximate built-in rates are used and clearly labelled until the first sync succeeds.
- Every expense is stored normalized to a single base, so switching display currency never rewrites your history.

### Backup and account control
- **Google Drive backup** — the SQLite file is uploaded to Drive's `appDataFolder`, a private per-app area that other apps and the Drive UI cannot see. Backup runs automatically when the app goes to the background, and on demand from Profile.
- **Restore** — pulls the backup back down and reloads the app against it.
- **Delete account** — removes the Drive backup, wipes the local database, and signs you out.

> **On privacy:** the backup is not end-to-end encrypted. It is protected by your Google account and by Drive's app-private storage — Google can technically access it, as with any unencrypted Drive content. If you want zero-knowledge backup, don't connect Drive; the app is fully functional offline without it.

---

## Getting started

Requires the Flutter SDK. The repo pins its version with [FVM](https://fvm.app), so prefer `fvm flutter` over bare `flutter`.

```bash
fvm install                 # fetch the pinned SDK
fvm flutter pub get
fvm dart run build_runner build --delete-conflicting-outputs
fvm flutter run
```

Google Sign-In and Drive backup need your own Firebase project. Without it the app still builds, but you will not get past the login screen.

1. Create a Firebase project and add an Android and/or iOS app.
2. Enable **Google** under Authentication → Sign-in method.
3. Drop `google-services.json` into `android/app/` and `GoogleService-Info.plist` into `ios/Runner/`.
4. Regenerate `lib/firebase_options.dart` with `flutterfire configure`.
5. Enable the **Google Drive API** in the matching Google Cloud project.

### Everyday commands

```bash
fvm flutter analyze                                        # lints and type checks
fvm flutter test                                           # unit tests
fvm dart run build_runner build --delete-conflicting-outputs   # after touching a table, model, or API
```

In a debug build, Profile has a **Seed Mock Data** button that replaces your database with three years of generated transactions. It is compiled out of release builds.

---

## Architecture

MVVM with a strict domain / data / presentation split. `PROJECT_RULES.md` is the normative version; the short form:

```
UI → Cubit → Repository (domain interface) → RepositoryImpl (data) → DataSource → DAO / Dio
```

- **Dependency injection** — GetIt only. No `BlocProvider`, no `context.read`. Screen-scoped Cubits live in a named GetIt scope (`lib/core/di/cubit_scope.dart`) and are resolved with `getIt<T>()` rather than passed through widget constructors.
- **Error handling** — repositories return `ResultFuture<T>`, a sealed `Success` / `Error` pair. Cubits resolve it with `fold`.
- **State** — one `sealed class` per Cubit, no Equatable and no `const`, so every emit rebuilds.
- **Storage** — Drift over SQLite. Expenses, a self-referencing category tree, a typed key-value store for preferences, and custom icons.
- **Navigation** — go_router, with an `indexedStack` shell for the Home/Settings tabs. Always navigate via a screen's `routeName`.
- **UI** — `flutter_screenutil` for all sizing (`.w`, `.h`, `.r`, `.sp`) against a 390×844 design, themed through `AppPalette`, localized with `easy_localization`.

```
lib/
├── core/
│   ├── database/       Drift tables, DAOs, migrations, preference keys
│   ├── di/             service locator and Cubit scoping
│   ├── domain/         cross-cutting entities (Currency, AppTheme)
│   ├── error/          Result and Failure types
│   ├── exchange/       exchange-rate fetch, cache, and conversion
│   ├── navigation/     router and tab shell
│   ├── styles/         theme, palette, typography
│   └── widgets/        shared components
└── features/
    ├── add_expense/    create, view, edit, delete one expense
    ├── auth/           Google Sign-In and Drive authorization
    ├── home/           dashboard, charts, recent activity
    ├── profile/        backup, restore, account deletion
    ├── settings/       categories, budgets, currency, theme
    └── transactions/   filtered and searchable history
```

Amounts are stored twice per row: `amount` as entered, and `baseAmount` normalized to the base currency. Aggregation always runs on `baseAmount`, so totals stay correct no matter which currency an expense was logged in, and the rate in force at entry time is never retroactively rewritten.
