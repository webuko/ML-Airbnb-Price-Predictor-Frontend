import 'dart:async';

import 'package:airbnb/models/mockModel.dart';
import 'package:airbnb/models/place.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'api/flatProvider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Flat initialLocation = Flat(
    name: "none",
    accommodates: 1,
    bathrooms: 1,
    bedrooms: 1,
    description: "Tada",
    neighbourhood: "Tada",
    pictureUrl: "hello",
    latitude: 47.093907262310566,
    longitude: 8.27200087445975,
    id: "a",
  );
  Completer<GoogleMapController> _controller = Completer();

  final bool isSelecting = false;
  bool _isLoading = false;
  late List<Flat>? flats;

  @override
  initState() {
    super.initState();
    _fetchFlates();
  }

  _fetchFlates() async {
    setState(() {
      _isLoading = true;
    });
    await Provider.of<FlatProvider>(context, listen: false).fetchFlats();
    flats = Provider.of<FlatProvider>(context, listen: false).allFlats;
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading == true) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else
      return Scaffold(
        appBar: AppBar(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                top: 10.0,
                left: 10.0,
              ),
              child: Text(
                "Highest Total Revenue",
                style: TextStyle(
                    fontSize: 30.0,
                    color: Colors.black54,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 10.0),
              height: 220.0,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return _buildHighestRevenueList(
                        context, index, categoryList.host);
                  }),
            ),
            Expanded(
              child: _googlemap(),
            ),
          ],
        ),
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

Widget _buildHighestRevenueList(context, index, List<Host> listImages) {
  return Container(
    width: 200.0,
    padding: const EdgeInsets.only(left: 10.0, top: 10.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.asset(
              listImages[index].image,
              width: 220.0,
              height: 100.0,
              fit: BoxFit.cover,
            )),
        Text(
          listImages[index].name,
          style: TextStyle(color: Colors.grey),
        ),
        Text(
          listImages[index].desc,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0),
        ),
        Text(listImages[index].price, style: TextStyle(fontSize: 12.0)),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(
              Icons.star,
              color: Colors.red,
              size: 15.0,
            ),
            Icon(
              Icons.star,
              color: Colors.red,
              size: 15.0,
            ),
            Icon(
              Icons.star,
              color: Colors.red,
              size: 15.0,
            ),
            Icon(
              Icons.star,
              color: Colors.red,
              size: 15.0,
            ),
            Icon(
              Icons.star,
              color: Colors.red,
              size: 15.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(listImages[index].rating),
            ),
          ],
        )
      ],
    ),
  );
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
  markerId: MarkerId('newYorkMarker2'),
  position: LatLng(
    47.09331469672135,
    8.271784471241508,
  ),
  infoWindow: InfoWindow(title: "Centrum 2"),
  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
);
