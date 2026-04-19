import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:expense_tracker/features/profile/presentation/cubit/profile_state.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/styles/app_palette.dart';
import '../../../../core/styles/app_texts.dart';
import '../../../../core/utils/ui_extensions.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    return BlocBuilder<ProfileCubit, ProfileState>(
      bloc: getIt<ProfileCubit>(),
      builder: (context, state) {
        final name = state is ProfileLoaded ? state.name : 'User';
        final email = state is ProfileLoaded ? state.email : 'Loading profile...';
        final imageUrl = state is ProfileLoaded ? state.profileImageUrl : '';

        return Column(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  padding: EdgeInsets.all(4.r),
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerHigh,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppPalette.ambientShadow.withOpacity(0.45),
                        blurRadius: 24.r,
                        offset: Offset(0, 10.h),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 56.r,
                    backgroundColor: cs.surfaceContainerHighest,
                    backgroundImage: imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
                    child: imageUrl.isEmpty ? Icon(Icons.person, size: 40.r, color: cs.onSurfaceVariant) : null,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            AppTextHeadlineSm(name),
            AppTextBodyMd(
              email,
              color: cs.onSurfaceVariant,
            ),
          ],
        );
      },
    );
  }
}
