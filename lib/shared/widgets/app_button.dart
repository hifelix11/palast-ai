/// A pair of opinionated buttons (filled + outlined) used across Palast.
library;

import 'package:flutter/material.dart';

enum AppButtonVariant { filled, outlined, text }

class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.filled,
    this.icon,
    this.loading = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final IconData? icon;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final child = loading
        ? const SizedBox(
            height: 16,
            width: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18),
                const SizedBox(width: 8),
              ],
              Text(label),
            ],
          );

    final action = loading ? null : onPressed;

    return switch (variant) {
      AppButtonVariant.filled => FilledButton(onPressed: action, child: child),
      AppButtonVariant.outlined =>
        OutlinedButton(onPressed: action, child: child),
      AppButtonVariant.text => TextButton(onPressed: action, child: child),
    };
  }
}
