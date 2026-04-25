import 'dart:async';
import 'package:expense_tracker/features/home/domain/entities/time_range.dart';
import 'package:expense_tracker/features/home/domain/repositories/finance_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'category_chart_state.dart';

class CategoryChartCubit extends Cubit<CategoryChartState> {
  CategoryChartCubit(this._repository) : super(CategoryChartInitial()) {
    _startWatching();
  }

  final FinanceRepository _repository;
  StreamSubscription<void>? _subscription;
  TimeRange _currentRange = TimeRange.monthly;

  void _startWatching({bool isRefreshing = false}) {
    _subscription?.cancel();
    if (!isRefreshing) {
      emit(CategoryChartLoading());
    } else if (state is CategoryChartLoaded) {
      emit((state as CategoryChartLoaded).copyWith(isRefreshing: true));
    }
    
    _subscription = _repository.watchDashboard(range: _currentRange).listen(
      (snapshot) {
        emit(CategoryChartLoaded(
          breakdown: snapshot.categoryBreakdown,
          range: _currentRange,
          isRefreshing: false,
        ));
      },
      onError: (Object error) {
        emit(CategoryChartFailure(error.toString()));
      },
    );
  }

  Future<void> changeTimeRange(TimeRange range) async {
    if (_currentRange == range) return;
    _currentRange = range;
    _startWatching(isRefreshing: true);
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
