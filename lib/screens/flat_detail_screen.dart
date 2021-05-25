import 'package:airbnb/models/place.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FlatDetailScreen extends StatefulWidget {
  final Flat element;

  const FlatDetailScreen(this.element);

  @override
  _FlatDetailcreenState createState() => _FlatDetailcreenState(element);
}

class _FlatDetailcreenState extends State<FlatDetailScreen> {
  Flat element;

  _FlatDetailcreenState(this.element);

  late GoogleMapController mapController;

  final LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: ListView(
        children: <Widget>[
          AppBar(
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back),
            ),
            actions: [],
          ),
          Container(
            height: 300,
            child: Image.network(
              element.pictureUrl,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            child: Container(
              padding: EdgeInsets.all(10.0),
              child: Text(
                element.name,
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Container(
            child: Container(
              padding: EdgeInsets.only(left: 10.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: CircleAvatar(
                          radius: 30.0,
                          backgroundImage: NetworkImage(element.pictureUrl),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Entire House",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 3.0),
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      "Hosted By",
                                      style: TextStyle(color: Colors.black54),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 3.0),
                                      child: Text(
                                        "Raphael (static)",
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    "See Ratings",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      "*****",
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: <Widget>[
                            Icon(
                              Icons.location_on,
                              color: Theme.of(context).primaryColor,
                            ),
                            Text(
                              "Berlin (static)",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "About this Home",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text(
                            element.description,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Text(
                            "Read More....",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Text(
                            "Check in: After 3pm",
                            style: TextStyle(
                                color: Colors.black54, fontSize: 16.0),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(bottom: 10.0, right: 10.0),
                        child: Text(
                          "Check Out:11am",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16.0),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                      height: 400.0,
                      child:
                          Container() /*GoogleMap(
                        onMapCreated: _onMapCreated,
                        options: GoogleMapOptions(
                          cameraPosition: CameraPosition(
                            target: _center,
                            zoom: 11.0,
                          ),
                        ),
                      ),*/
                      )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
