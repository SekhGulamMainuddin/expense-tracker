import 'package:expense_tracker/features/auth/presentation/cubit/login_cubit.dart';
import 'package:expense_tracker/features/auth/presentation/cubit/login_state.dart';
import 'package:expense_tracker/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/ui_extensions.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = '/login';

  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(),
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
                      const _AuthenticationCanvas(),
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
}

class _AppIdentitySection extends StatelessWidget {
  const _AppIdentitySection();

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Column(
      children: [
        // App Icon Mockup
        Container(
          width: 80.w,
          height: 80.h,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withOpacity(0.1),
                blurRadius: 40.r,
                spreadRadius: 10.r,
              )
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: Assets.branding.launcherIcon.image(),
          ),
        ),
        SizedBox(height: 24.h),
        Text(
          'Expense Tracker',
          style: theme.textTheme.headlineLarge,
        ),
        SizedBox(height: 12.h),
        SizedBox(
          width: 280.w,
          child: Text(
            'Experience the next generation of financial intelligence and asset management.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
          ),
        ),
      ],
    );
  }
}

class _AuthenticationCanvas extends StatelessWidget {
  const _AuthenticationCanvas();

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(32.r),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.5)),
      ),
      child: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state.isSuccess) {
            // Success logic
          }
        },
        child: BlocBuilder<LoginCubit, LoginState>(
          builder: (context, state) {
            return Column(
              children: [
                _GoogleSignInButton(
                  isLoading: state.isAuthenticating,
                  onPressed: () => context.read<LoginCubit>().signInWithGoogle(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _GoogleSignInButton extends StatelessWidget {
  const _GoogleSignInButton({required this.isLoading, required this.onPressed});

  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: theme.colorScheme.surface,
          side: BorderSide(color: theme.colorScheme.outline),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        ),
        child: isLoading
            ? SizedBox(
                height: 20.h,
                width: 20.w,
                child: const CircularProgressIndicator(strokeWidth: 2),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Assets.images.googleLogo.svg(height: 20.h),
                  SizedBox(width: 12.w),
                  Text(
                    'Continue with Google',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}



