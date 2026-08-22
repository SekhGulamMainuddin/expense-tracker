import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/exchange_rate_response.dart';

part 'exchange_rate_remote_data_source.g.dart';

/// Frankfurter is a free, key-less ECB rate mirror. It updates once per
/// working day, which is why the cache TTL is measured in hours, not minutes.
///
/// Points at the canonical host: the older `api.frankfurter.app` only answers
/// with a 301 to this one, so relying on it would make every sync depend on
/// redirect-following.
@RestApi(baseUrl: 'https://api.frankfurter.dev/v1')
abstract class ExchangeRateRemoteDataSource {
  factory ExchangeRateRemoteDataSource(Dio dio, {String baseUrl}) =
      _ExchangeRateRemoteDataSource;

  @GET('/latest')
  Future<ExchangeRateResponse> getLatestRates({
    @Query('base') required String base,
    @Query('symbols') required String symbols,
  });
}
