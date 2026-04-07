/// Lists child folders and items inside a single folder.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:palast/core/theme/design_tokens.dart';
import 'package:palast/features/inbox/presentation/widgets/inbox_item_card.dart';
import 'package:palast/features/library/presentation/providers/library_provider.dart';
import 'package:palast/features/library/presentation/widgets/folder_card.dart';
import 'package:palast/shared/widgets/loading_indicator.dart';

class FolderDetailPage extends ConsumerWidget {
  const FolderDetailPage({
    required this.folderId,
    required this.folderName,
    super.key,
  });

  final String folderId;
  final String folderName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final children = ref.watch(childFoldersProvider(folderId));
    final items = ref.watch(itemsInFolderProvider(folderId));

    return Scaffold(
      appBar: AppBar(
        title: Text(folderName),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () =>
              context.canPop() ? context.pop() : context.go('/'),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(PalastSpacing.md),
        children: [
          children.when(
            loading: () => const LoadingIndicator(),
            error: (e, _) => Text('$e'),
            data: (folders) {
              if (folders.isEmpty) return const SizedBox.shrink();
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: PalastSpacing.md,
                  crossAxisSpacing: PalastSpacing.md,
                  childAspectRatio: 1.4,
                ),
                itemCount: folders.length,
                itemBuilder: (_, i) {
                  final f = folders[i];
                  return FolderCard(
                    folder: f,
                    onTap: () => context.push(
                      '/folder/${f.id}?name=${Uri.encodeComponent(f.name)}',
                    ),
                  );
                },
              );
            },
          ),
          const SizedBox(height: PalastSpacing.md),
          items.when(
            loading: () => const LoadingIndicator(),
            error: (e, _) => Text('$e'),
            data: (list) {
              if (list.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(child: Text('No items in this folder yet.')),
                );
              }
              return Column(
                children: [
                  for (final item in list) InboxItemCard(item: item),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
