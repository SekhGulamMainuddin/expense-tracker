import 'package:json_annotation/json_annotation.dart';

part 'drive_models.g.dart';

@JsonSerializable()
class GoogleDriveFile {
  final String id;
  final String name;

  GoogleDriveFile({required this.id, required this.name});

  factory GoogleDriveFile.fromJson(Map<String, dynamic> json) => _$GoogleDriveFileFromJson(json);
  Map<String, dynamic> toJson() => _$GoogleDriveFileToJson(this);
}

@JsonSerializable()
class GoogleDriveListResponse {
  final List<GoogleDriveFile> files;

  GoogleDriveListResponse({required this.files});

  factory GoogleDriveListResponse.fromJson(Map<String, dynamic> json) => _$GoogleDriveListResponseFromJson(json);
  Map<String, dynamic> toJson() => _$GoogleDriveListResponseToJson(this);
}
