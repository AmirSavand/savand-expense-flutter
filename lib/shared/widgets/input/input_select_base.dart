import 'package:expense/shared/constants/app_border_radius.dart';
import 'package:flutter/material.dart';

class InputSelectBaseWidget<T> extends StatefulWidget {
  final int? selected;
  final void Function(int) onSelect;
  final List<T> items;
  final int Function(T) getId;
  final String Function(T) getName;
  final IconData Function(T) getIcon;
  final Color Function(T) getColor;
  final int Function(T) getUsageCount;

  const InputSelectBaseWidget({
    super.key,
    required this.selected,
    required this.onSelect,
    required this.items,
    required this.getId,
    required this.getName,
    required this.getIcon,
    required this.getColor,
    required this.getUsageCount,
  });

  @override
  State<InputSelectBaseWidget<T>> createState() => _InputSelectBaseState<T>();
}

class _InputSelectBaseState<T> extends State<InputSelectBaseWidget<T>> {
  late int? _selectedId;
  late int? _initialSelected;

  @override
  void initState() {
    super.initState();
    _selectedId = widget.selected;
    _initialSelected = widget.selected;
  }

  @override
  void didUpdateWidget(InputSelectBaseWidget<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Check if items list changed (e.g., due to kind filter)
    if (oldWidget.items != widget.items) {
      // If selected doesn't exist in new list, reset
      if (_selectedId != null &&
          !widget.items.any((item) => widget.getId(item) == _selectedId)) {
        _selectedId = null;
        _initialSelected = null;
      }
    }
  }

  void select(int id) {
    setState(() => _selectedId = id);
    widget.onSelect(id);
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.items;
    if (items.isEmpty) return const SizedBox.shrink();

    // Sort by usage (descending)
    final sorted = [...items]
      ..sort(
        (a, b) => widget.getUsageCount(b).compareTo(widget.getUsageCount(a)),
      );

    // Move initial selected to front only once
    List<T> sortedItems = [...sorted];
    if (_initialSelected != null) {
      final selectedItem = sortedItems.firstWhere(
        (item) => widget.getId(item) == _initialSelected,
        orElse: () => null as T,
      );
      if (selectedItem != null) {
        sortedItems.remove(selectedItem);
        sortedItems.insert(0, selectedItem);
      }
    }

    // Auto-select most used if none selected
    if (_selectedId == null && sortedItems.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        select(widget.getId(sortedItems.first));
      });
    }

    // Reset if selected doesn't exist
    if (_selectedId != null &&
        !sortedItems.any((item) => widget.getId(item) == _selectedId)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (sortedItems.isNotEmpty) {
          select(widget.getId(sortedItems.first));
        }
      });
    }

    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: sortedItems.length,
        itemBuilder: (context, index) {
          final item = sortedItems[index];
          final double paddingLeft = index == 0 ? 32 : 8;
          final double paddingRight = index == sortedItems.length - 1 ? 32 : 0;
          final isSelected = _selectedId == widget.getId(item);
          return Padding(
            padding: EdgeInsets.only(left: paddingLeft, right: paddingRight),
            child: IconButton.filledTonal(
              padding: EdgeInsets.symmetric(horizontal: 12),
              onPressed: () => select(widget.getId(item)),
              isSelected: isSelected,
              icon: Row(
                spacing: 8,
                children: [
                  Icon(widget.getIcon(item), color: widget.getColor(item)),
                  Text(widget.getName(item)),
                ],
              ),
              style: IconButton.styleFrom(
                backgroundColor: widget.getColor(item).withAlpha(35),
                shape: RoundedRectangleBorder(
                  borderRadius: appBorderRadius,
                  side: isSelected
                      ? BorderSide(color: widget.getColor(item))
                      : BorderSide.none,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
