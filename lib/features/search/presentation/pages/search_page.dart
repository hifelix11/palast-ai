/// The Search page.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:palast/core/theme/design_tokens.dart';
import 'package:palast/features/inbox/presentation/widgets/inbox_item_card.dart';
import 'package:palast/features/search/presentation/providers/search_provider.dart';
import 'package:palast/shared/widgets/app_text_field.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final results = ref.watch(searchControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(PalastSpacing.md),
            child: AppTextField(
              controller: _controller,
              hint: 'Search your palace',
              autofocus: true,
              textInputAction: TextInputAction.search,
              onChanged: (q) => ref
                  .read(searchControllerProvider.notifier)
                  .run(q),
            ),
          ),
          Expanded(
            child: results.when(
              loading: () => const SizedBox.shrink(),
              error: (e, _) => Center(child: Text('$e')),
              data: (items) => ListView.separated(
                itemCount: items.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (_, i) => InboxItemCard(item: items[i]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
