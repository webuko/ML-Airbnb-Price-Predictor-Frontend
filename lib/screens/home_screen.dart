import 'dart:async';
import 'package:airbnb/api/neigbourhood_provider.dart';
import 'package:airbnb/widget/bottom_sheet_widget_filter.dart';
import 'package:airbnb/widget/bottom_sheet_widget_price_prediction.dart';
import 'package:airbnb/widget/google_maps_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
  //Parametrisation
  bool _showBottomSheetFiltering = false;
  bool _showBottomSheetPricePrediction = false;
  bool _showFloatingActionButton = false;
  bool _showFlatMarkers = false;
  bool _showNeighbourhoodMarkers = true;

  @override
  initState() {
    super.initState();
    _fetchFlates();
    _fetchPricePredictParams();
    _fetchAvgPricePerNeighbourhood();
  }

  //Fetch all Listings
  Future _fetchFlates() async {
    setState(() {
      _isLoadingFlats = true;
    });
    await Provider.of<FlatProvider>(context, listen: false)
        .allListings(context);
    setState(() {
      _isLoadingFlats = false;
    });
  }

  //Fetch intial average Price for all Listings and Polygons for neighbourhoods
  Future _fetchAvgPricePerNeighbourhood() async {
    await Provider.of<NeighbourhoodProvider>(context, listen: false)
        .avgPricePerNeighbourhood(context);
  }

  //Fetch the data for the forms in the filterings
  Future _fetchPricePredictParams() async {
    await Provider.of<FlatProvider>(context, listen: false)
        .predictPriceParams();
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
                  icon: const Icon(Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _showNeighbourhoodMarkers = !_showNeighbourhoodMarkers;
                    });
                  },
                )
              : IconButton(
                  icon: const Icon(Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _showNeighbourhoodMarkers = !_showNeighbourhoodMarkers;
                    });
                  },
                ),
          (_showFlatMarkers)
              ? IconButton(
                  icon: const Icon(Icons.location_on),
                  onPressed: () {
                    setState(() {
                      _showFlatMarkers = !_showFlatMarkers;
                    });
                  },
                )
              : IconButton(
                  icon: const Icon(Icons.location_off),
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
