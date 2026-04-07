/// Represents the kind of a financial transaction.
enum ExpenseKind {
  income(0, 'Income'),
  expense(1, 'Expense'),
  transfer(2, 'Transfer');

  final int value;
  final String label;

  const ExpenseKind(this.value, this.label);

  static ExpenseKind fromValue(int value) {
    return ExpenseKind.values.firstWhere((e) => e.value == value);
  }
}
