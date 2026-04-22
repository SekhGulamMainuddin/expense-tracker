class SettingsCategory {
  const SettingsCategory({
    required this.id,
    required this.title,
    required this.icon,
    required this.color,
    this.parentId,
    this.children = const [],
  });

  final int id;
  final String title;
  final String icon;
  final int color;
  final int? parentId;
  final List<SettingsCategory> children;

  SettingsCategory copyWith({
    int? id,
    String? title,
    String? icon,
    int? color,
    int? parentId,
    List<SettingsCategory>? children,
  }) {
    return SettingsCategory(
      id: id ?? this.id,
      title: title ?? this.title,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      parentId: parentId ?? this.parentId,
      children: children ?? this.children,
    );
  }
}
