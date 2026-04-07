/// Item detail: title, source, the Librarian's summary, key points,
/// folder path and tags.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:palast/core/theme/design_tokens.dart';
import 'package:palast/features/item_detail/presentation/providers/item_detail_provider.dart';
import 'package:palast/shared/widgets/loading_indicator.dart';
import 'package:palast/shared/widgets/status_badge.dart';

class ItemDetailPage extends ConsumerWidget {
  const ItemDetailPage({required this.itemId, super.key});

  final String itemId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(itemDetailProvider(itemId));
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: detail.when(
        loading: () => const LoadingIndicator(),
        error: (e, _) => Center(child: Text('$e')),
        data: (k) {
          final item = k.item;
          return ListView(
            padding: const EdgeInsets.all(PalastSpacing.lg),
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      item.title ?? 'Untitled',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  ),
                  StatusBadge(status: item.status),
                ],
              ),
              const SizedBox(height: PalastSpacing.xs),
              if (item.originalUrl != null)
                InkWell(
                  onTap: () => launchUrl(Uri.parse(item.originalUrl!)),
                  child: Text(
                    item.originalUrl!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              const SizedBox(height: PalastSpacing.xl),
              if (k.summary != null) ...[
                Text('Summary',
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: PalastSpacing.xs),
                Text(k.summary!),
                const SizedBox(height: PalastSpacing.xl),
              ],
              if (k.keyPoints != null && k.keyPoints!.isNotEmpty) ...[
                Text('Key points',
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: PalastSpacing.xs),
                for (final p in k.keyPoints!)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text('-  $p'),
                  ),
                const SizedBox(height: PalastSpacing.xl),
              ],
              if (k.transcript != null) ...[
                Text('Transcript',
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: PalastSpacing.xs),
                Text(k.transcript!),
                const SizedBox(height: PalastSpacing.xl),
              ],
              if (k.folderPath != null && k.folderPath!.isNotEmpty)
                Wrap(
                  spacing: 8,
                  children: [
                    const Icon(Icons.folder_outlined, size: 16),
                    Text(k.folderPath!.join(' / ')),
                  ],
                ),
              const SizedBox(height: PalastSpacing.sm),
              if (k.tags != null && k.tags!.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final t in k.tags!)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color:
                                Theme.of(context).colorScheme.outlineVariant,
                          ),
                        ),
                        child: Text('#$t',
                            style:
                                Theme.of(context).textTheme.bodySmall),
                      ),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }
}
