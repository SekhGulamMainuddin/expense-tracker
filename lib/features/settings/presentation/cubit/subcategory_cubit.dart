import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/features/settings/presentation/cubit/subcategory_state.dart';

class SubcategoryCubit extends Cubit<SubcategoryState> {
  SubcategoryCubit() : super(const SubcategoryState());

  Future<void> addSubcategory({
    required String name,
    required String icon,
    required int colorValue,
  }) async {
    emit(const SubcategoryState(isSubmitting: true));

    // Simulate API or Database call
    await Future.delayed(const Duration(seconds: 1));

    emit(const SubcategoryState(isSubmitting: false, success: true));
  }
}
