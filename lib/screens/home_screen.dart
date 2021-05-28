import 'dart:async';

import 'package:airbnb/models/mockModel.dart';
import 'package:airbnb/widget/bottom_sheet_widget_filter.dart';
import 'package:airbnb/widget/bottom_sheet_widget_price_prediction.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:provider/provider.dart';

import '../api/flatProvider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final bool isSelecting = false;
  bool _isLoadingFlats = false;
  bool _showBottomSheetFiltering = false;
  bool _showBottomSheetPricePrediction = false;
  bool _showFloatingActionButton = false;

  @override
  initState() {
    super.initState();
    _fetchFlates();
    _fetchPricePredictParams();
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

  _fetchPricePredictParams() async {
    await Provider.of<FlatProvider>(context, listen: false)
        .predictPriceParams();
  }

  @override
  Widget build(BuildContext context) {
    final myFlatProvider = context.read<FlatProvider>();
    if (_isLoadingFlats == true) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else
      return Scaffold(
        onEndDrawerChanged: (isOpen) {
          setState(() {
            myFlatProvider.setDrawerOpen(isOpen);
          });
        },
        endDrawer: PointerInterceptor(
          child: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(color: Colors.blue),
                  child: Text(
                    "Airbnb flat price calculator",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.filter_alt),
                  title: Text(
                    'Filter Listings',
                    style: TextStyle(fontSize: 16),
                  ),
                  onTap: () {
                    // Update the state of the app
                    setState(() {
                      //Set other bottom sheets to false
                      _showBottomSheetPricePrediction = false;

                      _showBottomSheetFiltering = true;
                      _showFloatingActionButton = true;
                    });
                    // Then close the drawer
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.calculate),
                  title: Text(
                    'Price prediction',
                    style: TextStyle(fontSize: 16),
                  ),
                  onTap: () {
                    // Update the state of the app
                    setState(() {
                      //Set other bottom sheets to false
                      _showBottomSheetFiltering = false;

                      _showBottomSheetPricePrediction = true;
                      _showFloatingActionButton = true;
                    });
                    // Then close the drawer
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
        appBar: AppBar(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            /* Padding(
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
            ),*/
            Container(
              child: Expanded(
                child: MyGoogleMapWidget(myFlatProvider.isDrawerOpen),
              ),
            ),
            Container(
              height: (_showBottomSheetFiltering == true)
                  ? (MediaQuery.of(context).size.height / 2)
                  : 0,
              child: BottomSheetWidgetFiltering(),
            ),
            Container(
              height: (_showBottomSheetPricePrediction == true)
                  ? (MediaQuery.of(context).size.height / 1.5)
                  : 0,
              child: BottomSheetWidgetPricePrediction(),
            ),
            /* (() {
              if (_showBottomSheetFiltering == true) {
                return BottomSheetWidgetFiltering();
              } else if (_showBottomSheetPricePrediction == true) {
                return BottomSheetWidgetPricePrediction();
              } else {
                return Container(
                  height: 0,
                );
              }
            }())*/
          ],
        ),
        floatingActionButton: _showFloatingActionButton == true
            ? FloatingActionButton(
                onPressed: () {
                  print('Floating action button pressed');
                  setState(() {
                    _showBottomSheetFiltering = false;
                    _showBottomSheetPricePrediction = false;
                    _showFloatingActionButton = false;
                  });
                },
                child: const Icon(Icons.close),
              )
            : null,
        //floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      );
  }
}

class MyGoogleMapWidget extends StatelessWidget {
  final bool _drawerActive;
  MyGoogleMapWidget(this._drawerActive);
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
          scrollGesturesEnabled: _drawerActive == true ? false : true,
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
          gestureRecognizers: {
            Factory<OneSequenceGestureRecognizer>(
                () => ScaleGestureRecognizer()),
          },
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
