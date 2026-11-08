import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isSecondary;
  final bool isDanger;
  final bool isExpanded;
  final double height;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isSecondary = false,
    this.isDanger = false,
    this.isExpanded = false,
    this.height = 42,
  });

  const AppButton.primary({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isExpanded = false,
    this.height = 42,
  })  : isSecondary = false,
        isDanger = false;

  const AppButton.secondary({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isExpanded = false,
    this.height = 42,
  })  : isSecondary = true,
        isDanger = false;

  const AppButton.danger({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isExpanded = false,
    this.height = 42,
  })  : isSecondary = false,
        isDanger = true;

  @override
  Widget build(BuildContext context) {
    final bool enabled = onPressed != null;

    Color bgColor;
    Color fgColor;
    BorderSide borderSide;

    if (!enabled) {
      bgColor = const Color(0xFFF1F5F9);
      fgColor = const Color(0xFF94A3B8);
      borderSide = const BorderSide(color: Color(0xFFE2E8F0));
    } else if (isDanger) {
      bgColor = AppColors.dangerBg;
      fgColor = AppColors.danger;
      borderSide = const BorderSide(color: AppColors.statusRedBorder);
    } else if (isSecondary) {
      bgColor = AppColors.surface;
      fgColor = AppColors.textPrimary;
      borderSide = const BorderSide(color: AppColors.border);
    } else {
      bgColor = AppColors.primary;
      fgColor = Colors.white;
      borderSide = BorderSide.none;
    }

    Widget content = Row(
      mainAxisSize: isExpanded ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 18, color: fgColor),
          const SizedBox(width: 6),
        ],
        Flexible(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: fgColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );

    final button = Material(
      color: bgColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: borderSide,
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: height,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          alignment: Alignment.center,
          child: content,
        ),
      ),
    );

    if (isExpanded) {
      return SizedBox(width: double.infinity, child: button);
    }

    return button;
  }
}
