import 'place_models.dart';

abstract class PlaceServiceProvider {
  Future<List<PlaceSuggestion>> getSuggestions(String input);
  Future<PlaceDetails?> getPlaceDetails(String placeId);
}
