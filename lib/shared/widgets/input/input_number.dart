import 'package:expense/shared/formatters/number_text_input_formatter.dart';
import 'package:expense/shared/widgets/input/input_text.dart';
import 'package:flutter/material.dart';

class InputNumber extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool autofocus;
  final int? maxLength;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;
  final String? Function(String?)? validator;

  const InputNumber({
    super.key,
    required this.label,
    required this.controller,
    this.maxLength,
    this.textInputAction,
    this.onFieldSubmitted,
    this.validator,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return InputText(
      label: label,
      controller: controller,
      autofocus: autofocus,
      keyboardType: TextInputType.number,
      inputFormatters: [NumberTextInputFormatter()],
      maxLength: maxLength,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      validator: validator,
    );
  }
}
