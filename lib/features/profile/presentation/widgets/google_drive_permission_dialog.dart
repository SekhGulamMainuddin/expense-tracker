import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:expense_tracker/core/styles/app_texts.dart';
import 'package:expense_tracker/core/utils/ui_extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:expense_tracker/features/profile/presentation/cubit/profile_state.dart';
import 'package:expense_tracker/core/di/service_locator.dart';

class GoogleDrivePermissionDialog extends StatelessWidget {
  const GoogleDrivePermissionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    return BlocListener<ProfileCubit, ProfileState>(
      bloc: getIt<ProfileCubit>(),
      listenWhen: (_, current) =>
          current is ProfileLoaded && current.isDriveConnected,
      listener: (context, _) {
        if (Navigator.of(context).canPop()) {
          Navigator.pop(context);
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(20.r),
            decoration: BoxDecoration(
              color: cs.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.cloud_upload_outlined,
              size: 48.r,
              color: cs.primary,
            ),
          ),
          SizedBox(height: 24.h),
          AppTextHeadlineSm(
            'Backup to Google Drive',
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12.h),
          AppTextBodyMd(
            'Securely store and sync your financial records. Your data is encrypted and only accessible by you.',
            textAlign: TextAlign.center,
            height: 1.5,
            color: cs.onSurfaceVariant,
          ),
          SizedBox(height: 32.h),
          _featureRow(context, Icons.security_outlined, 'Private Storage', 'Stored in a hidden folder'),
          SizedBox(height: 16.h),
          _featureRow(context, Icons.sync_outlined, 'Auto-Sync', 'Never lose your data again'),
          SizedBox(height: 32.h),
          BlocBuilder<ProfileCubit, ProfileState>(
            bloc: getIt<ProfileCubit>(),
            builder: (context, state) {
              final isLoading = state is ProfileLoading;
              return Column(
                children: [
                  ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () => getIt<ProfileCubit>().connectDrive(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cs.primary,
                      foregroundColor: cs.onPrimary,
                      minimumSize: Size(double.infinity, 56.h),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                      elevation: 0,
                    ),
                    child: isLoading
                        ? SizedBox(
                            height: 24.h,
                            width: 24.w,
                            child: CircularProgressIndicator(color: cs.onPrimary, strokeWidth: 2),
                          )
                        : const AppTextBodyMd(
                            'Grant Access',
                            style: TextStyle(fontWeight: FontWeight.w600),
                            color: Colors.white,
                          ),
                  ),
                  SizedBox(height: 12.h),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: AppTextBodyMd(
                      'Maybe Later',
                      style: TextStyle(fontWeight: FontWeight.w600, color: cs.primary),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _featureRow(BuildContext context, IconData icon, String title, String subtitle) {
    final cs = context.theme.colorScheme;
    return Row(
      children: [
        Icon(icon, size: 20.r, color: cs.primary),
        SizedBox(width: 16.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextLabelMd(
              title,
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            AppTextLabelSm(
              subtitle,
              color: cs.onSurfaceVariant,
            ),
          ],
        ),
      ],
    );
  }
}
