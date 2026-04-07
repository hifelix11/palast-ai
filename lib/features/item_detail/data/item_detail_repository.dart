/// Abstract item-detail contract.
library;

import 'package:palast/features/library/domain/models/knowledge_item.dart';

abstract interface class ItemDetailRepository {
  Future<KnowledgeItem> fetch(String itemId);
}
