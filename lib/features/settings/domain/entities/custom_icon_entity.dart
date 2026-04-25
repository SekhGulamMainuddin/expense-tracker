import 'package:equatable/equatable.dart';

class CustomIconEntity extends Equatable {
  const CustomIconEntity({
    required this.id,
    required this.name,
    required this.iconUrl,
  });

  final int id;
  final String name;
  final String iconUrl;

  @override
  List<Object?> get props => [id, name, iconUrl];
}
