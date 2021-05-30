import 'dart:async';

import 'package:airbnb/api/flat_provider.dart';
import 'package:airbnb/api/neigbourhood_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

//Prints the map on the screen
class MyGoogleMapWidget extends StatelessWidget {
  MyGoogleMapWidget({
    required this.drawerActive,
    required this.showFlatMarkers,
    required this.showNeighbourhoodMarkers,
  });

  final bool drawerActive;
  final bool showFlatMarkers;
  final bool showNeighbourhoodMarkers;

  final Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    final FlatProvider _myFlatProvider = context.watch<FlatProvider>();
    final NeighbourhoodProvider _myNeighbourhoodProvider =
        context.watch<NeighbourhoodProvider>();

    final Set<Marker> empty = {};
    final Set<Marker> all = {};
    all.addAll(_myFlatProvider.allMarkers);
    all.addAll(_myNeighbourhoodProvider.allNeighbourhoodMarkers);

    if (_myFlatProvider.isLoading == true) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return GoogleMap(
        minMaxZoomPreference: MinMaxZoomPreference(13, 21),
        polygons: showNeighbourhoodMarkers
            ? _myNeighbourhoodProvider.getPolygons
            : {},
        scrollGesturesEnabled: drawerActive == true ? false : true,
        mapType: MapType.normal,
        initialCameraPosition: const CameraPosition(
          target: LatLng(
            52.518817,
            13.407257,
          ),
          zoom: 16,
        ),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: (() {
          if (showFlatMarkers && showNeighbourhoodMarkers) {
            return all;
          } else if (showFlatMarkers) {
            return _myFlatProvider.allMarkers;
          } else if (showNeighbourhoodMarkers) {
            return _myNeighbourhoodProvider.allNeighbourhoodMarkers;
          } else {
            return empty;
          }
        }()),
        gestureRecognizers: {
          Factory<OneSequenceGestureRecognizer>(() => ScaleGestureRecognizer()),
        },
      );
    }
  }
}
