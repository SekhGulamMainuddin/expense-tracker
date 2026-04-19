import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:expense_tracker/features/profile/presentation/cubit/delete_account_cubit.dart';
import 'package:expense_tracker/features/profile/presentation/cubit/delete_account_state.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  const DeleteConfirmationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DeleteAccountCubit(),
      child: BlocListener<DeleteAccountCubit, DeleteAccountState>(
        listener: (context, state) {
          if (state.isSuccess) {
            Navigator.pop(context); // Close dialog
          }
        },
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 340.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(32.w, 40.h, 32.w, 32.h),
                child: Column(
                  children: [
                    _buildWarningIcon(),
                    SizedBox(height: 24.h),
                    Text(
                      'Delete Account?',
                      style: GoogleFonts.manrope(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      'This action is irreversible. All your transaction history, '
                      'saved reports, and personalized insights will be permanently removed.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.manrope(
                        fontSize: 14.sp,
                        color: const Color(0xFF64748B),
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 32.h),
                    _buildActionButtons(context),
                  ],
                ),
              ),
              // Decorative Bottom Gradient Line
              Container(
                height: 6.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFEF4444).withOpacity(0.2),
                      const Color(0xFFEF4444),
                      const Color(0xFFEF4444).withOpacity(0.2),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWarningIcon() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Glow effect
        Container(
          width: 64.w,
          height: 64.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.red.withOpacity(0.1),
                blurRadius: 20.r,
                spreadRadius: 10.r,
              ),
            ],
          ),
        ),
        Container(
          width: 64.w,
          height: 64.h,
          decoration: BoxDecoration(
            color: const Color(0xFFFEF2F2),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFFEE2E2)),
          ),
          child: Icon(
            Icons.warning_rounded,
            color: const Color(0xFFEF4444),
            size: 32.r,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return BlocBuilder<DeleteAccountCubit, DeleteAccountState>(
      builder: (context, state) {
        return Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 56.h,
              child: ElevatedButton(
                onPressed: state.isDeleting
                    ? null
                    : () => context.read<DeleteAccountCubit>().deleteAccount(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEF4444),
                  foregroundColor: Colors.white,
                  elevation: 8,
                  shadowColor: const Color(0xFFEF4444).withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: state.isDeleting
                    ? SizedBox(
                        height: 20.h,
                        width: 20.w,
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        'YES, DELETE',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                          fontSize: 14.sp,
                        ),
                      ),
              ),
            ),
            SizedBox(height: 12.h),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  foregroundColor: const Color(0xFF64748B),
                ),
                child: Text(
                  'CANCEL',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

