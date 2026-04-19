import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:expense_tracker/features/profile/presentation/cubit/profile_state.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/styles/app_palette.dart';
import '../../../../core/styles/app_texts.dart';
import '../../../../core/utils/ui_extensions.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
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
                    backgroundImage: NetworkImage(state.profileImageUrl),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            AppTextHeadlineSm(
              state.name,
              
            ),
            AppTextBodyMd(
              state.email,
              
              color: cs.onSurfaceVariant,
            ),
          ],
        );
      },
    );
  }
}
