import 'package:expense_tracker/core/domain/entities/app_theme.dart';
import 'package:expense_tracker/core/domain/entities/currency.dart';

sealed class AppPreferenceKey<T> {
  final String key;
  final T defaultValue;
  const AppPreferenceKey(this.key, this.defaultValue);
}

final class ThemePreferenceKey extends AppPreferenceKey<AppTheme> {
  const ThemePreferenceKey() : super('themeMode', AppTheme.system);
}

final class CurrencyPreferenceKey extends AppPreferenceKey<Currency> {
  const CurrencyPreferenceKey() : super('baseCurrency', Currency.inr);
}

final class DailyLimitPreferenceKey extends AppPreferenceKey<double> {
  const DailyLimitPreferenceKey() : super('dailyLimit', 50.0);
}

final class WeeklyLimitPreferenceKey extends AppPreferenceKey<double> {
  const WeeklyLimitPreferenceKey() : super('weeklyLimit', 350.0);
}

final class MonthlyLimitPreferenceKey extends AppPreferenceKey<double> {
  const MonthlyLimitPreferenceKey() : super('monthlyLimit', 1500.0);
}

final class SafeThresholdPreferenceKey extends AppPreferenceKey<double> {
  const SafeThresholdPreferenceKey() : super('safeThreshold', 5.0);
}

final class CautionThresholdPreferenceKey extends AppPreferenceKey<double> {
  const CautionThresholdPreferenceKey() : super('cautionThreshold', 5.0);
}

final class DangerThresholdPreferenceKey extends AppPreferenceKey<double> {
  const DangerThresholdPreferenceKey() : super('dangerThreshold', 10.0);
}

class AppPreferences {
  static const theme = ThemePreferenceKey();
  static const currency = CurrencyPreferenceKey();
  static const dailyLimit = DailyLimitPreferenceKey();
  static const weeklyLimit = WeeklyLimitPreferenceKey();
  static const monthlyLimit = MonthlyLimitPreferenceKey();
  static const safeThreshold = SafeThresholdPreferenceKey();
  static const cautionThreshold = CautionThresholdPreferenceKey();
  static const dangerThreshold = DangerThresholdPreferenceKey();

  static const all = [
    theme,
    currency,
    dailyLimit,
    weeklyLimit,
    monthlyLimit,
    safeThreshold,
    cautionThreshold,
    dangerThreshold,
  ];
}
