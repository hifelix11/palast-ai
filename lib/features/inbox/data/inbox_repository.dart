/// Abstract inbox contract: stream and one-shot fetch of the user's
/// most recently captured items.
library;

import 'package:palast/shared/models/item.dart';

abstract interface class InboxRepository {
  Future<List<Item>> fetchRecent({int limit = 50});
  Stream<List<Item>> watchRecent({int limit = 50});
}
