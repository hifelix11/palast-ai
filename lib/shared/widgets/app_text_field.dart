/// Outlined text field used by Palast forms.
library;

import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    required this.controller,
    this.label,
    this.hint,
    this.maxLines = 1,
    this.minLines,
    this.onChanged,
    this.autofocus = false,
    this.textInputAction,
    super.key,
  });

  final TextEditingController controller;
  final String? label;
  final String? hint;
  final int maxLines;
  final int? minLines;
  final ValueChanged<String>? onChanged;
  final bool autofocus;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      minLines: minLines,
      onChanged: onChanged,
      autofocus: autofocus,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
      ),
    );
  }
}
