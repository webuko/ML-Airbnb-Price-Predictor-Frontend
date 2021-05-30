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
  Widget build(BuildContext flatScreenContext) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: ListView(
        children: <Widget>[
          AppBar(
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(flatScreenContext);
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
                          backgroundImage: element.hostPictureUrl != null
                              ? (NetworkImage(element.hostPictureUrl!))
                              : (NetworkImage(element.pictureUrl)),
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
                                        element.hostName,
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
                        child: Text(
                          "Price: " + element.price.toString() + "€",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color: Theme.of(context).primaryColor),
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
                              element.city,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Text(
                            "Accommodates: " + element.accommodates.toString(),
                            style: TextStyle(
                                color: Colors.black54, fontSize: 16.0),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(bottom: 10.0, right: 10.0),
                        child: Text(
                          "Bedrooms: " + element.bedrooms.toString(),
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16.0),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(bottom: 10.0, right: 10.0),
                        child: Text(
                          "Bathrooms: " + element.bathrooms.toString(),
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16.0),
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
                            cutDescription(element.description),
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //Cut everything after the last dot, since the database isn't providing a full description.
  String cutDescription(String description) {
    String result = "";
    int pos = 0;
    if (description.contains(".")) {
      pos = description.lastIndexOf(".");
      result = (pos != -1) ? description.substring(0, pos + 1) : description;
    }
    return result;
  }
}
