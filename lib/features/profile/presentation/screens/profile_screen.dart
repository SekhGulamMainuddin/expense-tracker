import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:expense_tracker/core/utils/ui_extensions.dart';
import 'package:expense_tracker/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:expense_tracker/features/profile/presentation/widgets/profile_header.dart';
import 'package:expense_tracker/features/profile/presentation/widgets/drive_integration_card.dart';
import 'package:expense_tracker/features/profile/presentation/widgets/delete_confirmation_dialog.dart';

class ProfileScreen extends StatelessWidget {
  static const routeName = '/profile';

  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return BlocProvider(
      create: (_) => ProfileCubit(),
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: Stack(
          children: [
            // Hero Glow Effect
            Positioned(
              top: -100.h,
              left: -50.w,
              child: Container(
                width: 300.w,
                height: 300.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.primary.withOpacity(0.08),
                ),
              ),
            ),
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
              child: Column(
                children: [
                  const ProfileHeader(),
                  SizedBox(height: 40.h),
                  const DriveIntegrationCard(),
                  SizedBox(height: 40.h),
                  _dangerZone(context),
                  SizedBox(height: 100.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final theme = context.theme;
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface, size: 24.r),
        onPressed: () => context.pop(),
      ),
      title: Text(
        'Profile',
        style: GoogleFonts.manrope(
          fontWeight: FontWeight.w800,
          fontSize: 20.sp,
          letterSpacing: -1,
        ),
      ),
    );
  }

  Widget _dangerZone(BuildContext context) {
    final theme = context.theme;
    return Column(
      children: [
        OutlinedButton.icon(
          onPressed: () {
            context.showAppAlertDialog(
              content: const DeleteConfirmationDialog(),
            );
          },
          icon: Icon(Icons.delete_forever, size: 18.r),
          label: const Text('Delete Account'),
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFFEF4444),
            side: const BorderSide(color: Color(0xFFFEE2E2)),
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 32.w),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
            minimumSize: Size(double.infinity, 56.h),
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          'Permanently delete your account and all associated '
          'ledger data. This action cannot be undone.',
          textAlign: TextAlign.center,
          style: TextStyle(color: const Color(0xFF94A3B8), fontSize: 10.sp),
        ),
      ],
    );
  }
}
