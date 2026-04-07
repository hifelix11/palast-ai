/// Abstract capture contract: hand it a [CaptureInput] and it makes
/// sure it ends up in Palast and queued for processing.
library;

import 'package:palast/features/capture/domain/models/capture_input.dart';
import 'package:palast/shared/models/item.dart';

abstract interface class CaptureRepository {
  Future<Item> capture(CaptureInput input);
}
