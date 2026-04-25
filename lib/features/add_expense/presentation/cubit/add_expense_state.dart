import 'package:expense_tracker/features/settings/domain/entities/settings_category.dart';
import 'package:expense_tracker/features/settings/domain/entities/settings_snapshot.dart';

sealed class AddExpenseState {}

final class AddExpenseLoading extends AddExpenseState {}

enum AddExpenseMode { create, view, edit }

final class AddExpenseLoaded extends AddExpenseState {
  AddExpenseLoaded({
    required this.settings,
    required this.amount,
    this.title,
    required this.date,
    required this.selectedCategoryId,
    required this.selectedSubcategoryId,
    this.mode = AddExpenseMode.create,
    this.transactionId,
    this.generatedTitle,
    this.isSubmitting = false,
    this.errorMessage,
  });

  final SettingsSnapshot settings;
  final String amount;
  final String? title;
  final DateTime date;
  final int selectedCategoryId;
  final int? selectedSubcategoryId;
  final AddExpenseMode mode;
  final int? transactionId;
  final String? generatedTitle;
  final bool isSubmitting;
  final String? errorMessage;

  List<SettingsCategory> get rootCategories => settings.categories;

  SettingsCategory? get selectedCategory => _findCategoryById(
    settings.categories,
    selectedCategoryId,
  );

  SettingsCategory? get selectedSubcategory => selectedSubcategoryId == null
      ? null
      : _findCategoryById(settings.categories, selectedSubcategoryId!);

  List<SettingsCategory> get subcategories => selectedCategory?.children ?? const [];

  AddExpenseLoaded copyWith({
    SettingsSnapshot? settings,
    String? amount,
    String? title,
    DateTime? date,
    int? selectedCategoryId,
    int? selectedSubcategoryId,
    AddExpenseMode? mode,
    int? transactionId,
    String? generatedTitle,
    bool clearSelectedSubcategoryId = false,
    bool? isSubmitting,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return AddExpenseLoaded(
      settings: settings ?? this.settings,
      amount: amount ?? this.amount,
      title: title ?? this.title,
      date: date ?? this.date,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      selectedSubcategoryId: clearSelectedSubcategoryId
          ? null
          : (selectedSubcategoryId ?? this.selectedSubcategoryId),
      mode: mode ?? this.mode,
      transactionId: transactionId ?? this.transactionId,
      generatedTitle: generatedTitle ?? this.generatedTitle,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

final class AddExpenseSuccess extends AddExpenseState {}

final class AddExpenseFailure extends AddExpenseState {
  AddExpenseFailure(this.message);

  final String message;
}

SettingsCategory? _findCategoryById(
  List<SettingsCategory> categories,
  int id,
) {
  for (final category in categories) {
    if (category.id == id) {
      return category;
    }
    final child = _findCategoryById(category.children, id);
    if (child != null) {
      return child;
    }
  }
  return null;
}
