import 'package:expense/shared/constants/app_border_radius.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputText extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final bool autofocus;
  final bool multiLine;
  final String? Function(String?)? validator;
  final void Function(String)? onFieldSubmitted;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final TextInputType? keyboardType;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;

  const InputText({
    super.key,
    required this.label,
    this.controller,
    this.autofocus = false,
    this.multiLine = false,
    this.validator,
    this.onFieldSubmitted,
    this.textInputAction,
    this.autofillHints,
    this.keyboardType,
    this.maxLength,
    this.inputFormatters,
  });

  Widget? _buildCounter(
    BuildContext context, {
    required currentLength,
    required isFocused,
    required maxLength,
  }) => null;

  @override
  Widget build(BuildContext context) => TextFormField(
    controller: controller,
    autofocus: autofocus,
    minLines: multiLine ? 1 : null,
    maxLines: multiLine ? 3 : 1,
    maxLength: maxLength,
    buildCounter: _buildCounter,
    validator: validator,
    onFieldSubmitted: onFieldSubmitted,
    textInputAction: textInputAction,
    autofillHints: autofillHints,
    keyboardType: keyboardType ?? (multiLine ? TextInputType.multiline : null),
    inputFormatters: inputFormatters,
    decoration: InputDecoration(
      border: OutlineInputBorder(borderRadius: appBorderRadius),
      label: Text(label),
    ),
  );
}
