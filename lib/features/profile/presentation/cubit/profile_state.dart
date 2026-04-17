class ProfileState {
  final String name;
  final String email;
  final bool isSyncing;
  final String profileImageUrl;

  const ProfileState({
    required this.name,
    required this.email,
    required this.isSyncing,
    required this.profileImageUrl,
  });

  ProfileState copyWith({bool? isSyncing}) {
    return ProfileState(
      name: name,
      email: email,
      profileImageUrl: profileImageUrl,
      isSyncing: isSyncing ?? this.isSyncing,
    );
  }
}
