import 'package:flutter/material.dart';

import 'input_text.dart';

class InputEmail extends StatelessWidget {
  final TextEditingController? controller;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;

  const InputEmail({
    super.key,
    this.controller,
    this.textInputAction,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return InputText(
      label: 'Email',
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      autofillHints: const [AutofillHints.email],
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      validator: _validator,
    );
  }

  String? _validator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email.';
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value.trim())) {
      return 'Please enter a valid email.';
    }
    return null;
  }
}
