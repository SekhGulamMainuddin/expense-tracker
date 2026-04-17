import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:expense_tracker/features/profile/presentation/cubit/google_drive_cubit.dart';
import 'package:expense_tracker/features/profile/presentation/cubit/google_drive_state.dart';

class GoogleDrivePermissionDialog extends StatelessWidget {
  const GoogleDrivePermissionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GoogleDriveCubit(),
      child: BlocListener<GoogleDriveCubit, GoogleDriveState>(
        listener: (context, state) {
          if (state.isSuccess) Navigator.pop(context, true);
        },
        child: Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          backgroundColor: Colors.white,
          clipBehavior: Clip.antiAlias,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeroSection(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(32, 32, 32, 10),
                  child: Column(
                    children: [
                      Text(
                        'Backup to Google Drive',
                        style: GoogleFonts.manrope(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Securely store and sync your financial records. Your data is encrypted and only accessible by you.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.manrope(
                          fontSize: 14,
                          color: const Color(0xFF64748B),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 32),
                      _buildFeatureList(),
                      const SizedBox(height: 32),
                      _buildActionButtons(context),
                    ],
                  ),
                ),
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      height: 160,
      width: double.infinity,
      color: const Color(0xFFF8FAFC),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Simulated Light Orbs
          Positioned(
            left: 20,
            top: 20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF2B8CEE).withOpacity(0.1),
              ),
            ),
          ),
          Positioned(
            right: 20,
            bottom: 20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFB923C).withOpacity(0.1),
              ),
            ),
          ),
          // Drive Icon
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                )
              ],
            ),
            child: const Icon(Icons.cloud_queue_rounded, size: 48, color: Color(0xFF2B8CEE)),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureList() {
    return Column(
      children: [
        _buildChecklistItem(
          icon: Icons.shield_outlined,
          color: const Color(0xFF2B8CEE),
          title: 'End-to-End Encryption',
          subtitle: 'Private key security',
        ),
        const SizedBox(height: 12),
        _buildChecklistItem(
          icon: Icons.sync_rounded,
          color: const Color(0xFFFB923C),
          title: 'Real-time Sync',
          subtitle: 'Access from any device',
        ),
      ],
    );
  }

  Widget _buildChecklistItem({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0).withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 10, color: Color(0xFF64748B)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return BlocBuilder<GoogleDriveCubit, GoogleDriveState>(
      builder: (context, state) {
        return Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: state.isGranting ? null : () => context.read<GoogleDriveCubit>().grantAccess(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2B8CEE),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: state.isGranting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Text('Grant Access', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
                foregroundColor: const Color(0xFF64748B),
              ),
              child: const Text('Maybe Later', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      width: double.infinity,
      color: const Color(0xFFF8FAFC),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.lock_outline, size: 14, color: Color(0xFF94A3B8)),
          const SizedBox(width: 8),
          Text(
            'VERIFIED SECURE CONNECTION',
            style: GoogleFonts.manrope(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: const Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }
}
