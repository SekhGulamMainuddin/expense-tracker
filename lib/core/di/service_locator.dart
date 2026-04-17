import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  getIt
    ..registerLazySingleton<Dio>(() => Dio())
  ;
}
