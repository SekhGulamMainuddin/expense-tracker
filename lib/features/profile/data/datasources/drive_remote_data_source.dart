import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

import '../models/drive_models.dart';

class DriveRemoteDataSource {
  DriveRemoteDataSource(this._dio);

  final Dio _dio;

  static const _driveBaseUrl = 'https://www.googleapis.com/drive/v3';
  static const _uploadBaseUrl =
      'https://www.googleapis.com/upload/drive/v3/files';

  Future<GoogleDriveListResponse> findFile({
    String spaces = 'appDataFolder',
    required String query,
    String fields = 'files(id,name)',
    int pageSize = 1,
  }) async {
    final response = await _dio.get(
      '$_driveBaseUrl/files',
      queryParameters: {
        'spaces': spaces,
        'q': query,
        'fields': fields,
        'pageSize': pageSize,
      },
    );
    return GoogleDriveListResponse.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );
  }

  Future<dynamic> downloadFile({
    required String fileId,
    String alt = 'media',
  }) async {
    final response = await _dio.get(
      '$_driveBaseUrl/files/$fileId',
      queryParameters: {'alt': alt},
    );
    return response.data;
  }

  Future<void> deleteFile({
    required String fileId,
  }) async {
    await _dio.delete('$_driveBaseUrl/files/$fileId');
  }

  Future<GoogleDriveFile> uploadMultipartFile({
    required String metadata,
    required String body,
  }) async {
    final formData = FormData.fromMap({
      'metadata': MultipartFile.fromString(
        metadata,
        contentType: MediaType.parse('application/json'),
      ),
      'media': MultipartFile.fromString(
        body,
        contentType: MediaType.parse('application/json'),
      ),
    });

    final response = await _dio.post(
      '$_uploadBaseUrl?uploadType=multipart',
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );
    return GoogleDriveFile.fromJson(Map<String, dynamic>.from(response.data as Map));
  }

  Future<GoogleDriveFile> uploadMultipartBinary({
    required String metadata,
    required List<int> bytes,
  }) async {
    final formData = FormData.fromMap({
      'metadata': MultipartFile.fromString(
        metadata,
        contentType: MediaType.parse('application/json'),
      ),
      'media': MultipartFile.fromBytes(
        bytes,
        contentType: MediaType.parse('application/octet-stream'),
      ),
    });

    final response = await _dio.post(
      '$_uploadBaseUrl?uploadType=multipart',
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );
    return GoogleDriveFile.fromJson(Map<String, dynamic>.from(response.data as Map));
  }

  Future<GoogleDriveFile> updateFileContent({
    required String fileId,
    required String body,
    String contentType = 'application/json',
  }) async {
    final response = await _dio.patch(
      '$_uploadBaseUrl/$fileId?uploadType=media',
      data: body,
      options: Options(contentType: contentType),
    );
    return GoogleDriveFile.fromJson(Map<String, dynamic>.from(response.data as Map));
  }

  Future<GoogleDriveFile> updateBinaryContent({
    required String fileId,
    required List<int> bytes,
    String contentType = 'application/octet-stream',
  }) async {
    final response = await _dio.patch(
      '$_uploadBaseUrl/$fileId?uploadType=media',
      data: bytes,
      options: Options(contentType: contentType),
    );
    return GoogleDriveFile.fromJson(Map<String, dynamic>.from(response.data as Map));
  }

  Future<List<int>> downloadBinary({
    required String fileId,
    String alt = 'media',
  }) async {
    final response = await _dio.get<List<int>>(
      '$_driveBaseUrl/files/$fileId',
      queryParameters: {'alt': alt},
      options: Options(responseType: ResponseType.bytes),
    );
    return response.data ?? const <int>[];
  }
}
