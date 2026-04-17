import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:expense_tracker/features/profile/presentation/cubit/delete_account_cubit.dart';
import 'package:expense_tracker/features/profile/presentation/cubit/delete_account_state.dart';

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
            // Add navigation to login or splash screen here
          }
        },
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 340),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 40, 32, 32),
                child: Column(
                  children: [
                    _buildWarningIcon(),
                    const SizedBox(height: 24),
                    Text(
                      'Delete Account?',
                      style: GoogleFonts.manrope(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'This action is irreversible. All your transaction history, '
                      'saved reports, and personalized insights will be permanently removed.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        color: const Color(0xFF64748B),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 32),
                    _buildActionButtons(context),
                  ],
                ),
              ),
              // Decorative Bottom Gradient Line
              Container(
                height: 6,
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
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.red.withOpacity(0.1),
                blurRadius: 20,
                spreadRadius: 10,
              ),
            ],
          ),
        ),
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: const Color(0xFFFEF2F2),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFFEE2E2)),
          ),
          child: const Icon(
            Icons.warning_rounded,
            color: Color(0xFFEF4444),
            size: 32,
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
              height: 56,
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
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: state.isDeleting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'YES, DELETE',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  foregroundColor: const Color(0xFF64748B),
                ),
                child: const Text(
                  'CANCEL',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
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
