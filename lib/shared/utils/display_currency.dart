import 'package:expense/shared/enums/expense_kind.dart';
import 'package:intl/intl.dart';

String displayCurrency(double amount, String currency, {ExpenseKind? kind}) {
  if (kind == ExpenseKind.expense) {
    amount = amount * -1;
  }
  return NumberFormat.simpleCurrency(name: currency).format(amount);
}
