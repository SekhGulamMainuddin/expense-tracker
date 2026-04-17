import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:expense_tracker/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:expense_tracker/features/profile/presentation/cubit/profile_state.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return Column(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 56,
                    backgroundImage: NetworkImage(state.profileImageUrl),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Color(0xFF2B8CEE),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.edit, size: 14, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              state.name,
              style: GoogleFonts.manrope(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              state.email,
              style: GoogleFonts.manrope(
                color: const Color(0xFF94A3B8),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        );
      },
    );
  }
}
