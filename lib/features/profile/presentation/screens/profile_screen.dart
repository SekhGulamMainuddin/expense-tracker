import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/core/di/service_locator.dart';
import 'package:expense_tracker/core/utils/ui_extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:expense_tracker/core/database/app_database.dart';
import 'package:expense_tracker/core/database/seed/database_seeder.dart';
import 'package:expense_tracker/core/styles/app_dimensions.dart';
import 'package:expense_tracker/core/styles/app_texts.dart';
import 'package:expense_tracker/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:expense_tracker/features/profile/presentation/widgets/profile_header.dart';
import 'package:expense_tracker/features/profile/presentation/widgets/drive_integration_card.dart';
import 'package:expense_tracker/features/profile/presentation/widgets/delete_confirmation_dialog.dart';

import '../cubit/profile_state.dart';

import 'package:expense_tracker/features/auth/presentation/screens/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile';

  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    getIt<ProfileCubit>().checkDriveStatus();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return BlocListener<ProfileCubit, ProfileState>(
      bloc: getIt<ProfileCubit>(),
      listener: (context, state) {
        if (state is ProfileInitial) {
          context.go(LoginScreen.routeName);
        } else if (state is ProfileFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
        }
      },
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: Stack(
          children: [
            Positioned(
              top: -100.h,
              left: -50.w,
              child: Container(
                width: 300.w,
                height: 300.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.primary.withValues(alpha: 0.08),
                ),
              ),
            ),
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
              child: Column(
                children: [
                  const ProfileHeader(),
                  SizedBox(height: 40.h),
                  const DriveIntegrationCard(),
                  SizedBox(height: 40.h),
                  if(kDebugMode) ...[
                    _seedDataButton(context),
                    SizedBox(height: 16.h),
                  ],
                  _signOutButton(context),
                  SizedBox(height: 16.h),
                  _dangerZone(context),
                  SizedBox(height: 100.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _signOutButton(BuildContext context) {
    final cs = context.theme.colorScheme;
    return OutlinedButton.icon(
      onPressed: () {
        getIt<ProfileCubit>().signOut();
      },
      icon: Icon(Icons.logout, size: 18.r),
      label: AppTextBodyMd(
        'profile.sign_out',
        style: context.theme.textTheme.bodyMedium!.copyWith(
          fontWeight: FontWeight.w600,
        ),
        color: cs.onSurface,
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: cs.onSurface,
        side: BorderSide(color: cs.outlineVariant),
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 32.w),
        shape: RoundedRectangleBorder(borderRadius: AppRadii.full),
        minimumSize: Size(double.infinity, 56.h),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final cs = context.theme.colorScheme;
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: cs.onSurface, size: 24.r),
        onPressed: () => context.pop(),
      ),
      title: const AppTextHeadlineSm('profile.title'),
    );
  }

  Widget _dangerZone(BuildContext context) {
    final cs = context.theme.colorScheme;
    return Column(
      children: [
        OutlinedButton.icon(
          onPressed: () async {
            context.showAppAlertDialog(
              content: const DeleteConfirmationDialog(),
            );
          },
          icon: Icon(Icons.delete_forever, size: 18.r),
          label: AppTextBodyMd(
            'profile.delete_account',

            style: context.theme.textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.w600,
            ),
            color: cs.error,
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: cs.error,
            side: BorderSide(color: cs.error.withValues(alpha: 0.35)),
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 32.w),
            shape: RoundedRectangleBorder(borderRadius: AppRadii.full),
            minimumSize: Size(double.infinity, 56.h),
          ),
        ),
        SizedBox(height: 16.h),
        AppTextLabelSm(
          'profile.delete_warning',

          textAlign: TextAlign.center,
          color: cs.onSurfaceVariant,
          style: context.theme.textTheme.labelSmall!.copyWith(height: 1.45),
        ),
      ],
    );
  }

  Widget _seedDataButton(BuildContext context) {
    final cs = context.theme.colorScheme;
    return OutlinedButton.icon(
      onPressed: () async {
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Seed Mock Data?'),
            content: const Text(
                'This will DELETE all current data and generate 3 years of mock transactions. Are you sure?'),
            actions: [
              TextButton(onPressed: () => context.pop(false), child: const Text('Cancel')),
              TextButton(onPressed: () => context.pop(true), child: const Text('Seed')),
            ],
          ),
        );

        if (confirmed == true) {
          if (!context.mounted) return;
          
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const Center(child: CircularProgressIndicator()),
          );
          
          try {
            await DatabaseSeeder.seed(getIt<AppDatabase>());
            if (context.mounted) {
              context.pop(); // Close loader
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Database seeded successfully!')),
              );
            }
          } catch (e) {
            print("SEKH BRO $e");
            if (context.mounted) {
              context.pop(); // Close loader
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Seeding failed: $e')),
              );
            }
          }
        }
      },
      icon: Icon(Icons.storage, size: 18.r),
      label: AppTextBodyMd(
        'Seed Mock Data',
        style: context.theme.textTheme.bodyMedium!.copyWith(
          fontWeight: FontWeight.w600,
        ),
        color: cs.primary,
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: cs.primary,
        side: BorderSide(color: cs.primary.withValues(alpha: 0.3)),
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 32.w),
        shape: RoundedRectangleBorder(borderRadius: AppRadii.full),
        minimumSize: Size(double.infinity, 56.h),
      ),
    );
  }
}
