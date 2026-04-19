import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/features/settings/presentation/cubit/subcategory_state.dart';

class SubcategoryCubit extends Cubit<SubcategoryState> {
  SubcategoryCubit() : super(SubcategoryInitial());

  Future<void> addSubcategory({
    required String name,
    required String icon,
    required int colorValue,
  }) async {
    emit(SubcategoryLoading());

    // Simulate API or Database call
    await Future.delayed(const Duration(seconds: 1));

    emit(SubcategorySuccess());
  }
}
