import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'place_models.dart';
import 'place_service_interface.dart';
import 'place_service_stub.dart'
    if (dart.library.js) 'place_service_web.dart'
    if (dart.library.io) 'place_service_io.dart';

export 'place_models.dart';

part 'place_service.g.dart';

@riverpod
PlaceServiceProvider placeService(PlaceServiceRef ref) {
  return getPlaceService();
}
