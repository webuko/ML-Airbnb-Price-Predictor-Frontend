import 'dart:collection';

import 'package:airbnb/models/place.dart';
import 'package:airbnb/models/polygon_neighbourhood.dart';
import 'package:airbnb/screens/flat_detail_screen.dart';
import 'package:airbnb/widget/bottom_sheet_widget_filter.dart';
import 'package:airbnb/widget/bottom_sheet_widget_price_prediction.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FlatProvider with ChangeNotifier {
  List<Flat> _flats = [];
  List<PolygonNeighbourhood> _polygonNeighbourhood = [];
  bool _drawerActive = false;
  bool _isLoading = false;
  var _context;

  //Flat attributes
  final List<String> _roomType = [];
  final List<String> _propertyType = [];
  final List<String> _neighbourhood = [];
  final List<String> _neighbourhoodCleansed = [];
  String _predictedPrice = "";

  //Maps
  BitmapDescriptor mapMarker = BitmapDescriptor.defaultMarker;
  List<Marker> _markers = [];

  Set<Polygon> _polygons = HashSet<Polygon>();
  int _polygonIdCounter = 1;
  bool _isPolygon = true; //Default

  Set<Polygon> get getPolygons {
    return _polygons;
  }

  //getters
  bool get isLoading {
    return _isLoading;
  }

  bool get isDrawerOpen {
    return _drawerActive;
  }

  void setDrawerOpen(bool isDrawerOpen) {
    _drawerActive = isDrawerOpen;
  }

  List<Flat> get allFlats {
    return List.from(_flats);
  }

  String get predictedPrice {
    return _predictedPrice;
  }

  List<String> get allRoomTypes {
    return List.from(_roomType);
  }

  List<String> get allPropertyType {
    return List.from(_propertyType);
  }

  List<String> get allNeighbourhood {
    return List.from(_neighbourhood);
  }

  List<String> get allNeighbourhoodCleansed {
    return List.from(_neighbourhoodCleansed);
  }

  List<Marker> get allMarkers {
    return List.from(_markers);
  }

  Flat getLocation(int i) {
    return _flats[i];
  }

  Future setMarkers() async {
    final mapMarker = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(
            size: Size(35, 52), locale: Locale('de', 'CH')),
        'assets/marker.png');
    _markers = [];
    for (final element in _flats) {
      _markers.add(Marker(
        markerId: MarkerId(element.id.toString()),
        position: LatLng(
          element.latitude,
          element.longitude,
        ),
        //infoWindow: InfoWindow(title: element.name),
        icon: mapMarker,
        onTap: () => {
          if (!_drawerActive)
            {
              Navigator.of(_context, rootNavigator: true).push(
                MaterialPageRoute(
                    builder: (context) => FlatDetailScreen(element)),
              ),
            }
        },
      ));
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> allListings(ctx) async {
    _context = ctx;
    _isLoading = true;
    // notifyListeners();
    const url = 'http://localhost:5000/api/allListings';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "content-type": "application/json",
        },
      );
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
          neighbourhood: flatData['neighbourhood'] != null
              ? flatData['neighbourhood']
              : "No neighbourhood data available!",
          roomType: flatData['room_type'] != null
              ? flatData['room_type']
              : "No room type data available!",
          propertyType: flatData['property_type'] != null
              ? flatData['property_type']
              : "No property type data available!",
          latitude: flatData['latitude'],
          longitude: flatData['longitude'],
          accommodates: flatData?['accommodates'],
          bathrooms: flatData?['bathrooms'],
          bedrooms: flatData?['bedrooms'],
          city: flatData['city'] != null ? flatData['city'] : "Not available!",
          price: flatData?['price'],
        );
        if (!_propertyType.contains(place.propertyType!)) {
          _propertyType.add(place.propertyType!);
        }
        if (!_roomType.contains(place.roomType!)) {
          _roomType.add(place.roomType!);
        }
        if (!_neighbourhood.contains(place.neighbourhood!)) {
          _neighbourhood.add(place.neighbourhood!);
        }
        _fetchtedFlatsList.add(place);
      });
      _flats = _fetchtedFlatsList;
      setMarkers();
    } catch (error) {
      debugPrint(error.toString());
      return;
    }
  }

  Future<void> filterListings(FilterSettings filterSettings) async {
    _isLoading = true;
    // notifyListeners();
    final Map<String, dynamic> data = {};

    Map<String, dynamic> _price;
    if (filterSettings.priceChecked == true) {
      _price = {
        'price': [
          filterSettings.currentRangeValuesPrice.start,
          filterSettings.currentRangeValuesPrice.end
        ],
      };
      data.addAll(_price);
    }

    Map<String, dynamic> _bedrooms;
    if (filterSettings.bedroomsChecked == true) {
      _bedrooms = {
        'bedrooms': [
          filterSettings.currentRangeValuesBedrooms.start,
          filterSettings.currentRangeValuesBedrooms.end
        ],
      };
      data.addAll(_bedrooms);
    }

    Map<String, dynamic> _bathrooms;
    if (filterSettings.bathroomsChecked == true) {
      _bathrooms = {
        'bathrooms': [
          filterSettings.currentRangeValuesBathrooms.start,
          filterSettings.currentRangeValuesBathrooms.end
        ],
      };
      data.addAll(_bathrooms);
    }

    Map<String, dynamic> _accommodates;
    if (filterSettings.bathroomsChecked == true) {
      _accommodates = {
        'accommodates': [
          filterSettings.currentRangeValuesAccommodates.start,
          filterSettings.currentRangeValuesAccommodates.end
        ],
      };
      data.addAll(_accommodates);
    }

    Map<String, dynamic> _propertyType;
    if (filterSettings.propertyTypeChecked == true) {
      _propertyType = {
        'property_type': [filterSettings.propertyType],
      };
      //data.addAll(_propertyType);
      data.addAll(_propertyType);
    }

    Map<String, dynamic> _roomType;
    if (filterSettings.roomTypeChecked == true) {
      _roomType = {
        'room_type': [filterSettings.roomType],
      };
      //data.addAll(_roomType);
      data.addAll(_roomType);
    }

    Map<String, dynamic> _neighbourhood;
    if (filterSettings.neighbourhoodTypeChecked == true) {
      _neighbourhood = {
        'neighbourhood': [filterSettings.neighbourhood],
      };
      data.addAll(_neighbourhood);
    }

    Map<String, dynamic> finalData = {};

    if (data.isEmpty) {
      final Map<String, dynamic> _emptyFilter = {'criteria': {}};
      finalData.addAll(_emptyFilter);
    } else {
      finalData = {'criteria': data};
    }

    const url = 'http://localhost:5000/api/filterListings';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "content-type": "application/json",
        },
        body: jsonEncode(finalData),
      );
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
      setMarkers();
    } catch (error) {
      debugPrint(error.toString());
      return;
    }
  }

  Future<void> predictPrice(FilterSettingsPredictPrice filterSettings) async {
    // notifyListeners();
    final map = <String, dynamic>{};
    map["bathrooms"] = filterSettings.currentBathrooms;
    map["bedrooms"] = filterSettings.currentBedrooms;
    map["accommodates"] = filterSettings.currentAccommodates;
    map["guests_included"] = filterSettings.currentGuestIncluded;
    map["gym"] = filterSettings.checkedGym;
    map["ac"] = filterSettings.checkedAirCondition;
    map["elevator"] = filterSettings.checkedElevator;
    map["neighbourhood"] = filterSettings.currentNeighbourhood;
    map["property_type"] = filterSettings.currentPropertyType;
    map["room_type"] = filterSettings.currentRoomType;

    final jsonData = jsonEncode(map);

    const url = 'http://localhost:5000/api/pricePrediction';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "content-type": "application/json",
        },
        body: jsonData,
      );
      //Predicted price
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData == null) {
        return;
      }
      _predictedPrice = responseData["price"];
      print("Price: " + _predictedPrice);
    } catch (error) {
      debugPrint(error.toString());
      return;
    }
  }

  Future<void> predictPriceParams() async {
    const url = 'http://localhost:5000/api/pricePredictionParamValues';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "content-type": "application/json",
        },
      );
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData == null) {
        return;
      }
      final neighbourhood = responseData["neighbourhood"];
      final neighbourhoodListCleansed = neighbourhood["values"];
      neighbourhoodListCleansed.forEach((element) {
        _neighbourhoodCleansed.add(element);
      });
      print(responseData);
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<void> avgPricePerNeighbourhood() async {
    const url = 'http://localhost:5000/api/avgPricePerNeighbourhood';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "content-type": "application/json",
        },
      );
      final welcome = welcomeFromJson(response.body);
      if (welcome == null) {
        return;
      }
      _polygonNeighbourhood = welcome;
      _setPolygon();
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  List<PolygonNeighbourhood> welcomeFromJson(String str) =>
      List<PolygonNeighbourhood>.from(
          json.decode(str).map((x) => PolygonNeighbourhood.fromJson(x)));

  //Draw Polygon to the map
  void _setPolygon() {
    for (PolygonNeighbourhood element in _polygonNeighbourhood) {
      Color color = Colors.red;
      final String polygonIdVal = element.neighbourhood.toString();
      List<LatLng> polygonLatLngs = [];
      for (var i = 0; element.geometry!.coordinates![0][0].length > i; i++) {
        LatLng latLng = LatLng(
          element.geometry!.coordinates![0][0][i][1],
          element.geometry!.coordinates![0][0][i][0],
        );
        polygonLatLngs.add(latLng);
      }
      if (element.relAvgPrice! > 0 && element.relAvgPrice! < 0.1) {
        color = Colors.blue;
      } else if (element.relAvgPrice! > 0.1 && element.relAvgPrice! < 0.2) {
        color = Colors.green;
      } else if (element.relAvgPrice! > 0.2 && element.relAvgPrice! < 0.3) {
        color = Colors.red;
      } else if (element.relAvgPrice! > 0.3 && element.relAvgPrice! < 0.4) {
        color = Colors.teal;
      } else if (element.relAvgPrice! > 0.4 && element.relAvgPrice! < 0.5) {
        color = Colors.amber;
      } else if (element.relAvgPrice! > 0.5 && element.relAvgPrice! < 0.6) {
        color = Colors.pink;
      } else if (element.relAvgPrice! > 0.6 && element.relAvgPrice! < 0.7) {
        color = Colors.purple;
      } else if (element.relAvgPrice! > 0.7 && element.relAvgPrice! < 0.8) {
        color = Colors.orange;
      } else if (element.relAvgPrice! > 0.8 && element.relAvgPrice! < 0.9) {
        color = Colors.indigo;
      } else {
        color = Colors.limeAccent;
      }
      _polygons.add(
        Polygon(
            polygonId: PolygonId(polygonIdVal),
            points: polygonLatLngs,
            strokeWidth: 2,
            strokeColor: color,
            fillColor: color.withOpacity(0.15)),
      );
    }
  }
}
