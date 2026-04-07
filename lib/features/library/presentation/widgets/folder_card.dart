/// A card representing a folder in the Library grid.
library;

import 'package:flutter/material.dart';

import 'package:palast/core/theme/design_tokens.dart';
import 'package:palast/features/library/domain/models/folder.dart';

class FolderCard extends StatelessWidget {
  const FolderCard({required this.folder, this.onTap, super.key});

  final Folder folder;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(PalastRadii.md),
        child: Padding(
          padding: const EdgeInsets.all(PalastSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.folder_outlined,
                color: Theme.of(context).colorScheme.tertiary,
              ),
              const SizedBox(height: PalastSpacing.sm),
              Text(
                folder.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              if (folder.description != null) ...[
                const SizedBox(height: 2),
                Text(
                  folder.description!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color:
                            Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
