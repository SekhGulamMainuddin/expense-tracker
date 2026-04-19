import 'package:expense_tracker/core/error/result.dart';

abstract interface class DriveRepository {
  ResultFuture<String> uploadFile({
    required String fileName,
    required Map<String, dynamic> jsonData,
  });

  ResultFuture<String> uploadBinary({
    required String fileName,
    required List<int> bytes,
  });

  ResultFuture<Map<String, dynamic>?> downloadFile(String fileName);

  ResultFuture<List<int>?> downloadBinary(String fileName);

  ResultVoid deleteFile(String fileName);
}
