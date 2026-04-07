import 'package:collection/collection.dart';
import 'package:expense/features/category/presentation/providers/category_provider.dart';
import 'package:expense/features/transaction/domain/models/transaction.dart';
import 'package:expense/features/transaction/domain/models/transaction_form.dart';
import 'package:expense/features/transaction/presentation/providers/transaction_create_provider.dart';
import 'package:expense/features/transaction/presentation/providers/transaction_update_provider.dart';
import 'package:expense/features/wallet/presentation/providers/wallet_provider.dart';
import 'package:expense/features/wallet/presentation/widgets/wallet_sheet.dart';
import 'package:expense/shared/enums/expense_kind.dart';
import 'package:expense/shared/utils/display_error.dart';
import 'package:expense/shared/widgets/app_sheet.dart';
import 'package:expense/shared/widgets/input/input_bool.dart';
import 'package:expense/shared/widgets/input/input_category.dart';
import 'package:expense/shared/widgets/input/input_date_time.dart';
import 'package:expense/shared/widgets/input/input_expense_kind.dart';
import 'package:expense/shared/widgets/input/input_number.dart';
import 'package:expense/shared/widgets/input/input_text.dart';
import 'package:expense/shared/widgets/input/input_wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionSheet extends ConsumerStatefulWidget {
  final Transaction? transaction;

  const TransactionSheet({super.key, this.transaction});

  @override
  ConsumerState<TransactionSheet> createState() => _TransactionSheetState();

  static Future<void> show(BuildContext context, {Transaction? transaction}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      useSafeArea: true,
      builder: (context) => TransactionSheet(transaction: transaction),
    );
  }
}

class _TransactionSheetState extends ConsumerState<TransactionSheet> {
  final amountController = TextEditingController();
  final noteController = TextEditingController();
  ExpenseKind kind = ExpenseKind.expense;
  int? wallet;
  int? into;
  int? category;
  DateTime time = DateTime.now();
  bool archive = false;
  bool exclude = false;

  bool get isEditing => widget.transaction != null;

  bool get isTransfer => kind == ExpenseKind.transfer;

  int? _getTransferCategoryId() {
    final categoryState = ref.read(categoryProvider);
    if (categoryState is! CategoryLoaded) {
      return null;
    }
    final transferCategory = categoryState.categories.firstWhereOrNull(
      (c) => c.kind == ExpenseKind.transfer,
    );
    return transferCategory?.id;
  }

  @override
  void initState() {
    super.initState();

    // Reset provider after the first frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isEditing) {
        ref.read(transactionUpdateProvider.notifier).reset();
      } else {
        ref.read(transactionCreateProvider.notifier).reset();
      }
    });

    // Handle navigation on success for create
    ref.listenManual(transactionCreateProvider, (_, next) {
      next.whenOrNull(
        data: (transaction) {
          if (transaction != null && mounted) {
            Navigator.of(context).pop();
          }
        },
      );
    });

    // Handle navigation on success for update
    if (isEditing) {
      ref.listenManual(transactionUpdateProvider, (_, next) {
        next.whenOrNull(
          data: (transaction) {
            if (transaction != null && mounted) {
              Navigator.of(context).pop();
            }
          },
        );
      });
    }

    // On edit mode, update default values to the given instance data.
    if (isEditing) {
      final transaction = widget.transaction!;
      amountController.text = transaction.amount.toString();
      noteController.text = transaction.note ?? '';
      kind = transaction.kind;
      wallet = transaction.wallet;
      into = transaction.into;
      category = isTransfer ? _getTransferCategoryId() : transaction.category;
      time = transaction.time;
      archive = transaction.archive;
      exclude = transaction.exclude;
    }
  }

  @override
  void dispose() {
    amountController.dispose();
    noteController.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    final amount = double.tryParse(amountController.text);
    if (amount == null || amount <= 0) {
      _setError('Amount must be greater than 0');
      return;
    }

    if (isTransfer) {
      if (wallet == null || into == null) {
        _setError('Both wallets must be selected');
        return;
      }
      if (wallet == into) {
        _setError('Source and destination wallets cannot be the same');
        return;
      }
    } else {
      if (category == null || wallet == null) {
        _setError('Wallet and category must be selected');
        return;
      }
    }

    final form = TransactionForm(
      category: isTransfer ? _getTransferCategoryId() : category,
      wallet: wallet!,
      into: into,
      kind: kind,
      archive: archive,
      exclude: exclude,
      note: noteController.text.trim(),
      amount: amountController.text,
      time: time,
      tags: [],
    );

    if (isEditing) {
      await ref
          .read(transactionUpdateProvider.notifier)
          .updateTransaction(widget.transaction!.id, form);
    } else {
      await ref.read(transactionCreateProvider.notifier).create(form);
    }
  }

  void _setError(String message) {
    if (isEditing) {
      ref.read(transactionUpdateProvider.notifier).setError(message);
    } else {
      ref.read(transactionCreateProvider.notifier).setError(message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final walletState = ref.watch(walletProvider);
    final createState = ref.watch(transactionCreateProvider);
    final updateState = isEditing ? ref.watch(transactionUpdateProvider) : null;

    final theme = Theme.of(context);
    final title = isEditing ? 'Update Transaction' : 'Create Transaction';
    const padding = EdgeInsets.symmetric(horizontal: 32);

    // Make sure wallets are loaded
    if (walletState is! WalletLoaded) {
      return AppSheet(
        title: title,
        children: [Padding(padding: padding, child: LinearProgressIndicator())],
      );
    }

    // Make sure user has wallets
    if (walletState.wallets.isEmpty) {
      return AppSheet(
        title: title,
        children: [
          Padding(
            padding: padding,
            child: Text(
              'You need to have wallets before creating transactions.',
              style: TextStyle(color: theme.colorScheme.error),
            ),
          ),
          Padding(
            padding: padding,
            child: FilledButton.tonal(
              onPressed: () => WalletSheet.show(context),
              child: Text('Create Wallet'),
            ),
          ),
        ],
      );
    }

    // Show the form
    return AppSheet(
      title: title,
      children: [
        // Kind
        Padding(
          padding: padding,
          child: InputKind(
            selected: kind,
            onSelect: (value) {
              setState(() {
                kind = value;
                if (isTransfer) {
                  category = null;
                } else {
                  into = null;
                }
              });
            },
          ),
        ),
        // Wallet
        InputWallet(selected: wallet, onSelect: (id) => wallet = id),
        // Wallet (into)
        if (isTransfer)
          Padding(
            padding: padding,
            child: Text(
              'Transfer into wallet',
              style: TextStyle(color: theme.colorScheme.secondary),
            ),
          ),
        if (isTransfer)
          InputWallet(selected: into, onSelect: (id) => into = id),
        // Category (shown when not transfer kind)
        if (!isTransfer)
          InputCategory(
            selected: category,
            onSelect: (id) => category = id,
            kind: kind,
          ),
        // Amount
        Padding(
          padding: padding,
          child: InputNumber(label: 'Amount', controller: amountController),
        ),
        // Time
        Padding(
          padding: padding,
          child: InputDateTime(value: time, onSelect: (value) => time = value),
        ),
        // Note
        Padding(
          padding: padding,
          child: InputText(
            label: 'Note',
            controller: noteController,
            multiLine: true,
          ),
        ),
        // Archive
        Padding(
          padding: padding,
          child: InputBool(
            selected: archive,
            onSelect: (value) => archive = value,
            label: 'Archive and hide',
          ),
        ),
        // Exclude
        Padding(
          padding: padding,
          child: InputBool(
            selected: exclude,
            onSelect: (value) => exclude = value,
            label: 'Exclude from reports',
          ),
        ),
        // Handle loading/error/initial states
        if (isEditing)
          updateState!.when(
            loading: () => const SizedBox.shrink(),
            data: (transaction) => const SizedBox.shrink(),
            error: (error, _) => Padding(
              padding: padding,
              child: Text(
                displayError(error),
                style: TextStyle(color: theme.colorScheme.error),
              ),
            ),
          )
        else
          createState.when(
            loading: () => const SizedBox.shrink(),
            data: (transaction) => const SizedBox.shrink(),
            error: (error, _) => Padding(
              padding: padding,
              child: Text(
                displayError(error),
                style: TextStyle(color: theme.colorScheme.error),
              ),
            ),
          ),
        // Space
        const SizedBox(),
        // Submit button
        Padding(
          padding: padding,
          child: FilledButton(
            onPressed: () => submit(),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(isEditing ? 'Update' : 'Create'),
            ),
          ),
        ),
      ],
    );
  }
}
