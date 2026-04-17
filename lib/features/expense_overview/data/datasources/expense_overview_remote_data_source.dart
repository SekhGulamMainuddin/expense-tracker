import 'package:dio/dio.dart';
import 'package:expense_tracker/features/expense_overview/data/models/expense_snapshot.dart';

class ExpenseOverviewRemoteDataSource {
  ExpenseOverviewRemoteDataSource(this._dio);

  final Dio _dio;

  Future<ExpenseSnapshot> fetchOverview() async {
    _dio.options.connectTimeout = const Duration(seconds: 15);

    return const ExpenseSnapshot(
      titleKey: 'overview.title',
      descriptionKey: 'overview.body',
      spentLabel: 'INR 18,450',
      remainingLabel: 'INR 6,550 left',
    );
  }
}
