import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;

  const CustomDialog({
    super.key,
    required this.title,
    required this.message,
    required this.confirmText,
    this.cancelText = "Cancel",
    required this.onConfirm,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      backgroundColor: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Text(title, style: theme.textTheme.titleLarge),
      content: Text(message, style: theme.textTheme.bodyMedium),
      actions: [
        TextButton(
          onPressed: onCancel ?? () => Get.back(),
          child: Text(cancelText, style: TextStyle(color: theme.colorScheme.primary)),
        ),
        FilledButton(
          onPressed: () {
            Get.back(); // Close the dialog first
            onConfirm();
          },
          child: Text(confirmText),
        ),
      ],
    );
  }
}
