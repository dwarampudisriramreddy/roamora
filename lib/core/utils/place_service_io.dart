import 'place_models.dart';
import 'place_service_interface.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PlaceServiceIo implements PlaceServiceProvider {
  final String apiKey = 'AIzaSyAC3dXZ-loyhd4Cjk0zZ2gZGwo9ValLE9g';

  @override
  Future<List<PlaceSuggestion>> getSuggestions(String input) async {
    if (input.isEmpty) return [];

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
    return [];
  }

  @override
  Future<PlaceDetails?> getPlaceDetails(String placeId) async {
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
    return null;
  }
}

PlaceServiceProvider getPlaceService() => PlaceServiceIo();
