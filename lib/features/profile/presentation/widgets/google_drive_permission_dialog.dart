import 'package:flutter/material.dart';
import 'package:expense_tracker/core/utils/ui_extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:expense_tracker/core/styles/app_dimensions.dart';
import 'package:expense_tracker/core/styles/app_palette.dart';
import 'package:expense_tracker/core/styles/app_texts.dart';
import 'package:expense_tracker/features/profile/presentation/cubit/google_drive_cubit.dart';
import 'package:expense_tracker/features/profile/presentation/cubit/google_drive_state.dart';

class GoogleDrivePermissionDialog extends StatelessWidget {
  const GoogleDrivePermissionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    return BlocProvider(
      create: (context) => GoogleDriveCubit(),
      child: BlocListener<GoogleDriveCubit, GoogleDriveState>(
        listener: (context, state) {
          if (state.isSuccess) Navigator.pop(context, true);
        },
        child: Dialog(
          shape: RoundedRectangleBorder(borderRadius: AppRadii.xl),
          backgroundColor: cs.surfaceContainerHigh,
          clipBehavior: Clip.antiAlias,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 400.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeroSection(context),
                Padding(
                  padding: EdgeInsets.fromLTRB(32.w, 32.h, 32.w, 10.h),
                  child: Column(
                    children: [
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
                      _buildFeatureList(context),
                      SizedBox(height: 32.h),
                      _buildActionButtons(context),
                    ],
                  ),
                ),
                _buildFooter(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    final cs = context.theme.colorScheme;
    return SizedBox(
      height: 160.h,
      width: double.infinity,
      child: ColoredBox(
        color: cs.surfaceContainerLow,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              left: 20.w,
              top: 20.h,
              child: Container(
                width: 100.r,
                height: 100.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: cs.primary.withOpacity(0.12),
                ),
              ),
            ),
            Positioned(
              right: 20.w,
              bottom: 20.h,
              child: Container(
                width: 100.r,
                height: 100.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: cs.tertiary.withOpacity(0.12),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(20.r),
              decoration: BoxDecoration(
                color: cs.surfaceContainerHigh,
                borderRadius: AppRadii.xl,
                boxShadow: [
                  BoxShadow(
                    color: AppPalette.ambientShadow.withOpacity(0.25),
                    blurRadius: 20.r,
                    offset: Offset(0, 10.h),
                  ),
                ],
              ),
              child: Icon(Icons.cloud_queue_rounded, size: 48.r, color: cs.primary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureList(BuildContext context) {
    final cs = context.theme.colorScheme;
    return Column(
      children: [
        _buildChecklistItem(
          context,
          icon: Icons.shield_outlined,
          color: cs.primary,
          title: 'End-to-End Encryption',
          subtitle: 'Private key security',
        ),
        SizedBox(height: 12.h),
        _buildChecklistItem(
          context,
          icon: Icons.sync_rounded,
          color: cs.tertiary,
          title: 'Real-time Sync',
          subtitle: 'Access from any device',
        ),
      ],
    );
  }

  Widget _buildChecklistItem(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
  }) {
    final cs = context.theme.colorScheme;
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: AppRadii.xl,
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, color: color, size: 18.r),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextLabelMd(
                  title,
                  
                  style: context.theme.textTheme.labelMedium!.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                AppTextLabelSm(
                  subtitle,
                  
                  color: cs.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final cs = context.theme.colorScheme;
    return BlocBuilder<GoogleDriveCubit, GoogleDriveState>(
      builder: (context, state) {
        return Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 56.h,
              child: ElevatedButton(
                onPressed: state.isGranting ? null : () => context.read<GoogleDriveCubit>().grantAccess(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: cs.surfaceContainerHigh,
                  foregroundColor: cs.onSurface,
                  shape: RoundedRectangleBorder(borderRadius: AppRadii.full),
                  elevation: 0,
                ),
                child: state.isGranting
                    ? SizedBox(
                        height: 20.h,
                        width: 20.w,
                        child: CircularProgressIndicator(color: cs.primary, strokeWidth: 2),
                      )
                    : AppTextBodyMd(
                        'Grant Access',
                        
                        style: context.theme.textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
              ),
            ),
            SizedBox(height: 8.h),
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                minimumSize: Size(double.infinity, 56.h),
                foregroundColor: cs.onSurfaceVariant,
              ),
              child: AppTextBodyMd(
                'Maybe Later',
                
                style: context.theme.textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFooter(BuildContext context) {
    final cs = context.theme.colorScheme;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      width: double.infinity,
      color: cs.surfaceContainerLow,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.lock_outline, size: 14.r, color: cs.onSurfaceVariant),
          SizedBox(width: 8.w),
          AppTextLabelSm(
            'VERIFIED SECURE CONNECTION',
            
            uppercase: true,
            letterSpacing: 1.2,
            color: cs.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}
