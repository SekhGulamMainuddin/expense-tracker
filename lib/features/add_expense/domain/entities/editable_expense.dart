/// An existing expense prepared for the edit form.
///
/// [amount] is already denominated in the user's current base currency: the
/// row stores an INR-normalized `baseAmount`, and converting it back is a
/// data-layer concern, so the form never touches exchange rates.
class EditableExpense {
  const EditableExpense({
    required this.id,
    required this.amount,
    required this.title,
    required this.categoryId,
    required this.date,
  });

  final int id;
  final double amount;
  final String? title;
  final int categoryId;
  final DateTime date;
}
