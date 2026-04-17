import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:expense_tracker/features/auth/presentation/cubit/login_cubit.dart';
import 'package:expense_tracker/features/auth/presentation/cubit/login_state.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = '/login';

  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            _buildBackgroundAccents(),
            const SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _AppIdentitySection(),
                      SizedBox(height: 48),
                      _AuthenticationCanvas(),
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

  Widget _buildBackgroundAccents() {
    return Stack(
      children: [
        Positioned(
          top: -100,
          left: -100,
          child: Container(
            width: 384,
            height: 384,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF2B8CEE).withOpacity(0.05),
            ),
          ),
        ),
        Positioned(
          bottom: 200,
          right: -100,
          child: Container(
            width: 320,
            height: 320,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF2B8CEE).withOpacity(0.1),
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
    return Column(
      children: [
        // App Icon Mockup
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF2B8CEE).withOpacity(0.1),
                blurRadius: 40,
                spreadRadius: 10,
              )
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              'https://placeholder.com/logo', // Replace with actual logo
              errorBuilder: (context, _, __) => const Icon(
                Icons.account_balance_wallet_rounded,
                size: 40,
                color: Color(0xFF2B8CEE),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Luminous Slate',
          style: GoogleFonts.manrope(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            letterSpacing: -1.5,
            color: const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: 280,
          child: Text(
            'Experience the next generation of financial intelligence and asset management.',
            textAlign: TextAlign.center,
            style: GoogleFonts.manrope(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF64748B),
              height: 1.5,
            ),
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state.isSuccess) {
            // Note: The actual redirect should happen in the router via an auth state listener,
            // but for this UI demonstration, we simulate success state.
            // context.go(HomeScreen.routeName);
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
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          side: const BorderSide(color: Color(0xFFE2E8F0)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/1200px-Google_%22G%22_logo.svg.png',
                    height: 20,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.g_mobiledata, color: Colors.blue),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Continue with Google',
                    style: GoogleFonts.manrope(
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0F172A),
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
