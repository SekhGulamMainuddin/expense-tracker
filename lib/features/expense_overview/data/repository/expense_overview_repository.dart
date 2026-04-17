import 'package:expense_tracker/features/expense_overview/data/models/expense_snapshot.dart';

abstract interface class ExpenseOverviewRepository {
  Future<ExpenseSnapshot> fetchOverview();
}
