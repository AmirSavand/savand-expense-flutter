import 'package:expense/shared/constants/app_border_radius.dart';
import 'package:expense/shared/utils/display_color.dart';
import 'package:flutter/material.dart';

class InputColor extends StatefulWidget {
  final String? selected;
  final void Function(String) onSelect;

  const InputColor({super.key, required this.onSelect, this.selected});

  @override
  State<InputColor> createState() => _InputColorState();
}

class _InputColorState extends State<InputColor> {
  late String? _selectedColor;

  final List<String> _colors = [
    '#f44336',
    '#e91e63',
    '#9c27b0',
    '#673ab7',
    '#3f51b5',
    '#2196f3',
    '#03a9f4',
    '#00bcd4',
    '#009688',
    '#4caf50',
    '#8bc34a',
    '#ffeb3b',
    '#ffc107',
    '#ff9800',
    '#ff5722',
    '#607d8b',
    '#9e9e9e',
  ];

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.selected;
    if (widget.selected != null) {
      if (_colors.remove(widget.selected)) {
        _colors.insert(0, widget.selected!);
      }
      if (!_colors.contains(widget.selected)) {
        _colors.insert(0, widget.selected!);
      }
    }
  }

  void select(String color) {
    setState(() {
      _selectedColor = color;
    });
    widget.onSelect(color);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _colors.length,
        itemBuilder: (context, index) {
          final double paddingLeft = index == 0 ? 32 : 8;
          final double paddingRight = index == _colors.length - 1 ? 32 : 0;
          final item = _colors[index];
          final Color colorParsed = displayColor(item);
          return Padding(
            padding: EdgeInsets.only(left: paddingLeft, right: paddingRight),
            child: IconButton.filled(
              key: ValueKey(item),
              padding: EdgeInsets.symmetric(horizontal: 12),
              onPressed: () => select(item),
              isSelected: _selectedColor == item,
              icon: Icon(Icons.circle, color: colorParsed),
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
