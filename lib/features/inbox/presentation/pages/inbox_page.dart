/// The Inbox: a quiet, reverse-chronological list of everything the
/// user has captured. Live updates via Supabase Realtime.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:palast/features/inbox/presentation/providers/inbox_provider.dart';
import 'package:palast/features/inbox/presentation/widgets/inbox_item_card.dart';
import 'package:palast/shared/widgets/loading_indicator.dart';

class InboxPage extends ConsumerWidget {
  const InboxPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stream = ref.watch(inboxStreamProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inbox'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.go('/search'),
          ),
          IconButton(
            icon: const Icon(Icons.folder_outlined),
            onPressed: () => context.go('/library'),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.go('/settings'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/capture'),
        icon: const Icon(Icons.add),
        label: const Text('Capture'),
      ),
      body: stream.when(
        loading: () => const LoadingIndicator(),
        error: (e, _) => Center(child: Text('$e')),
        data: (items) {
          if (items.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text(
                  'Nothing waiting. Share something to Palast and the Librarian will file it.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          return ListView.separated(
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (_, i) => InboxItemCard(item: items[i]),
          );
        },
      ),
    );
  }
}
