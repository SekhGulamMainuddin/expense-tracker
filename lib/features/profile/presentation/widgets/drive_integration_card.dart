import 'package:flutter/material.dart';
import 'package:expense_tracker/core/utils/ui_extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:expense_tracker/features/profile/presentation/cubit/profile_state.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/styles/app_palette.dart';
import '../../../../core/styles/app_texts.dart';

class DriveIntegrationCard extends StatelessWidget {
  const DriveIntegrationCard({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
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
                  Icons.cloud_queue,
                  size: 100.r,
                  color: cs.onSurface.withOpacity(0.04),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _titleRow(context),
                  SizedBox(height: 16.h),
                  AppTextBodyMd(
                    'Your financial documents and ledger exports are '
                    'automatically synchronized with your Cloud Storage '
                    'for seamless accessibility.',
                    
                    height: 1.5,
                    color: cs.onSurfaceVariant,
                  ),
                  SizedBox(height: 20.h),
                  _statusRow(context, state),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _titleRow(BuildContext context) {
    final cs = context.theme.colorScheme;
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            color: cs.primary.withOpacity(0.12),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(Icons.add_to_drive, color: cs.primary, size: 24.r),
        ),
        SizedBox(width: 16.w),
        AppTextBodyLg(
          'Google Drive Connected',
          
          style: context.theme.textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }

  Widget _statusRow(BuildContext context, ProfileState state) {
    final cs = context.theme.colorScheme;
    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: cs.secondaryContainer.withOpacity(0.55),
            borderRadius: BorderRadius.circular(9999),
          ),
          child: AppTextLabelSm(
            state.isSyncing ? 'Active Sync' : 'Sync Paused',
            
            color: cs.onSecondaryContainer,
          ),
        ),
        const Spacer(),
        TextButton(
          onPressed: () {},
          child: AppTextLabelMd(
            'Manage Permissions',
            
            color: cs.primary,
          ),
        ),
      ],
    );
  }
}
