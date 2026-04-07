import 'package:expense/shared/constants/app_border_radius.dart';
import 'package:expense/shared/constants/app_icons.dart';
import 'package:flutter/material.dart';

class InputIcon extends StatefulWidget {
  final String? selected;
  final void Function(String) onSelect;

  const InputIcon({super.key, required this.onSelect, this.selected});

  @override
  State<InputIcon> createState() => _InputIconState();
}

class _InputIconState extends State<InputIcon> {
  late String? _selectedIcon;
  late List<String> _iconKeys;

  @override
  void initState() {
    super.initState();
    _selectedIcon = widget.selected;
    // Deduplicate by IconData, keeping first occurrence of each
    final seen = <int>{};
    final deduped = appIcons.keys
        .where((key) => seen.add(appIcons[key]!.codePoint))
        .toList();
    // Ensure selected is first, even if it was filtered out
    if (widget.selected != null) {
      deduped.remove(widget.selected);
      deduped.insert(0, widget.selected!);
    }
    _iconKeys = deduped;
  }

  void select(String iconKey) {
    setState(() => _selectedIcon = iconKey);
    widget.onSelect(iconKey);
  }

  @override
  Widget build(BuildContext context) {
    final iconKeys = _iconKeys.toList();
    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: iconKeys.length,
        itemBuilder: (context, index) {
          final iconKey = iconKeys[index];
          final double paddingLeft = index == 0 ? 32 : 8;
          final double paddingRight = index == iconKeys.length - 1 ? 32 : 0;
          return Padding(
            key: ValueKey(iconKey),
            padding: EdgeInsets.only(left: paddingLeft, right: paddingRight),
            child: IconButton.filled(
              padding: EdgeInsets.symmetric(horizontal: 12),
              onPressed: () => select(iconKey),
              isSelected: _selectedIcon == iconKey,
              icon: Icon(appIcons[iconKey]!),
              style: IconButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: appBorderRadius),
              ),
            ),
          );
        },
      ),
    );
  }
}
