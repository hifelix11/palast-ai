/// The Library: the AI-managed folder tree.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:palast/core/analytics/analytics_provider.dart';
import 'package:palast/core/theme/design_tokens.dart';
import 'package:palast/features/library/presentation/providers/library_provider.dart';
import 'package:palast/features/library/presentation/widgets/folder_card.dart';
import 'package:palast/shared/widgets/loading_indicator.dart';

class LibraryPage extends ConsumerWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final folders = ref.watch(rootFoldersProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Library'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: folders.when(
        loading: () => const LoadingIndicator(),
        error: (e, _) => Center(child: Text('$e')),
        data: (list) {
          if (list.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text(
                  'Your library will grow here as you capture.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          return GridView.builder(
            padding: const EdgeInsets.all(PalastSpacing.md),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: PalastSpacing.md,
              crossAxisSpacing: PalastSpacing.md,
              childAspectRatio: 1.4,
            ),
            itemCount: list.length,
            itemBuilder: (_, i) {
              final folder = list[i];
              return FolderCard(
                folder: folder,
                onTap: () {
                  ref.read(analyticsProvider).folderOpened(
                        folderId: folder.id,
                        folderName: folder.name,
                      );
                },
              );
            },
          );
        },
      ),
    );
  }
}
