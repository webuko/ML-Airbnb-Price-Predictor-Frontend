import 'package:airbnb/models/place.dart';
import 'package:airbnb/screens/flat_detail_screen.dart';
import 'package:airbnb/widget/bottom_sheet_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FlatProvider with ChangeNotifier {
  BitmapDescriptor mapMarker = BitmapDescriptor.defaultMarker;
  List<Flat> _flats = [];
  List<Marker> _markers = [];

  List<Flat> get allFlats {
    return List.from(_flats);
  }

  List<Marker> get allMarkers {
    return List.from(_markers);
  }

  getlocation(int i) {
    return _flats[i];
  }

  void setMarkers(context) async {
    var temp = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(35, 52), locale: Locale('de', 'CH')),
        'assets/marker.png');
    mapMarker = temp;
    _markers = [];
    _flats.forEach((element) {
      _markers.add(new Marker(
        markerId: MarkerId(element.name),
        position: LatLng(
          element.latitude,
          element.longitude,
        ),
        //infoWindow: InfoWindow(title: element.name),
        icon: mapMarker,
        onTap: () => {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FlatDetailScreen(element)),
          ),
        },
      ));
    });
    notifyListeners();
  }

  Future<void> allListings(context) async {
    final url = 'http://localhost:5000/api/allListings';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "content-type": "application/json",
        },
      ).timeout(Duration(seconds: 6));
      final List<dynamic> responseData = json.decode(response.body);
      if (responseData == null) {
        return;
      }
      final List<Flat> _fetchtedFlatsList = [];
      responseData.forEach((flatData) {
        final Flat place = Flat(
          id: flatData['id'],
          name: flatData['name'],
          description: flatData['description'],
          pictureUrl: flatData['picture_url'],
          hostName: flatData?['host_name'],
          hostPictureUrl: flatData?['host_picture_url'],
          neighbourhood: flatData['neighbourhood'],
          latitude: flatData['latitude'],
          longitude: flatData['longitude'],
          accommodates: flatData?['accommodates'],
          bathrooms: flatData?['bathrooms'],
          bedrooms: flatData?['bedrooms'],
          city: flatData?['city'],
        );
        _fetchtedFlatsList.add(place);
      });
      _flats = _fetchtedFlatsList;
      setMarkers(context);
    } catch (error) {
      debugPrint(error.toString());
      return;
    }
  }

  Future<void> filterListings(FilterSettings filterSettings, context) async {
    Map<String, dynamic> data = {
      'criteria': {
        'price': [
          filterSettings.currentRangeValuesPrice.start,
          filterSettings.currentRangeValuesPrice.end
        ],
        'bedrooms': [
          filterSettings.currentRangeValuesBedrooms.start,
          filterSettings.currentRangeValuesBedrooms.end
        ],
        'bathrooms': [
          filterSettings.currentRangeValuesBathrooms.start,
          filterSettings.currentRangeValuesBathrooms.end
        ],
        'accommodates': [
          filterSettings.currentRangeValuesAccommodates.start,
          filterSettings.currentRangeValuesAccommodates.end
        ],
      }
    };

    final url = 'http://localhost:5000/api/filterListings';
    try {
      final response = await http
          .post(
            Uri.parse(url),
            headers: {
              "content-type": "application/json",
            },
            body: jsonEncode(data),
          )
          .timeout(Duration(seconds: 6));
      final List<dynamic> responseData = json.decode(response.body);
      if (responseData == null) {
        return;
      }
      final List<Flat> _fetchtedFlatsList = [];
      responseData.forEach((flatData) {
        final Flat place = Flat(
          id: flatData['id'],
          name: flatData['name'],
          description: flatData['description'],
          pictureUrl: flatData['picture_url'],
          hostName: flatData?['host_name'],
          hostPictureUrl: flatData?['host_picture_url'],
          neighbourhood: flatData['neighbourhood'],
          latitude: flatData['latitude'],
          longitude: flatData['longitude'],
          accommodates: flatData?['accommodates'],
          bathrooms: flatData?['bathrooms'],
          bedrooms: flatData?['bedrooms'],
          city: flatData?['city'],
        );
        _fetchtedFlatsList.add(place);
      });
      _flats = _fetchtedFlatsList;
      setMarkers(context);
    } catch (error) {
      debugPrint(error.toString());
      return;
    }
  }
}
