import 'package:flutter/material.dart';

import '../../core/app_theme.dart';

/// Reusable text field with consistent styling across the app.
class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.label,
    this.initialValue,
    this.onChanged,
    this.validator,
    this.maxLines = 1,
    this.keyboardType,
    this.readOnly = false,
    this.helperText,
    this.suffixIcon,
  });

  final String label;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final int maxLines;
  final TextInputType? keyboardType;
  final bool readOnly;
  final String? helperText;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(
          labelText: label,
          helperText: helperText,
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: appPrimary, width: 1.5),
          ),
          // filled: true,
          fillColor: readOnly ? Colors.grey.shade100 : null,
        ),
        maxLines: maxLines,
        keyboardType: keyboardType,
        readOnly: readOnly,
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }
}
