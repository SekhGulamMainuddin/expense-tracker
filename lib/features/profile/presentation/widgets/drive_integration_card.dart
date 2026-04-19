import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:expense_tracker/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:expense_tracker/features/profile/presentation/cubit/profile_state.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/ui_extensions.dart';

class DriveIntegrationCard extends StatelessWidget {
  const DriveIntegrationCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.all(24.r),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(color: theme.colorScheme.outline),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 10.r,
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
                  color: Colors.black.withOpacity(0.03),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _titleRow(context),
                  SizedBox(height: 16.h),
                  Text(
                    'Your financial documents and ledger exports are '
                    'automatically synchronized with your Cloud Storage '
                    'for seamless accessibility.',
                    style: GoogleFonts.manrope(
                      color: const Color(0xFF64748B),
                      fontSize: 13.sp,
                      height: 1.5,
                    ),
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
    final theme = context.theme;
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Icon(Icons.add_to_drive, color: theme.colorScheme.primary, size: 24.r),
        ),
        SizedBox(width: 16.w),
        Text(
          'Google Drive Connected',
          style: GoogleFonts.manrope(
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
          ),
        ),
      ],
    );
  }

  Widget _statusRow(BuildContext context, ProfileState state) {
    final theme = context.theme;
    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: const Color(0xFFD1FAE5),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Text(
            state.isSyncing ? 'Active Sync' : 'Sync Paused',
            style: TextStyle(
              color: const Color(0xFF065F46),
              fontSize: 11.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Spacer(),
        TextButton(
          onPressed: () {},
          child: Text(
            'Manage Permissions',
            style: TextStyle(
              color: theme.colorScheme.primary,
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

