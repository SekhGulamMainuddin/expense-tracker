import 'package:flutter/material.dart';
import 'package:expense_tracker/core/utils/ui_extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/features/profile/presentation/cubit/delete_account_cubit.dart';
import 'package:expense_tracker/features/profile/presentation/cubit/delete_account_state.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/styles/app_dimensions.dart';
import '../../../../core/styles/app_text_styles.dart';
import '../../../../core/styles/app_texts.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final VoidCallback onConfirm;
  const DeleteConfirmationDialog({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    return BlocProvider(
      create: (context) => DeleteAccountCubit(),
      child: BlocListener<DeleteAccountCubit, DeleteAccountState>(
        listener: (context, state) {
          if (state.isSuccess) {
            context.closeAlertDialog();
            onConfirm();
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
                    _buildWarningIcon(cs),
                    SizedBox(height: 24.h),
                    AppTextHeadlineSm(
                      'Delete Account?',

                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 12.h),
                    AppTextBodyMd(
                      'This action is irreversible. All your transaction history, '
                          'saved reports, and personalized insights will be permanently removed.',

                      textAlign: TextAlign.center,
                      height: 1.5,
                      color: cs.onSurfaceVariant,
                    ),
                    SizedBox(height: 32.h),
                    _buildActionButtons(context),
                  ],
                ),
              ),
              Container(
                height: 6.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      cs.error.withOpacity(0.2),
                      cs.error,
                      cs.error.withOpacity(0.2),
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

  Widget _buildWarningIcon(ColorScheme cs) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 64.w,
          height: 64.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: cs.error.withOpacity(0.15),
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
            color: cs.errorContainer.withOpacity(0.65),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.warning_rounded,
            color: cs.error,
            size: 32.r,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final cs = context.theme.colorScheme;
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
                  backgroundColor: cs.error,
                  foregroundColor: cs.onError,
                  elevation: 0,
                  shadowColor: cs.error.withOpacity(0.35),
                  shape: RoundedRectangleBorder(borderRadius: AppRadii.full),
                ),
                child: state.isDeleting
                    ? SizedBox(
                  height: 20.h,
                  width: 20.w,
                  child: CircularProgressIndicator(
                    color: cs.onError,
                    strokeWidth: 2,
                  ),
                )
                    : AppTextLabelMd(
                  'YES, DELETE',

                  uppercase: true,
                  style: AppTextStyles.labelMd(context).copyWith(
                    letterSpacing: 1.1,
                    fontWeight: FontWeight.w800,
                  ),
                  color: cs.onError,
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
                  foregroundColor: cs.onSurfaceVariant,
                ),
                child: AppTextLabelMd(
                  'CANCEL',

                  uppercase: true,
                  style: AppTextStyles.labelMd(context).copyWith(
                    letterSpacing: 1.1,
                    fontWeight: FontWeight.w800,
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
