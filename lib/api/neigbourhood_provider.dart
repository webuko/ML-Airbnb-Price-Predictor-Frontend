import 'dart:collection';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:airbnb/gist/gist.dart';
import 'package:airbnb/models/polygon_neighbourhood.dart';
import 'package:airbnb/widget/bottom_sheet_widget_filter.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class NeighbourhoodProvider with ChangeNotifier {
  List<PolygonNeighbourhood> _polygonNeighbourhood = [];
  var _context;

  //Maps
  BitmapDescriptor mapMarker = BitmapDescriptor.defaultMarker;

  //Neighbourhoods markers
  List<Marker> _neighbourhoodMarkers = [];
  Set<Polygon> _polygons = HashSet<Polygon>();
  Set<Polygon> get getPolygons {
    return _polygons;
  }

  Set<Marker> get allNeighbourhoodMarkers {
    return Set.from(_neighbourhoodMarkers);
  }

  Future<void> filterAveragePriceListings(FilterSettings filterSettings) async {
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
      data.addAll(_propertyType);
    }

    Map<String, dynamic> _roomType;
    if (filterSettings.roomTypeChecked == true) {
      _roomType = {
        'room_type': [filterSettings.roomType],
      };
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
    const url = 'http://localhost:5000/api/avgPricePerNeighbourhood';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "content-type": "application/json",
        },
        body: jsonEncode(finalData),
      );
      final responseData = polygonNeighbourhoodFromJson(response.body);
      if (responseData == null) {
        return;
      }
      _polygonNeighbourhood = responseData;
      _setPolygon();
      notifyListeners();
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  //Get the average Price per Neighbourhood and polygons for drawing on map.
  Future<void> avgPricePerNeighbourhood(ctx) async {
    _context = ctx;

    const url = 'http://localhost:5000/api/avgPricePerNeighbourhood';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "content-type": "application/json",
        },
      );
      final responseData = polygonNeighbourhoodFromJson(response.body);
      if (responseData == null) {
        return;
      }
      _polygonNeighbourhood = responseData;
      _setPolygon();
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  //Helper method to convert response from json to dart object file
  List<PolygonNeighbourhood> polygonNeighbourhoodFromJson(String str) =>
      List<PolygonNeighbourhood>.from(
          json.decode(str).map((x) => PolygonNeighbourhood.fromJson(x)));

  //Draw Polygon to the Map
  void _setPolygon() {
    _polygons = {};
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
      //Set the color of the polygons according their relative price
      if (element.relAvgPrice! > 0 && element.relAvgPrice! < 0.1) {
        color = Colors.greenAccent.shade700;
      } else if (element.relAvgPrice! > 0.1 && element.relAvgPrice! < 0.2) {
        color = Colors.greenAccent.shade400;
      } else if (element.relAvgPrice! > 0.2 && element.relAvgPrice! < 0.3) {
        color = Colors.greenAccent;
      } else if (element.relAvgPrice! > 0.3 && element.relAvgPrice! < 0.4) {
        color = Colors.yellow.shade300;
      } else if (element.relAvgPrice! > 0.4 && element.relAvgPrice! < 0.5) {
        color = Colors.yellow;
      } else if (element.relAvgPrice! > 0.5 && element.relAvgPrice! < 0.6) {
        color = Colors.yellow.shade700;
      } else if (element.relAvgPrice! > 0.6 && element.relAvgPrice! < 0.7) {
        color = Colors.yellow.shade900;
      } else if (element.relAvgPrice! > 0.7 && element.relAvgPrice! < 0.8) {
        color = Colors.deepOrange.shade700;
      } else if (element.relAvgPrice! > 0.8 && element.relAvgPrice! < 0.9) {
        color = Colors.deepOrange.shade900;
      } else {
        color = Colors.red.shade900;
      }
      //Calculate the center of the polygon and save it in the object.
      element.avgLatLng = computeCentroid(polygonLatLngs);
      _polygons.add(
        Polygon(
            polygonId: PolygonId(polygonIdVal),
            points: polygonLatLngs,
            strokeWidth: 2,
            strokeColor: color,
            fillColor: color.withOpacity(0.15)),
      );
    }
    //The Labels for the maps are generated
    MarkerGenerator(markerWidgets(), (bitmaps) {
      _neighbourhoodMarkers = setNeighbourhoodMarkers(bitmaps);
      notifyListeners();
    }).generate(_context);
  }

  List<Marker> setNeighbourhoodMarkers(List<Uint8List> bitmaps) {
    List<Marker> markersList = [];
    bitmaps.asMap().forEach((i, bmp) {
      markersList.add(Marker(
          markerId: MarkerId(_polygonNeighbourhood[i].neighbourhood.toString()),
          position: LatLng(
            _polygonNeighbourhood[i].avgLatLng!.latitude,
            _polygonNeighbourhood[i].avgLatLng!.longitude,
          ),
          //infoWindow: InfoWindow(title: element.name),
          icon: BitmapDescriptor.fromBytes(bmp)));
    });
    return markersList;
  }

  //Method used to get the Label Widgets for the neigbourhoods
  List<Widget> markerWidgets() {
    return _polygonNeighbourhood
        .map((c) =>
            _getMarkerWidget(c.neighbourhood.toString(), c.avgPrice.toString()))
        .toList();
  }

  //Method used to get a roughly visual center of the neigbourhood
  LatLng computeCentroid(List<LatLng> points) {
    double latitude = 0;
    double longitude = 0;
    int n = points.length;

    for (LatLng point in points) {
      latitude += point.latitude;
      longitude += point.longitude;
    }
    return new LatLng(latitude / n, longitude / n);
  }

  // Marker widget used to display the neighbourhoods label and its average price
  Widget _getMarkerWidget(String name, String avgPrice) {
    double temp = double.parse(avgPrice);
    var temp2 = roundDouble(temp, 2);
    String resultAvgPrice = temp2.toString();
    return Container(
        height: 30,
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 3, vertical: 1.5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black, width: 1),
            color: Colors.white,
            shape: BoxShape.rectangle,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${name}',
                style: TextStyle(fontSize: 8, color: Colors.black),
              ),
              Text(
                'Ø Price = \$${resultAvgPrice}',
                style: TextStyle(fontSize: 8, color: Colors.black),
              )
            ],
          ),
        ));
  }

  //Round a double to 2 digits.
  double roundDouble(double value, int places) {
    num mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }
}
