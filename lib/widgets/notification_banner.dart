import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';

class NotificationBanner extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback onDismiss;

  const NotificationBanner({
    super.key,
    required this.notification,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.toastBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.toastBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                notification.title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.toastText,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                notification.message,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.toastText.withValues(alpha: 0.85),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          InkWell(
            onTap: onDismiss,
            borderRadius: BorderRadius.circular(4),
            child: const Padding(
              padding: EdgeInsets.all(4.0),
              child: Icon(Icons.close, size: 16, color: AppColors.toastText),
            ),
          ),
        ],
      ),
    );
  }
}
