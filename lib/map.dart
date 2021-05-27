import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'models/place.dart';

class HomeMap extends StatefulWidget {
  final Flat initialLocation;
  final bool isSelecting;

  HomeMap({
    required this.initialLocation,
    this.isSelecting = false,
  });

  @override
  _BaseMapState createState() => _BaseMapState();
}

class _BaseMapState extends State<HomeMap> {
  Completer<GoogleMapController> _controller = Completer();
  late LatLng _pickedLocation;

  void _selectLocation(LatLng position) {
    setState(() {
      _pickedLocation = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
        actions: <Widget>[
          if (widget.isSelecting)
            IconButton(
              icon: Icon(Icons.check),
              onPressed: _pickedLocation == null
                  ? null
                  : () {
                      Navigator.of(context, rootNavigator: true)
                          .pop(_pickedLocation);
                    },
            ),
        ],
      ),
      body:
          _googlemap(), /*GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(
            widget.initialLocation.latitude,
            widget.initialLocation.longitude,
          ),
          zoom: 18,
        ),
        onTap: widget.isSelecting ? _selectLocation : null,
        markers: (_pickedLocation == null && widget.isSelecting)
            ? null
            : {
                Marker(
                  markerId: MarkerId('m1'),
                  position: _pickedLocation ??
                      LatLng(
                        widget.initialLocation.latitude,
                        widget.initialLocation.longitude,
                      ),
                ),
              },
      ),*/
    );
  }

  Widget _googlemap() {
    return Container(
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: LatLng(
            47.093907262310566,
            8.27200087445975,
          ),
          zoom: 18,
        ),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: {newYorkMarker, newYorkMarker2},
      ),
    );
  }
}

Marker newYorkMarker = Marker(
  markerId: MarkerId('newYorkMarker'),
  position: LatLng(
    47.093907262310566,
    8.27200087445975,
  ),
  infoWindow: InfoWindow(title: "Centrum hehe"),
  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
);

Marker newYorkMarker2 = Marker(
  markerId: MarkerId('newYorkMarker'),
  position: LatLng(
    47.093907262310000,
    8.27200087445000,
  ),
  infoWindow: InfoWindow(title: "Centrum 2"),
  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
);
