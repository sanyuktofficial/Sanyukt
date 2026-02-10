import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

/// Dropdown with scrollable list, custom height and visible scrollbar.
class CustomDropdown extends StatelessWidget {
  const CustomDropdown({
    super.key,
    required this.label,
    required this.options,
    this.value,
    this.onChanged,
    this.validator,
    this.dropdownMaxHeight = 280,
    this.scrollbarAlwaysShow = true,
  });

  final String label;
  final List<String> options;
  final String? value;
  final ValueChanged<String?>? onChanged;
  final FormFieldValidator<String>? validator;
  final double dropdownMaxHeight;
  final bool scrollbarAlwaysShow;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveValue = value != null && value!.isNotEmpty && options.contains(value!)
        ? value!
        : null;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField2<String>(
        value: effectiveValue,
        isExpanded: true,
        decoration: InputDecoration(
          labelText: label,
          contentPadding: EdgeInsets.fromLTRB(12,6,12,6),
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
          filled: true,
          fillColor: isDark ? scheme.surfaceContainerHighest : Colors.grey.shade50,
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: dropdownMaxHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isDark ? scheme.surfaceContainerHighest : Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.3 : 0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          scrollbarTheme: ScrollbarThemeData(
            radius: const Radius.circular(8),
            thickness: MaterialStateProperty.all(6),
            thumbVisibility: MaterialStateProperty.all(scrollbarAlwaysShow),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        buttonStyleData: ButtonStyleData(
          height: 52,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isDark ? scheme.surfaceContainerHighest : Colors.grey.shade50,
          ),
        ),
        items: [
          DropdownMenuItem<String>(
            value: null,
            child: Text('Select', style: TextStyle(color: scheme.onSurfaceVariant)),
          ),
          ...options.map((o) => DropdownMenuItem<String>(
                value: o,
                child: Text(o),
              )),
        ],
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }
}
