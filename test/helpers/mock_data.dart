import 'package:expense/features/category/domain/models/category.dart';
import 'package:expense/features/profile/domain/models/profile.dart';
import 'package:expense/features/transaction/domain/models/transaction.dart';
import 'package:expense/features/wallet/domain/models/wallet.dart';
import 'package:expense/shared/enums/expense_kind.dart';
import 'package:expense/shared/models/balance.dart';

const mockProfile = Profile(
  id: 1,
  name: 'Test Profile',
  note: null,
  currency: 'USD',
  balance: Balance(income: 1000, expense: 500, total: 500),
  karma: 100,
  level: 2,
  nextLevelKarma: 200,
);

const mockProfile2 = Profile(
  id: 2,
  name: 'Work Profile',
  note: 'For business expenses',
  currency: 'EUR',
  balance: Balance(income: 5000, expense: 2000, total: 3000),
  karma: 250,
  level: 3,
  nextLevelKarma: 400,
);

const mockProfileEmpty = Profile(
  id: 3,
  name: 'Empty Profile',
  note: null,
  currency: 'GBP',
  balance: Balance(income: 0, expense: 0, total: 0),
  karma: 0,
  level: 1,
  nextLevelKarma: 100,
);

const mockWallet = Wallet(
  id: 1,
  profile: 1,
  name: 'Cash Wallet',
  color: '#4caf50',
  icon: 'wallet',
  archive: false,
  used: 10,
  balance: Balance(income: 500, expense: 200, total: 300),
);

const mockWallet2 = Wallet(
  id: 2,
  profile: 1,
  name: 'Bank Account',
  color: '#2196f3',
  icon: 'bank',
  archive: false,
  used: 25,
  balance: Balance(income: 2000, expense: 500, total: 1500),
);

const mockCategoryExpense = Category(
  id: 1,
  profile: 1,
  name: 'Food',
  color: '#f44336',
  icon: 'fastfood',
  archive: false,
  protect: false,
  kind: ExpenseKind.expense,
  transactionsCount: 15,
  transactionsTotal: 450.00,
);

const mockCategoryIncome = Category(
  id: 2,
  profile: 1,
  name: 'Salary',
  color: '#4caf50',
  icon: 'money',
  archive: false,
  protect: false,
  kind: ExpenseKind.income,
  transactionsCount: 3,
  transactionsTotal: 5000.00,
);

const mockCategoryTransfer = Category(
  id: 3,
  profile: 1,
  name: 'Transfer',
  color: '#ff9800',
  icon: 'arrows',
  archive: false,
  protect: true,
  kind: ExpenseKind.transfer,
  transactionsCount: 8,
  transactionsTotal: 1200.00,
);

final mockTransaction = Transaction(
  id: 1,
  wallet: 1,
  into: null,
  category: 1,
  event: null,
  tags: const [],
  kind: ExpenseKind.expense,
  amount: 25.50,
  note: 'Lunch',
  time: DateTime(2024, 1, 15, 12, 30),
  archive: false,
  exclude: false,
  created: DateTime(2024, 1, 15, 12, 30),
  updated: DateTime(2024, 1, 15, 12, 30),
);

final mockTransactionIncome = Transaction(
  id: 2,
  wallet: 2,
  into: null,
  category: 2,
  event: null,
  tags: const [],
  kind: ExpenseKind.income,
  amount: 2500.00,
  note: 'January salary',
  time: DateTime(2024, 1, 31, 9, 0),
  archive: false,
  exclude: false,
  created: DateTime(2024, 1, 31, 9, 0),
  updated: DateTime(2024, 1, 31, 9, 0),
);

final mockTransactionTransfer = Transaction(
  id: 3,
  wallet: 1,
  into: 2,
  category: 3,
  event: null,
  tags: const [],
  kind: ExpenseKind.transfer,
  amount: 500.00,
  note: 'Transfer to savings',
  time: DateTime(2024, 1, 20, 14, 0),
  archive: false,
  exclude: false,
  created: DateTime(2024, 1, 20, 14, 0),
  updated: DateTime(2024, 1, 20, 14, 0),
);

/// Creates a list of mock wallets with sequential IDs
List<Wallet> mockWalletsList({int count = 5}) {
  return List.generate(count, (index) {
    return Wallet(
      id: index + 1,
      profile: 1,
      name: 'Wallet ${index + 1}',
      color: '#4caf50',
      icon: 'wallet',
      archive: false,
      used: index * 5,
      balance: const Balance(income: 100, expense: 50, total: 50),
    );
  });
}

/// Creates a list of mock categories with sequential IDs
List<Category> mockCategoriesList({int count = 5}) {
  return List.generate(count, (index) {
    return Category(
      id: index + 1,
      profile: 1,
      name: 'Category ${index + 1}',
      color: '#f44336',
      icon: 'trophy',
      archive: false,
      protect: false,
      kind: ExpenseKind.expense,
      transactionsCount: index * 3,
      transactionsTotal: (index + 1) * 100.0,
    );
  });
}
