import 'package:expense_tracker/features/auth/presentation/cubit/login_cubit.dart';
import 'package:expense_tracker/features/auth/presentation/cubit/login_state.dart';
import 'package:expense_tracker/features/home/presentation/screens/home_screen.dart';
import 'package:expense_tracker/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/core/utils/ui_extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/styles/app_dimensions.dart';
import '../../../../core/styles/app_texts.dart';

import 'package:expense_tracker/core/di/service_locator.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginCubit = getIt<LoginCubit>();

  @override
  void dispose() {
    _loginCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      bloc: _loginCubit,
      listener: (context, state) {
        if (state is LoginFailure) {
          context.showAppSnackBar(state.errorMessage);
        }
        if (state is LoginSuccess) {
          context.go(HomeScreen.routeName);
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            _buildBackgroundAccents(context),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const _AppIdentitySection(),
                      SizedBox(height: 48.h),
                      BlocBuilder<LoginCubit, LoginState>(
                        bloc: _loginCubit,
                        builder: (context, state) {
                          return Column(
                            children: [
                              _GoogleSignInButton(
                                isLoading: state is LoginLoading || state is LoginSyncing,
                                onPressed: () => _loginCubit.signInWithGoogle(),
                              ),
                              if (state is LoginSyncing) ...[
                                SizedBox(height: 16.h),
                                AppTextLabelMd(
                                  'Syncing Cloud Backup...',
                                  color: context.theme.colorScheme.onSurfaceVariant,
                                ),
                              ],
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildBackgroundAccents(BuildContext context) {
  final theme = context.theme;
  return Stack(
    children: [
      Positioned(
        top: -100.h,
        left: -100.w,
        child: Container(
          width: 384.w,
          height: 384.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: theme.colorScheme.primary.withOpacity(0.05),
          ),
        ),
      ),
      Positioned(
        bottom: 200.h,
        right: -100.w,
        child: Container(
          width: 320.w,
          height: 320.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: theme.colorScheme.primary.withOpacity(0.1),
          ),
        ),
      ),
    ],
  );
}

class _AppIdentitySection extends StatelessWidget {
  const _AppIdentitySection();

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final cs = theme.colorScheme;
    return Column(
      children: [
        Container(
          width: 80.w,
          height: 80.h,
          decoration: BoxDecoration(
            color: cs.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: cs.shadow.withOpacity(0.35),
                blurRadius: 24.r,
                spreadRadius: 4.r,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: Assets.branding.launcherIcon.image(fit: BoxFit.cover),
          ),
        ),
        SizedBox(height: 24.h),
        const AppTextHeadlineSm('Expense Tracker', textAlign: TextAlign.center),
        SizedBox(height: 12.h),
        SizedBox(
          width: 280.w,
          child: AppTextBodyMd(
            'Experience the next generation of financial intelligence and asset management.',
            textAlign: TextAlign.center,
            height: 1.5,
            color: cs.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _GoogleSignInButton extends StatelessWidget {
  const _GoogleSignInButton({required this.isLoading, required this.onPressed});

  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shadowColor: Colors.transparent,
          backgroundColor: cs.surfaceContainerHighest,
          foregroundColor: cs.onSurface,
          shape: RoundedRectangleBorder(borderRadius: AppRadii.full),
          padding: EdgeInsets.symmetric(horizontal: 20.w),
        ),
        child: isLoading
            ? SizedBox(
          height: 20.h,
          width: 20.w,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: cs.primary,
          ),
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Assets.images.googleLogo.svg(height: 20.h),
            SizedBox(width: 12.w),
            AppTextBodyMd(
              'Continue with Google',
              style: context.theme.textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
