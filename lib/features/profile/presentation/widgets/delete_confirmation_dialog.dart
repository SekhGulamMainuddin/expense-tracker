import 'package:expense_tracker/core/di/service_locator.dart';
import 'package:expense_tracker/core/styles/app_dimensions.dart';
import 'package:expense_tracker/core/styles/app_text_styles.dart';
import 'package:expense_tracker/core/styles/app_texts.dart';
import 'package:expense_tracker/core/utils/ui_extensions.dart';
import 'package:expense_tracker/features/auth/presentation/screens/login_screen.dart';
import 'package:expense_tracker/features/profile/presentation/cubit/delete_account_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class DeleteConfirmationDialog extends StatefulWidget {
  const DeleteConfirmationDialog({super.key});

  @override
  State<DeleteConfirmationDialog> createState() => _DeleteConfirmationDialogState();
}

class _DeleteConfirmationDialogState extends State<DeleteConfirmationDialog> {
  late final DeleteAccountCubit _deleteAccountCubit;

  @override
  void initState() {
    super.initState();
    _deleteAccountCubit = getIt<DeleteAccountCubit>();
  }

  @override
  void dispose() {
    _deleteAccountCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    return BlocListener<DeleteAccountCubit, DeleteAccountState>(
      bloc: _deleteAccountCubit,
      listener: (context, state) {
        if (state case DeleteAccountFailure(:final message)) {
          context.showAppSnackBar(message);
        }

        if (state is DeleteAccountSuccess) {
          if (!mounted) return;
          context.closeAlertDialog();
          context.parentContext.go(LoginScreen.routeName);
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
                    cs.error.withValues(alpha: 0.2),
                    cs.error,
                    cs.error.withValues(alpha: 0.2),
                  ],
                ),
              ),
            ),
          ],
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
                color: cs.error.withValues(alpha: 0.15),
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
            color: cs.errorContainer.withValues(alpha: 0.65),
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
      bloc: _deleteAccountCubit,
      builder: (context, state) {
        return Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 56.h,
              child: ElevatedButton(
                onPressed: state is DeleteAccountDeleting
                    ? null
                    : _deleteAccountCubit.deleteAccount,
                style: ElevatedButton.styleFrom(
                  backgroundColor: cs.error,
                  foregroundColor: cs.onError,
                  elevation: 0,
                  shadowColor: cs.error.withValues(alpha: 0.35),
                  shape: RoundedRectangleBorder(borderRadius: AppRadii.full),
                ),
                child: state is DeleteAccountDeleting
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
