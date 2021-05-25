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
          name: flatData['name'] != null
              ? flatData['name']
              : "No name available!",
          description: flatData['description'] != null
              ? flatData['description']
              : "No description available!",
          pictureUrl: flatData['picture_url'],
          hostName: flatData['host_name'] != null
              ? flatData['host_name']
              : "No host name available!",
          hostPictureUrl: flatData?['host_picture_url'],
          neighbourhood: flatData['neighbourhood'],
          latitude: flatData['latitude'],
          longitude: flatData['longitude'],
          accommodates: flatData?['accommodates'],
          bathrooms: flatData?['bathrooms'],
          bedrooms: flatData?['bedrooms'],
          city: flatData['city'] != null ? flatData['city'] : "Not available!",
          price: flatData?['price'],
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
    Map<String, dynamic> data = {};
    print(data.isEmpty);

    Map<String, dynamic> _price;
    if (filterSettings.priceChecked == true) {
      _price = {
        'criteria': {
          'price': [
            filterSettings.currentRangeValuesPrice.start,
            filterSettings.currentRangeValuesPrice.end
          ],
        }
      };
      data.addAll(_price);
    }

    Map<String, dynamic> _bedrooms;
    if (filterSettings.bedroomsChecked == true) {
      _bedrooms = {
        'criteria': {
          'bedrooms': [
            filterSettings.currentRangeValuesBedrooms.start,
            filterSettings.currentRangeValuesBedrooms.end
          ],
        }
      };
      data.addAll(_bedrooms);
    }

    Map<String, dynamic> _bathrooms;
    if (filterSettings.bathroomsChecked == true) {
      _bathrooms = {
        'criteria': {
          'bathrooms': [
            filterSettings.currentRangeValuesBathrooms.start,
            filterSettings.currentRangeValuesBathrooms.end
          ],
        }
      };
      data.addAll(_bathrooms);
    }

    Map<String, dynamic> _accommodates;
    if (filterSettings.bathroomsChecked == true) {
      _accommodates = {
        'criteria': {
          'accommodates': [
            filterSettings.currentRangeValuesAccommodates.start,
            filterSettings.currentRangeValuesAccommodates.end
          ],
        }
      };
      data.addAll(_accommodates);
    }

    if (data.isEmpty) {
      Map<String, dynamic> _emptyFilter = {'criteria': {}};
      data.addAll(_emptyFilter);
    }

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
          name: flatData['name'] != null
              ? flatData['name']
              : "No name available!",
          description: flatData['description'] != null
              ? flatData['description']
              : "No description available!",
          pictureUrl: flatData['picture_url'],
          hostName: flatData['host_name'] != null
              ? flatData['host_name']
              : "No host name available!",
          hostPictureUrl: flatData?['host_picture_url'],
          neighbourhood: flatData['neighbourhood'],
          latitude: flatData['latitude'],
          longitude: flatData['longitude'],
          accommodates: flatData?['accommodates'],
          bathrooms: flatData?['bathrooms'],
          bedrooms: flatData?['bedrooms'],
          city: flatData['city'] != null ? flatData['city'] : "Not available!",
          price: flatData?['price'],
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
