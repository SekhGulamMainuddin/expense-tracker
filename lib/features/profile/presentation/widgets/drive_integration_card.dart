import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:expense_tracker/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:expense_tracker/features/profile/presentation/cubit/profile_state.dart';

class DriveIntegrationCard extends StatelessWidget {
  const DriveIntegrationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 10,
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                right: -20,
                top: -20,
                child: Icon(
                  Icons.cloud_queue,
                  size: 100,
                  color: Colors.black.withOpacity(0.03),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _titleRow(),
                  const SizedBox(height: 16),
                  Text(
                    'Your financial documents and ledger exports are '
                    'automatically synchronized with your Cloud Storage '
                    'for seamless accessibility.',
                    style: GoogleFonts.manrope(
                      color: const Color(0xFF64748B),
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _statusRow(state),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _titleRow() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF2B8CEE).withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.add_to_drive, color: Color(0xFF2B8CEE)),
        ),
        const SizedBox(width: 16),
        Text(
          'Google Drive Connected',
          style: GoogleFonts.manrope(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _statusRow(ProfileState state) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFD1FAE5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            state.isSyncing ? 'Active Sync' : 'Sync Paused',
            style: const TextStyle(
              color: Color(0xFF065F46),
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Spacer(),
        TextButton(
          onPressed: () {},
          child: const Text(
            'Manage Permissions',
            style: TextStyle(
              color: Color(0xFF2B8CEE),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
