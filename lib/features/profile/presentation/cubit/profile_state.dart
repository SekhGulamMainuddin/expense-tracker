sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class ProfileLoading extends ProfileState {}

final class ProfileLoaded extends ProfileState {
  final bool isDriveConnected;
  final bool isSyncing;
  final String name;
  final String email;
  final String profileImageUrl;

  ProfileLoaded({
    required this.isDriveConnected,
    required this.name,
    required this.email,
    required this.profileImageUrl,
    this.isSyncing = false,
  });

  ProfileLoaded copyWith({
    bool? isDriveConnected,
    bool? isSyncing,
    String? name,
    String? email,
    String? profileImageUrl,
  }) {
    return ProfileLoaded(
      isDriveConnected: isDriveConnected ?? this.isDriveConnected,
      isSyncing: isSyncing ?? this.isSyncing,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }
}

final class ProfileFailure extends ProfileState {
  final String errorMessage;

  ProfileFailure(this.errorMessage);
}
