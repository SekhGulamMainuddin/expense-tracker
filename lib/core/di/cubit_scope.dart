import 'package:bloc/bloc.dart';
import 'package:expense_tracker/core/di/service_locator.dart';

/// Screen-scoped Cubit registration.
///
/// Cubits are never handed to child widgets through constructors. A screen
/// opens a GetIt scope holding its Cubit, every widget in that subtree
/// resolves the same instance with `getIt<T>()`, and closing the scope closes
/// the Cubit. See `PROJECT_RULES.md` -> Scoped Cubits.
abstract final class CubitScope {
  static int _sequence = 0;

  /// Opens a fresh scope holding [create]'s result and returns the scope's
  /// unique name, which the caller must keep and hand back to [close].
  ///
  /// The name is suffixed with a counter rather than being a fixed string,
  /// because two instances of the same screen can be alive at once — a rapid
  /// double-tap pushes the route twice. With a shared name the second instance
  /// would drop the first one's scope, so the first screen would resolve the
  /// second's Cubit, and whichever popped first would tear the survivor's
  /// scope out from under it. One scope per instance keeps them independent;
  /// `getIt` resolves from the topmost scope down, so the visible screen wins.
  static String open<T extends BlocBase<Object?>>({
    required String scopeName,
    required T Function() create,
  }) {
    final uniqueName = '$scopeName#${_sequence++}';
    getIt.pushNewScope(
      scopeName: uniqueName,
      init: (scope) => scope.registerSingleton<T>(
        create(),
        dispose: (cubit) => cubit.close(),
      ),
    );
    return uniqueName;
  }

  /// Drops the scope and closes the Cubit it owns. Safe to call with a name
  /// that was never opened or has already been dropped.
  ///
  /// `dropScope` is asynchronous and deliberately not awaited here, since
  /// `dispose()` cannot await. It removes the one scope it was given (not the
  /// scopes above it), so teardown order between nested screens is safe.
  static void close(String? scopeName) {
    if (scopeName == null) return;
    if (getIt.hasScope(scopeName)) {
      getIt.dropScope(scopeName);
    }
  }
}
