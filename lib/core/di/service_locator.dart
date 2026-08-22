import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:expense_tracker/features/auth/data/repositories/auth_repository_impl.dart';

import 'package:expense_tracker/features/auth/presentation/cubit/login_cubit.dart';
import 'package:expense_tracker/features/add_expense/data/datasources/add_expense_local_data_source.dart';
import 'package:expense_tracker/features/add_expense/data/repositories/add_expense_repository_impl.dart';
import 'package:expense_tracker/features/add_expense/domain/repositories/add_expense_repository.dart';
import 'package:expense_tracker/features/home/presentation/cubit/finance_cubit.dart';
import 'package:expense_tracker/features/home/presentation/cubit/category_chart_cubit.dart';
import 'package:expense_tracker/features/home/data/datasources/finance_local_data_source.dart';
import 'package:expense_tracker/features/home/data/repositories/finance_repository_impl.dart';
import 'package:expense_tracker/features/home/domain/repositories/finance_repository.dart';
import 'package:expense_tracker/features/profile/data/datasources/delete_account_local_data_source.dart';
import 'package:expense_tracker/features/profile/data/repositories/delete_account_repository_impl.dart';
import 'package:expense_tracker/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:expense_tracker/features/profile/presentation/cubit/delete_account_cubit.dart';
import 'package:expense_tracker/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:expense_tracker/features/transactions/data/datasources/transaction_local_data_source.dart';
import 'package:expense_tracker/features/transactions/data/repositories/transaction_repository_impl.dart';
import 'package:expense_tracker/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:expense_tracker/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:expense_tracker/features/settings/domain/repositories/settings_repository.dart';
import 'package:expense_tracker/features/settings/presentation/cubit/exchange_rate_cubit.dart';
import 'package:expense_tracker/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:expense_tracker/features/profile/domain/repositories/drive_repository.dart';
import 'package:expense_tracker/features/profile/data/repositories/drive_repository_impl.dart';
import 'package:expense_tracker/features/profile/data/datasources/drive_remote_data_source.dart';
import 'package:expense_tracker/core/database/app_database.dart';
import 'package:expense_tracker/core/exchange/data/datasources/exchange_rate_local_data_source.dart';
import 'package:expense_tracker/core/exchange/data/datasources/exchange_rate_remote_data_source.dart';
import 'package:expense_tracker/core/exchange/data/repositories/exchange_rate_repository_impl.dart';
import 'package:expense_tracker/core/exchange/domain/repositories/exchange_rate_repository.dart';
import 'package:expense_tracker/features/profile/domain/repositories/delete_account_repository.dart';

import '../../features/auth/domain/auth_repository.dart';

final GetIt getIt = GetIt.instance;

const _driveDioName = 'drive_dio';
const _exchangeDioName = 'exchange_dio';

Future<void> setupServiceLocator() async {
  // External — named Dio for Google Drive (auto-injects bearer token).
  getIt.registerLazySingleton<Dio>(
    () {
      final dio = Dio(
        BaseOptions(baseUrl: 'https://www.googleapis.com/drive/v3'),
      );
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) async {
            final token = await getIt<AuthRepository>().getDriveAccessToken();
            if (token != null) {
              options.headers['Authorization'] = 'Bearer $token';
            }
            return handler.next(options);
          },
        ),
      );
      return dio;
    },
    instanceName: _driveDioName,
  );

  // Plain Dio for the public rates API - deliberately without the Drive
  // auth interceptor, which would leak a Google token to a third party.
  getIt.registerLazySingleton<Dio>(
    () => Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    )),
    instanceName: _exchangeDioName,
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

  getIt.registerLazySingleton<DriveRemoteDataSource>(
    () => DriveRemoteDataSource(getIt(instanceName: _driveDioName)),
  );

  getIt.registerLazySingleton<DriveRepository>(
    () => DriveRepositoryImpl(
      remoteDataSource: getIt(),
      authRepository: getIt(),
    ),
  );

  getIt.registerLazySingleton<DeleteAccountLocalDataSource>(
    () => DeleteAccountLocalDataSource(),
  );

  getIt.registerLazySingleton<DeleteAccountRepository>(
    () => DeleteAccountRepositoryImpl(getIt(), getIt(), getIt()),
  );

  getIt.registerLazySingleton<SettingsLocalDataSource>(
    () {
      final db = getIt<AppDatabase>();
      return SettingsLocalDataSource(
        db.expenseDao,
        db.keyValueStoreDao,
        db.customIconDao,
      );
    },
  );

  getIt.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(getIt()),
  );

  getIt.registerLazySingleton<ExchangeRateRemoteDataSource>(
    () => ExchangeRateRemoteDataSource(getIt(instanceName: _exchangeDioName)),
  );

  getIt.registerLazySingleton<ExchangeRateLocalDataSource>(
    () => ExchangeRateLocalDataSource(getIt<AppDatabase>().keyValueStoreDao),
  );

  getIt.registerLazySingleton<ExchangeRateRepository>(
    () => ExchangeRateRepositoryImpl(
      remoteDataSource: getIt(),
      localDataSource: getIt(),
    ),
  );

  getIt.registerLazySingleton<AddExpenseLocalDataSource>(
    () => AddExpenseLocalDataSource(
      getIt<AppDatabase>().expenseDao,
      getIt<SettingsLocalDataSource>(),
      getIt<ExchangeRateRepository>(),
    ),
  );

  getIt.registerLazySingleton<AddExpenseRepository>(
    () => AddExpenseRepositoryImpl(getIt()),
  );

  getIt.registerLazySingleton<FinanceLocalDataSource>(
    () => FinanceLocalDataSource(
      getIt<AppDatabase>().expenseDao,
      getIt<SettingsLocalDataSource>(),
      getIt<ExchangeRateRepository>(),
    ),
  );

  getIt.registerLazySingleton<FinanceRepository>(
    () => FinanceRepositoryImpl(getIt()),
  );

  getIt.registerLazySingleton<TransactionLocalDataSource>(
    () => TransactionLocalDataSource(
      getIt<AppDatabase>().expenseDao,
      getIt<SettingsLocalDataSource>(),
      getIt<ExchangeRateRepository>(),
    ),
  );

  getIt.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImpl(getIt()),
  );

  // Cubits
  getIt.registerFactory<LoginCubit>(() => LoginCubit(getIt(), getIt()));
  getIt.registerLazySingleton<FinanceCubit>(() => FinanceCubit(getIt()));
  getIt.registerFactory<CategoryChartCubit>(() => CategoryChartCubit(getIt()));
  getIt.registerLazySingleton<ProfileCubit>(() => ProfileCubit(getIt(), getIt()));
  getIt.registerFactory<DeleteAccountCubit>(() => DeleteAccountCubit(getIt()));
  getIt.registerLazySingleton<SettingsCubit>(() => SettingsCubit(getIt()));
  getIt.registerLazySingleton<ExchangeRateCubit>(
    () => ExchangeRateCubit(getIt()),
  );
}

/// Close all DB-backed cubits/singletons and rebuild the service locator.
/// Use after a Drive restore or any operation that replaces the SQLite file
/// so stale DAO references don't linger.
Future<void> resetServiceLocator() async {
  // Close stream-holding cubits before wiping them.
  if (getIt.isRegistered<FinanceCubit>()) {
    await getIt<FinanceCubit>().close();
  }
  if (getIt.isRegistered<SettingsCubit>()) {
    await getIt<SettingsCubit>().close();
  }
  if (getIt.isRegistered<ProfileCubit>()) {
    await getIt<ProfileCubit>().close();
  }
  if (getIt.isRegistered<ExchangeRateCubit>()) {
    await getIt<ExchangeRateCubit>().close();
  }
  if (getIt.isRegistered<AppDatabase>()) {
    await getIt<AppDatabase>().close();
  }

  await getIt.reset();
  await setupServiceLocator();
}
