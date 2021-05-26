import 'dart:async';

import 'package:airbnb/models/mockModel.dart';
import 'package:airbnb/widget/bottom_sheet_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../api/flatProvider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final bool isSelecting = false;
  bool _isLoadingFlats = false;
  bool _showBottomSheet = false;

  @override
  initState() {
    super.initState();
    _fetchFlates();
  }

  _fetchFlates() async {
    setState(() {
      _isLoadingFlats = true;
    });
    await Provider.of<FlatProvider>(context, listen: false)
        .allListings(context);
    //setMarkers();
    setState(() {
      _isLoadingFlats = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingFlats == true) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else
      return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () => {
                      setState(() {
                        _showBottomSheet = !_showBottomSheet;
                      })
                    },
                icon: Icon(Icons.filter_alt))
          ],
        ),
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
            Container(
              child: Expanded(
                child: MyGoogleMapWidget(),
              ),
            ),
            _showBottomSheet == true
                ? BottomSheetWidget()
                : Container(
                    height: 0,
                  ),
          ],
        ),
      );
  }
}

class MyGoogleMapWidget extends StatelessWidget {
  final Completer<GoogleMapController> _controller = Completer();

  Widget build(BuildContext context) {
    final myFlatProvider = context.watch<FlatProvider>();
    if (myFlatProvider.isLoading == true) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else
      return Container(
        child: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
            target: LatLng(
              52.518817,
              13.407257,
            ),
            zoom: 16,
          ),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          markers: Set.from(myFlatProvider.allMarkers),
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
