import 'dart:async';
import 'dart:js' as js;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'place_service.g.dart';

class PlaceSuggestion {
  final String placeId;
  final String description;

  PlaceSuggestion({required this.placeId, required this.description});
}

class PlaceDetails {
  final double lat;
  final double lng;
  final String address;

  PlaceDetails({required this.lat, required this.lng, required this.address});
}

class PlaceService {
  final String apiKey = 'AIzaSyAC3dXZ-loyhd4Cjk0zZ2gZGwo9ValLE9g';

  Future<List<PlaceSuggestion>> getSuggestions(String input) async {
    if (input.isEmpty) return [];

    if (kIsWeb) {
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
    } else {
      // Fallback for mobile (REST API)
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$apiKey',
      );
      try {
        final response = await http.get(url);
        if (response.statusCode == 200) {
          final result = json.decode(response.body);
          if (result['status'] == 'OK') {
            return (result['predictions'] as List)
                .map((p) => PlaceSuggestion(
                      placeId: p['place_id'],
                      description: p['description'],
                    ))
                .toList();
          }
        }
      } catch (e) {
        print('REST Suggestions Error: $e');
      }
    }
    return [];
  }

  Future<PlaceDetails?> getPlaceDetails(String placeId) async {
    if (kIsWeb) {
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
    } else {
      // Fallback for mobile (REST API)
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=geometry,formatted_address&key=$apiKey',
      );
      try {
        final response = await http.get(url);
        if (response.statusCode == 200) {
          final result = json.decode(response.body);
          if (result['status'] == 'OK') {
            final geometry = result['result']['geometry']['location'];
            return PlaceDetails(
              lat: geometry['lat'],
              lng: geometry['lng'],
              address: result['result']['formatted_address'],
            );
          }
        }
      } catch (e) {
        print('REST Details Error: $e');
      }
    }
    return null;
  }
}

@riverpod
PlaceService placeService(PlaceServiceRef ref) {
  return PlaceService();
}
