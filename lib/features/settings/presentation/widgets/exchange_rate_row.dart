import 'package:easy_localization/easy_localization.dart';
import 'package:expense_tracker/core/di/service_locator.dart';
import 'package:expense_tracker/core/exchange/domain/entities/exchange_rates.dart';
import 'package:expense_tracker/core/styles/app_texts.dart';
import 'package:expense_tracker/core/utils/ui_extensions.dart';
import 'package:expense_tracker/features/settings/presentation/cubit/exchange_rate_cubit.dart';
import 'package:expense_tracker/features/settings/presentation/cubit/exchange_rate_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Shows when currency rates were last synced and lets the user force a
/// refresh. Rates only matter once more than one currency is in play, but the
/// staleness is worth surfacing either way.
class ExchangeRateRow extends StatelessWidget {
  const ExchangeRateRow({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final cubit = getIt<ExchangeRateCubit>();

    return BlocConsumer<ExchangeRateCubit, ExchangeRateState>(
      bloc: cubit,
      listenWhen: (previous, current) => current is ExchangeRateFailure,
      listener: (context, state) => context
          .showAppSnackBar((state as ExchangeRateFailure).errorMessage),
      builder: (context, state) {
        final isLoading = state is ExchangeRateLoading;
        final rates = switch (state) {
          ExchangeRateLoaded(rates: final r) => r,
          ExchangeRateFailure(rates: final r) => r,
          _ => null,
        };

        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(Icons.sync_alt, color: cs.primary, size: 24.r),
          title: AppTextBodyLg(
            'settings.exchange_rates',
            style: context.theme.textTheme.bodyLarge!.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: AppTextBodyMd(
            _subtitle(context, rates, isLoading),
            color: rates?.isFallback == true ? cs.tertiary : cs.onSurfaceVariant,
          ),
          trailing: isLoading
              ? SizedBox(
                  width: 20.r,
                  height: 20.r,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: cs.primary,
                  ),
                )
              : IconButton(
                  tooltip: context.tr('settings.refresh_rates'),
                  icon: Icon(Icons.refresh, size: 22.r, color: cs.primary),
                  onPressed: cubit.refresh,
                ),
        );
      },
    );
  }

  String _subtitle(
    BuildContext context,
    ExchangeRates? rates,
    bool isLoading,
  ) {
    if (isLoading) return context.tr('settings.rates_syncing');
    if (rates == null || rates.isFallback) {
      return context.tr('settings.rates_approximate');
    }
    return context.tr(
      'settings.rates_updated',
      namedArgs: {'when': _relativeTime(context, rates.fetchedAt!)},
    );
  }

  String _relativeTime(BuildContext context, DateTime timestamp) {
    final elapsed = DateTime.now().difference(timestamp);
    if (elapsed.inMinutes < 1) return context.tr('settings.rates_just_now');
    if (elapsed.inHours < 1) {
      return context.tr('settings.rates_minutes_ago',
          namedArgs: {'count': '${elapsed.inMinutes}'});
    }
    if (elapsed.inDays < 1) {
      return context.tr('settings.rates_hours_ago',
          namedArgs: {'count': '${elapsed.inHours}'});
    }
    return context.tr('settings.rates_days_ago',
        namedArgs: {'count': '${elapsed.inDays}'});
  }
}
