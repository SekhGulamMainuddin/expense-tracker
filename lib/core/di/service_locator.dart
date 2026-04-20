import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:expense_tracker/features/auth/data/repositories/auth_repository_impl.dart';

import 'package:expense_tracker/features/auth/presentation/cubit/login_cubit.dart';
import 'package:expense_tracker/features/home/presentation/cubit/finance_cubit.dart';
import 'package:expense_tracker/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:expense_tracker/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:expense_tracker/features/profile/domain/repositories/drive_repository.dart';
import 'package:expense_tracker/features/profile/data/repositories/drive_repository_impl.dart';
import 'package:expense_tracker/features/profile/data/datasources/drive_remote_data_source.dart';
import 'package:expense_tracker/core/database/app_database.dart';
import 'package:expense_tracker/features/settings/presentation/cubit/subcategory_cubit.dart';

import '../../features/auth/domain/auth_repository.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // External
  getIt.registerLazySingleton<Dio>(() => Dio());

  // Named Dio for Google Drive
  getIt.registerLazySingleton<Dio>(
        () {
      final dio = Dio(BaseOptions(baseUrl: 'https://www.googleapis.com/drive/v3'));
      dio.interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) async {
          final authRepository = getIt<AuthRepository>();
          final token = await authRepository.getDriveAccessToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ));
      return dio;
    },
    instanceName: 'drive_dio',
  );

  getIt.registerLazySingleton<AppDatabase>(() => AppDatabase());
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<GoogleSignIn>(() => GoogleSignIn.instance);

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(
      firebaseAuth: getIt(),
      googleSignIn: getIt(),
    ),
  );

  // Drive Data Source & Repository
  getIt.registerLazySingleton<DriveRemoteDataSource>(
        () => DriveRemoteDataSource(getIt(instanceName: 'drive_dio')),
  );

  getIt.registerLazySingleton<DriveRepository>(
        () => DriveRepositoryImpl(
      remoteDataSource: getIt(),
      authRepository: getIt(),
    ),
  );

  // Cubits
  getIt.registerFactory<LoginCubit>(() => LoginCubit(getIt(), getIt()));
  getIt.registerLazySingleton<FinanceCubit>(() => FinanceCubit());
  getIt.registerLazySingleton<ProfileCubit>(() => ProfileCubit(getIt(), getIt()));
  getIt.registerLazySingleton<SettingsCubit>(() => SettingsCubit(getIt()));
  getIt.registerFactory<SubcategoryCubit>(() => SubcategoryCubit());
}
