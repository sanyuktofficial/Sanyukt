import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    this.inputFormatters,
    this.maxLength,
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
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(
          labelText: label,
          helperText: helperText,
          suffixIcon: suffixIcon,
          counterText: maxLength != null ? '' : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: scheme.outline),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: scheme.primary, width: 1.5),
          ),
          fillColor: readOnly ? (isDark ? scheme.surfaceContainerHighest : Colors.grey.shade100) : null,
        ),
        maxLines: maxLines,
        maxLength: maxLength,
        keyboardType: keyboardType,
        readOnly: readOnly,
        inputFormatters: inputFormatters,
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }
}
