import 'package:expense/shared/constants/app_shape.dart';
import 'package:expense/shared/enums/expense_kind.dart';
import 'package:flutter/material.dart';

class InputKind extends StatefulWidget {
  final ExpenseKind selected;
  final void Function(ExpenseKind) onSelect;
  final bool excludeTransfer;

  const InputKind({
    super.key,
    required this.selected,
    required this.onSelect,
    this.excludeTransfer = false,
  });

  @override
  State<InputKind> createState() => _InputKindState();
}

class _InputKindState extends State<InputKind> {
  late ExpenseKind _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.selected;
  }

  void select(ExpenseKind kind) {
    setState(() => _selected = kind);
    widget.onSelect(kind);
  }

  List<ExpenseKind> get _kinds {
    final kinds = [ExpenseKind.income, ExpenseKind.expense];
    if (!widget.excludeTransfer) kinds.add(ExpenseKind.transfer);
    return kinds;
  }

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<ExpenseKind>(
      showSelectedIcon: false,
      segments: _kinds
          .map((kind) => ButtonSegment(value: kind, label: Text(kind.label)))
          .toList(),
      selected: {_selected},
      onSelectionChanged: (value) => select(value.first),
      style: SegmentedButton.styleFrom(
        shape: appShape,
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
        padding: const EdgeInsets.symmetric(vertical: 20),
      ),
    );
  }
}
