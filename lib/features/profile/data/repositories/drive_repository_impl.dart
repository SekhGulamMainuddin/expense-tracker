import 'dart:convert';
import 'package:expense_tracker/core/error/result.dart';
import '../../../auth/domain/auth_repository.dart';
import '../../domain/repositories/drive_repository.dart';
import '../datasources/drive_remote_data_source.dart';

class DriveRepositoryImpl implements DriveRepository {
  DriveRepositoryImpl({
    required DriveRemoteDataSource remoteDataSource,
    required AuthRepository authRepository,
  })  : _remoteDataSource = remoteDataSource,
        _authRepository = authRepository;

  final DriveRemoteDataSource _remoteDataSource;
  final AuthRepository _authRepository;

  Future<String?> _getAccessToken() async {
    return _authRepository.getAccessToken();
  }

  @override
  ResultFuture<String> uploadFile({
    required String fileName,
    required Map<String, dynamic> jsonData,
  }) async {
    try {
      final token = await _getAccessToken();
      if (token == null) return Error(AuthFailure('Not signed in'));

      final existingId = await _findFileId(fileName);
      final body = jsonEncode(jsonData);

      if (existingId != null) {
        // Update existing file
        await _remoteDataSource.updateFileContent(
          fileId: existingId,
          body: body,
        );
        return Success(existingId);
      } else {
        // Create new file
        final metadata = jsonEncode({
          'name': fileName,
          'parents': ['appDataFolder'],
        });
        final response = await _remoteDataSource.uploadMultipartFile(
          metadata: metadata,
          body: body,
        );
        return Success(response.id);
      }
    } catch (e) {
      return Error(DriveFailure(e.toString()));
    }
  }

  @override
  ResultFuture<String> uploadBinary({
    required String fileName,
    required List<int> bytes,
  }) async {
    try {
      final token = await _getAccessToken();
      if (token == null) return Error(AuthFailure('Not signed in'));

      final existingId = await _findFileId(fileName);

      if (existingId != null) {
        await _remoteDataSource.updateBinaryContent(
          fileId: existingId,
          bytes: bytes,
        );
        return Success(existingId);
      } else {
        final metadata = jsonEncode({
          'name': fileName,
          'parents': ['appDataFolder'],
        });
        final response = await _remoteDataSource.uploadMultipartBinary(
          metadata: metadata,
          bytes: bytes,
        );
        return Success(response.id);
      }
    } catch (e) {
      return Error(DriveFailure(e.toString()));
    }
  }

  @override
  ResultFuture<Map<String, dynamic>?> downloadFile(String fileName) async {
    try {
      final fileId = await _findFileId(fileName);
      if (fileId == null) return const Success(null);

      final response = await _remoteDataSource.downloadFile(fileId: fileId);
      return Success(response as Map<String, dynamic>);
    } catch (e) {
      return Error(DriveFailure(e.toString()));
    }
  }

  @override
  ResultFuture<List<int>?> downloadBinary(String fileName) async {
    try {
      final fileId = await _findFileId(fileName);
      if (fileId == null) return const Success(null);

      final response = await _remoteDataSource.downloadBinary(fileId: fileId);
      return Success(response);
    } catch (e) {
      return Error(DriveFailure(e.toString()));
    }
  }

  @override
  ResultVoid deleteFile(String fileName) async {
    try {
      final fileId = await _findFileId(fileName);
      if (fileId == null) return const Success(null);

      await _remoteDataSource.deleteFile(fileId: fileId);
      return const Success(null);
    } catch (e) {
      return Error(DriveFailure(e.toString()));
    }
  }

  Future<String?> _findFileId(String fileName) async {
    final response = await _remoteDataSource.findFile(
      query: "name = '$fileName'",
    );
    if (response.files.isEmpty) return null;
    return response.files.first.id;
  }
}
