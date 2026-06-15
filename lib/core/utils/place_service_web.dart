import 'dart:async';
import 'dart:js' as js;
import 'place_models.dart';
import 'place_service_interface.dart';

class PlaceServiceWeb implements PlaceServiceProvider {
  @override
  Future<List<PlaceSuggestion>> getSuggestions(String input) async {
    if (input.isEmpty) return [];

    final completer = Completer<List<PlaceSuggestion>>();
    js.context.callMethod('getGoogleSuggestions', [
      input,
      (js.JsArray? predictions) {
        if (predictions == null) {
          completer.complete([]);
          return;
        }
        final results = predictions.map((p) {
          final map = p as js.JsObject;
          return PlaceSuggestion(
            placeId: map['placeId'] as String,
            description: map['description'] as String,
          );
        }).toList();
        completer.complete(results);
      }
    ]);
    return completer.future;
  }

  @override
  Future<PlaceDetails?> getPlaceDetails(String placeId) async {
    final completer = Completer<PlaceDetails?>();
    js.context.callMethod('getGooglePlaceDetails', [
      placeId,
      (js.JsObject? details) {
        if (details == null) {
          completer.complete(null);
          return;
        }
        completer.complete(PlaceDetails(
          lat: details['lat'] as double,
          lng: details['lng'] as double,
          address: details['address'] as String,
        ));
      }
    ]);
    return completer.future;
  }
}

PlaceServiceProvider getPlaceService() => PlaceServiceWeb();
