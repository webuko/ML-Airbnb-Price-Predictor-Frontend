import 'package:airbnb/models/mockModel.dart';
import 'package:airbnb/models/place.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PlaceLocation initialLocation = PlaceLocation(
      latitude: 47.093907262310566,
      longitude: 8.27200087445975,
      id: "a",
      address: "test");
  final bool isSelecting = false;
  LatLng _pickedLocation;

  void _selectLocation(LatLng position) {
    setState(() {
      _pickedLocation = position;
    });
  }

  @override
  Widget build(BuildContext context) {
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
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  initialLocation.latitude,
                  initialLocation.longitude,
                ),
                zoom: 18,
              ),
              onTap: isSelecting ? _selectLocation : null,
              markers: (_pickedLocation == null && isSelecting)
                  ? null
                  : {
                      Marker(
                        markerId: MarkerId('m1'),
                        position: _pickedLocation ??
                            LatLng(
                              initialLocation.latitude,
                              initialLocation.longitude,
                            ),
                      ),
                    },
            ),
          ),
        ],
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
