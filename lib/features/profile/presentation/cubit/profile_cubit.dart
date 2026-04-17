import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/features/profile/presentation/cubit/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit()
      : super(
          const ProfileState(
            name: 'Sekh Gulam Mainuddin',
            email: 'example@gmail.com',
            isSyncing: true,
            profileImageUrl: 'https://example.com/profile.jpg',
          ),
        );

  void toggleSync() => emit(state.copyWith(isSyncing: !state.isSyncing));
}
