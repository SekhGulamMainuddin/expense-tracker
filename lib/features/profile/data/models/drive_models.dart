class GoogleDriveFile {
  final String id;
  final String name;

  GoogleDriveFile({required this.id, required this.name});

  factory GoogleDriveFile.fromJson(Map<String, dynamic> json) {
    return GoogleDriveFile(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
      };
}

class GoogleDriveListResponse {
  final List<GoogleDriveFile> files;

  GoogleDriveListResponse({required this.files});

  factory GoogleDriveListResponse.fromJson(Map<String, dynamic> json) {
    final rawFiles = json['files'];
    final files = rawFiles is List
        ? rawFiles
            .whereType<Map<String, dynamic>>()
            .map(GoogleDriveFile.fromJson)
            .toList()
        : const <GoogleDriveFile>[];

    return GoogleDriveListResponse(files: files);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'files': files.map((file) => file.toJson()).toList(),
      };
}
