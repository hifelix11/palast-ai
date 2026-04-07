/// A small pill that renders an [ItemStatus] with an appropriate
/// color and label.
library;

import 'package:flutter/material.dart';

import 'package:palast/shared/models/item.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({required this.status, super.key});

  final ItemStatus status;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (label, bg, fg) = switch (status) {
      ItemStatus.pending => ('Waiting', scheme.surfaceContainerHighest, scheme.onSurfaceVariant),
      ItemStatus.processing => ('Filing', scheme.tertiaryContainer, scheme.onTertiaryContainer),
      ItemStatus.ready => ('Filed', scheme.primaryContainer, scheme.onPrimaryContainer),
      ItemStatus.failed => ('Stuck', scheme.errorContainer, scheme.onErrorContainer),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: fg,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}
