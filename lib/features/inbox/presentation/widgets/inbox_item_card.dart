/// One row in the inbox: title, source, status pill.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:palast/core/theme/design_tokens.dart';
import 'package:palast/shared/models/item.dart';
import 'package:palast/shared/widgets/status_badge.dart';

class InboxItemCard extends StatelessWidget {
  const InboxItemCard({required this.item, super.key});

  final Item item;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.go('/item/${item.id}'),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: PalastSpacing.lg,
          vertical: PalastSpacing.md,
        ),
        child: Row(
          children: [
            Icon(_iconFor(item.sourceType), size: 20),
            const SizedBox(width: PalastSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title ?? _fallbackTitle(item),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.sourceType.name,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
            StatusBadge(status: item.status),
          ],
        ),
      ),
    );
  }

  String _fallbackTitle(Item i) =>
      i.originalUrl ?? 'Untitled';

  IconData _iconFor(ItemSourceType t) => switch (t) {
        ItemSourceType.url || ItemSourceType.article => Icons.link,
        ItemSourceType.youtube => Icons.smart_display_outlined,
        ItemSourceType.tiktok => Icons.music_note_outlined,
        ItemSourceType.instagram => Icons.photo_camera_outlined,
        ItemSourceType.tweet => Icons.alternate_email,
        ItemSourceType.image => Icons.image_outlined,
        ItemSourceType.pdf => Icons.picture_as_pdf_outlined,
        ItemSourceType.text => Icons.notes_outlined,
        ItemSourceType.voiceMemo => Icons.mic_none_outlined,
      };
}
