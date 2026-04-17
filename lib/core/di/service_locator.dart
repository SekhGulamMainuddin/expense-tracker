import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:expense_tracker/features/expense_overview/data/datasources/expense_overview_remote_data_source.dart';
import 'package:expense_tracker/features/expense_overview/data/repository/expense_overview_repository.dart';
import 'package:expense_tracker/features/expense_overview/data/repository/expense_overview_repository_impl.dart';
import 'package:expense_tracker/features/expense_overview/presentation/cubit/expense_overview_cubit.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  getIt
    ..registerLazySingleton<Dio>(() => Dio())
    ..registerLazySingleton<ExpenseOverviewRemoteDataSource>(
      () => ExpenseOverviewRemoteDataSource(getIt()),
    )
    ..registerLazySingleton<ExpenseOverviewRepository>(
      () => ExpenseOverviewRepositoryImpl(getIt()),
    )
    ..registerFactory(() => ExpenseOverviewCubit(getIt()));
}
