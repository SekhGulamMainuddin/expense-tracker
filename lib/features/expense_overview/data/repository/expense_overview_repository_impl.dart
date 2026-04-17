import 'package:expense_tracker/features/expense_overview/data/datasources/expense_overview_remote_data_source.dart';
import 'package:expense_tracker/features/expense_overview/data/models/expense_snapshot.dart';
import 'package:expense_tracker/features/expense_overview/data/repository/expense_overview_repository.dart';

final class ExpenseOverviewRepositoryImpl implements ExpenseOverviewRepository {
  ExpenseOverviewRepositoryImpl(this._remoteDataSource);

  final ExpenseOverviewRemoteDataSource _remoteDataSource;

  @override
  Future<ExpenseSnapshot> fetchOverview() {
    return _remoteDataSource.fetchOverview();
  }
}
