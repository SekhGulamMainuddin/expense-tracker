enum AppTheme {
  light,
  dark,
  system;

  static AppTheme fromString(String? value) {
    if (value == null) return AppTheme.system;
    return AppTheme.values.firstWhere(
      (e) => e.name == value.toLowerCase(),
      orElse: () => AppTheme.system,
    );
  }
}
