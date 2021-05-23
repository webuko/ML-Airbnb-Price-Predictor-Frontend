import 'package:airbnb/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';

import 'api/flatProvider.dart';

void main() {
  setPathUrlStrategy();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  void initState() {
    super.initState();
  }

  build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => FlatProvider(),
        ),
      ],
      child: MaterialApp(
        home: HomeScreen(),
      ),
      /*MaterialApp(
        routes: {
          '/': (BuildContext context) => QuizzMap(
                initialLocation: PlaceLocation(
                    latitude: 47.093907262310566,
                    longitude: 8.27200087445975,
                    id: "a",
                    address: "test"),
                isSelecting: false,
              ),
        },
      ),*/
    );
  }
}
