import 'dart:async';
import 'dart:typed_data';
import 'package:airbnb/api/neigbourhood_provider.dart';
import 'package:airbnb/gist/Gist.dart';
import 'package:airbnb/widget/bottom_sheet_widget_filter.dart';
import 'package:airbnb/widget/bottom_sheet_widget_price_prediction.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:provider/provider.dart';

import '../api/flat_provider.dart';

//@HomeScreen class
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

  bool _showFlatMarkers = true;
  bool _showNeighbourhoodMarkers = true;

  @override
  initState() {
    super.initState();
    _fetchFlates();
    //Fetch the params that can be used for the neigbourhood in the "predict Price" form.
    _fetchPricePredictParams();
    _fetchAvgPricePerNeighbourhood();
  }

  Future _fetchFlates() async {
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

  Future _fetchPricePredictParams() async {
    await Provider.of<FlatProvider>(context, listen: false)
        .predictPriceParams();
  }

  Future _fetchAvgPricePerNeighbourhood() async {
    await Provider.of<NeighbourhoodProvider>(context, listen: false)
        .avgPricePerNeighbourhood(context);
  }

  @override
  Widget build(BuildContext context) {
    final FlatProvider myFlatProvider = context.read<FlatProvider>();
    if (_isLoadingFlats == true) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Scaffold(
        onDrawerChanged: (isOpen) {
          setState(
            () {
              myFlatProvider.setDrawerOpen(isOpen);
            },
          );
        },
        drawer: PointerInterceptor(
          child: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const DrawerHeader(
                  decoration: BoxDecoration(color: Colors.blue),
                  child: Text(
                    "Airbnb flat price calculator",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.filter_alt),
                  title: const Text(
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
                  leading: const Icon(Icons.calculate),
                  title: const Text(
                    'Price prediction',
                    style: TextStyle(fontSize: 16),
                  ),
                  onTap: () {
                    // Update the state of the app
                    setState(
                      () {
                        //Set other bottom sheets to false
                        _showBottomSheetFiltering = false;

                        _showBottomSheetPricePrediction = true;
                        _showFloatingActionButton = true;
                      },
                    );
                    // Then close the drawer
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
        appBar: AppBar(actions: <Widget>[
          (_showNeighbourhoodMarkers)
              ? IconButton(
                  icon: const Icon(Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _showNeighbourhoodMarkers = !_showNeighbourhoodMarkers;
                    });
                  },
                )
              : IconButton(
                  icon: const Icon(Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _showNeighbourhoodMarkers = !_showNeighbourhoodMarkers;
                    });
                  },
                ),
          (_showFlatMarkers)
              ? IconButton(
                  icon: const Icon(Icons.location_off),
                  onPressed: () {
                    setState(() {
                      _showFlatMarkers = !_showFlatMarkers;
                    });
                  },
                )
              : IconButton(
                  icon: const Icon(Icons.location_on),
                  onPressed: () {
                    setState(() {
                      _showFlatMarkers = !_showFlatMarkers;
                    });
                  },
                ),
        ]),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: MyGoogleMapWidget(
                drawerActive: myFlatProvider.isDrawerOpen,
                showFlatMarkers: _showFlatMarkers,
                showNeighbourhoodMarkers: _showNeighbourhoodMarkers,
              ),
            ),
            SizedBox(
              height: (_showBottomSheetFiltering == true)
                  ? (MediaQuery.of(context).size.height / 2)
                  : 0,
              child: BottomSheetWidgetFiltering(),
            ),
            SizedBox(
              height: (_showBottomSheetPricePrediction == true)
                  ? (MediaQuery.of(context).size.height / 1.5)
                  : 0,
              child: BottomSheetWidgetPricePrediction(),
            ),
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
      );
    }
  }
}

class MyGoogleMapWidget extends StatelessWidget {
  //MyGoogleMapWidget
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
