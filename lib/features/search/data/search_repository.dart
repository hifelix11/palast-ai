/// Abstract search contract.
library;

import 'package:palast/shared/models/item.dart';

abstract interface class SearchRepository {
  Future<List<Item>> search(String query);
}
