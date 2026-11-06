import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AppSearchInput extends StatelessWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final double? width;

  const AppSearchInput({
    super.key,
    this.hintText = 'Buscar por nombre o código…',
    this.onChanged,
    this.controller,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final field = SizedBox(
      height: 42,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: const Icon(Icons.search, size: 20, color: AppColors.textSecondary),
          prefixIconConstraints: const BoxConstraints(minWidth: 38, minHeight: 38),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
          fillColor: AppColors.surface,
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
        ),
      ),
    );

    if (width != null) {
      return SizedBox(width: width, child: field);
    }
    return field;
  }
}

class AppDropdown<T> extends StatelessWidget {
  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final double? width;
  final IconData? prefixIcon;

  const AppDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.width,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final dropdown = Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (prefixIcon != null) ...[
            Icon(prefixIcon, size: 18, color: AppColors.textSecondary),
            const SizedBox(width: 8),
          ],
          DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              items: items,
              onChanged: onChanged,
              icon: const Icon(Icons.keyboard_arrow_down, size: 18, color: AppColors.textSecondary),
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );

    if (width != null) {
      return SizedBox(width: width, child: dropdown);
    }
    return dropdown;
  }
}

class AppTextInput extends StatelessWidget {
  final String label;
  final String? hintText;
  final TextEditingController? controller;
  final bool obscureText;
  final IconData? prefixIcon;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;

  const AppTextInput({
    super.key,
    required this.label,
    this.hintText,
    this.controller,
    this.obscureText = false,
    this.prefixIcon,
    this.keyboardType,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        SizedBox(
          height: 44,
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            onChanged: onChanged,
            style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: hintText,
              prefixIcon: prefixIcon != null ? Icon(prefixIcon, size: 20, color: AppColors.textSecondary) : null,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            ),
          ),
        ),
      ],
    );
  }
}
