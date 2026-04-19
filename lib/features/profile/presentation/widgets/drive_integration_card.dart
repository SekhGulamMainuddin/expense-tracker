import 'package:flutter/material.dart';
import 'package:expense_tracker/core/utils/ui_extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:expense_tracker/features/profile/presentation/cubit/profile_state.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/styles/app_palette.dart';
import '../../../../core/styles/app_texts.dart';

import 'package:expense_tracker/core/di/service_locator.dart';
import 'google_drive_permission_dialog.dart';

class DriveIntegrationCard extends StatelessWidget {
  const DriveIntegrationCard({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    return BlocBuilder<ProfileCubit, ProfileState>(
      bloc: getIt<ProfileCubit>(),
      builder: (context, state) {
        final isConnected = state is ProfileLoaded && state.isDriveConnected;

        return Container(
          padding: EdgeInsets.all(24.r),
          decoration: BoxDecoration(
            color: cs.surfaceContainer,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: AppPalette.ambientShadow.withOpacity(0.35),
                blurRadius: 24.r,
                offset: Offset(0, 12.h),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                right: -20.w,
                top: -20.h,
                child: Icon(
                  isConnected ? Icons.cloud_done : Icons.cloud_off,
                  size: 100.r,
                  color: (isConnected ? cs.primary : cs.onSurface).withOpacity(0.04),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _titleRow(context, isConnected),
                  SizedBox(height: 16.h),
                  AppTextBodyMd(
                    isConnected
                        ? 'Your financial documents and ledger exports are automatically synchronized with your Cloud Storage.'
                        : 'Enable Google Drive backup to securely sync your data across devices and never lose your records.',
                    height: 1.5,
                    color: cs.onSurfaceVariant,
                  ),
                  SizedBox(height: 20.h),
                  _statusRow(context, state, isConnected),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _titleRow(BuildContext context, bool isConnected) {
    final cs = context.theme.colorScheme;
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            color: (isConnected ? cs.primary : cs.onSurfaceVariant).withOpacity(0.12),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(
            isConnected ? Icons.add_to_drive : Icons.drive_eta_outlined,
            color: isConnected ? cs.primary : cs.onSurfaceVariant,
            size: 24.r,
          ),
        ),
        SizedBox(width: 16.w),
        AppTextBodyLg(
          isConnected ? 'Google Drive Connected' : 'Google Drive Backup',
          style: context.theme.textTheme.bodyLarge!.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _statusRow(BuildContext context, ProfileState state, bool isConnected) {
    final cs = context.theme.colorScheme;
    final isSyncing = state is ProfileLoaded && state.isSyncing;

    return Row(
      children: [
        if (isConnected)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: cs.secondaryContainer.withOpacity(0.55),
              borderRadius: BorderRadius.circular(9999),
            ),
            child: AppTextLabelSm(
              isSyncing ? 'Active Sync' : 'Sync Paused',
              color: cs.onSecondaryContainer,
            ),
          )
        else
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: cs.errorContainer.withOpacity(0.55),
              borderRadius: BorderRadius.circular(9999),
            ),
            child: AppTextLabelSm(
              'Not Connected',
              color: cs.onErrorContainer,
            ),
          ),
        const Spacer(),
        if (isConnected && !isSyncing)
          Row(
            children: [
              TextButton.icon(
                onPressed: () => getIt<ProfileCubit>().syncData(),
                icon: Icon(Icons.upload, size: 16.r, color: cs.primary),
                label: AppTextLabelMd(
                  'Backup',
                  color: cs.primary,
                ),
              ),
              SizedBox(width: 8.w),
              TextButton.icon(
                onPressed: () => getIt<ProfileCubit>().restoreData(),
                icon: Icon(Icons.download, size: 16.r, color: cs.primary),
                label: AppTextLabelMd(
                  'Restore',
                  color: cs.primary,
                ),
              ),
            ],
          ),
        if (isSyncing)
          SizedBox(
            height: 16.h,
            width: 16.w,
            child: CircularProgressIndicator(strokeWidth: 2, color: cs.primary),
          ),
        if (!isConnected)
          TextButton(
            onPressed: () {
              context.showAppAlertDialog(
                content: const GoogleDrivePermissionDialog(),
              );
            },
            child: AppTextLabelMd(
              'Enable Now',
              color: cs.primary,
            ),
          ),
      ],
    );
  }
}
