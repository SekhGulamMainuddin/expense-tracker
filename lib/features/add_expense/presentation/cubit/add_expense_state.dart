class AddExpenseState {
  final String amount;
  final String selectedCategory;
  final String selectedSubCategory;

  const AddExpenseState({
    required this.amount,
    required this.selectedCategory,
    required this.selectedSubCategory,
  });

  AddExpenseState copyWith({String? amount, String? category, String? sub}) {
    return AddExpenseState(
      amount: amount ?? this.amount,
      selectedCategory: category ?? selectedCategory,
      selectedSubCategory: sub ?? selectedSubCategory,
    );
  }
}
