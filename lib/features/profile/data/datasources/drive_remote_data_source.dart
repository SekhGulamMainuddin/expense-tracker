import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/drive_models.dart';

part 'drive_remote_data_source.g.dart';

@RestApi()
abstract class DriveRemoteDataSource {
  factory DriveRemoteDataSource(Dio dio, {String baseUrl}) = _DriveRemoteDataSource;

  @GET('/files')
  Future<GoogleDriveListResponse> findFile({
    @Query('spaces') String spaces = 'appDataFolder',
    @Query('q') required String query,
    @Query('fields') String fields = 'files(id,name)',
    @Query('pageSize') int pageSize = 1,
  });

  @GET('/files/{fileId}')
  Future<dynamic> downloadFile({
    @Path('fileId') required String fileId,
    @Query('alt') String alt = 'media',
  });

  @DELETE('/files/{fileId}')
  Future<void> deleteFile({
    @Path('fileId') required String fileId,
  });

  @POST('https://www.googleapis.com/upload/drive/v3/files?uploadType=multipart')
  @MultiPart()
  Future<GoogleDriveFile> uploadMultipartFile({
    @Part(name: 'metadata', contentType: 'application/json') required String metadata,
    @Part(name: 'media', contentType: 'application/json') required String body,
  });

  @POST('https://www.googleapis.com/upload/drive/v3/files?uploadType=multipart')
  @MultiPart()
  Future<GoogleDriveFile> uploadMultipartBinary({
    @Part(name: 'metadata', contentType: 'application/json') required String metadata,
    @Part(name: 'media', contentType: 'application/octet-stream') required List<int> bytes,
  });

  @PATCH('https://www.googleapis.com/upload/drive/v3/files/{fileId}?uploadType=media')
  Future<GoogleDriveFile> updateFileContent({
    @Path('fileId') required String fileId,
    @Body() required String body,
    @Header('Content-Type') String contentType = 'application/json',
  });

  @PATCH('https://www.googleapis.com/upload/drive/v3/files/{fileId}?uploadType=media')
  Future<GoogleDriveFile> updateBinaryContent({
    @Path('fileId') required String fileId,
    @Body() required List<int> bytes,
    @Header('Content-Type') String contentType = 'application/octet-stream',
  });

  @GET('/files/{fileId}')
  @DioResponseType(ResponseType.bytes)
  Future<List<int>> downloadBinary({
    @Path('fileId') required String fileId,
    @Query('alt') String alt = 'media',
  });
}
