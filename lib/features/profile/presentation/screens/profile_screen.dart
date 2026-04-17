import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
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
    return BlocProvider(
      create: (_) => ProfileCubit(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: _buildAppBar(context),
        body: Stack(
          children: [
            // Hero Glow Effect
            Positioned(
              top: -100,
              left: -50,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF2B8CEE).withOpacity(0.08),
                ),
              ),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                children: [
                  const ProfileHeader(),
                  const SizedBox(height: 40),
                  const DriveIntegrationCard(),
                  const SizedBox(height: 40),
                  _dangerZone(context),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFFF8FAFC),
      elevation: 0.5,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
        onPressed: () => context.pop(),
      ),
      title: Text(
        'Profile',
        style: GoogleFonts.manrope(
          fontWeight: FontWeight.w800,
          color: const Color(0xFF0F172A),
          letterSpacing: -1,
        ),
      ),
    );
  }

  Widget _dangerZone(BuildContext context) {
    return Column(
      children: [
        OutlinedButton.icon(
          onPressed: () {
            context.showAppAlertDialog(
              content: const DeleteConfirmationDialog(),
            );
          },
          icon: const Icon(Icons.delete_forever, size: 18),
          label: const Text('Delete Account'),
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFFEF4444),
            side: const BorderSide(color: Color(0xFFFEE2E2)),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            minimumSize: const Size(double.infinity, 56),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Permanently delete your account and all associated '
          'ledger data. This action cannot be undone.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Color(0xFF94A3B8), fontSize: 10),
        ),
      ],
    );
  }
}

