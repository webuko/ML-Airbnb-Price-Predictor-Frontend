import 'package:airbnb/models/place.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FlatProvider with ChangeNotifier {
  List<Flat> _flats = [];

  List<Flat> get allFlats {
    return List.from(_flats);
  }

  getlocation(int i) {
    return _flats[i];
  }

  Future<void> fetchFlats() async {
    final url = 'http://localhost:5000/api/allListings';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "content-type": "application/json",
        },
      ).timeout(Duration(seconds: 6));
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData == null) {
        return;
      }
      final List<Flat> _fetchtedFlatsList = [];
      responseData.forEach((String flatId, flatData) {
        final Flat place = Flat(
          id: flatData['id'],
          name: flatData['name'],
          description: flatData['description'],
          pictureUrl: flatData['picture_url'],
          neighbourhood: flatData['accommodates'],
          latitude: double.parse(flatData['latitude']),
          longitude: double.parse(flatData['longitude']),
          accommodates: int.parse(flatData['accommodates']),
          bathrooms: int.parse(flatData['bathrooms']),
          bedrooms: int.parse(flatData['bedrooms']),
        );
        _fetchtedFlatsList.add(place);
      });
      _flats = _fetchtedFlatsList;
    } catch (error) {
      debugPrint(error.toString());
      return;
    }
  }
}
