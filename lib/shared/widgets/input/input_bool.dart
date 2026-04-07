import 'package:flutter/material.dart';

class InputBool extends StatefulWidget {
  final String label;
  final bool selected;
  final void Function(bool) onSelect;
  final bool offset;

  const InputBool({
    super.key,
    required this.label,
    required this.selected,
    required this.onSelect,
    this.offset = true,
  });

  @override
  State<InputBool> createState() => _InputBoolState();
}

class _InputBoolState extends State<InputBool> {
  late bool _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.selected;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 8,
      children: [
        Transform.translate(
          offset: Offset(widget.offset ? -4 : 0, 0),
          child: Switch(
            value: _selected,
            onChanged: (v) {
              setState(() => _selected = v);
              widget.onSelect(_selected);
            },
          ),
        ),
        Text(widget.label),
      ],
    );
  }
}
