import 'package:airbnb/models/place.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PlaceProvider with ChangeNotifier {
  List<PlaceLocation> _places = [];

  List<PlaceLocation> get allEvents {
    return List.from(_places);
  }

  getlocation(int i) {
    return _places[i];
  }

  Future<void> fetchPlaces() async {
    const url = 'https://flutter-products-6da30.firebaseio.com/map.json';
    try {
      final response = await http.get(url).timeout(Duration(seconds: 6));
      final List<PlaceLocation> fetchtedPlacesList = [];
      final Map<String, dynamic> eventListData = json.decode(response.body);
      if (eventListData == null) {
        return;
      }
      eventListData.forEach((String mapId, dynamic eventData) {
        final PlaceLocation place = PlaceLocation(
          id: mapId,
          latitude: double.parse(eventData['latitude']),
          longitude: double.parse(eventData['longitude']),
        );
        fetchtedPlacesList.add(place);
      });
      _places = fetchtedPlacesList;
    } catch (error) {
      return;
    }
  }
}
