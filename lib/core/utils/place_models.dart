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
