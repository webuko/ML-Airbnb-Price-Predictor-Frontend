import 'dart:html';

import 'package:flutter/material.dart';

class BottomSheetWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends State<BottomSheetWidget> {
  final String title = "BottomSheetWidget";

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[Text("BottomSheetWidget")],
      ),
    );
  }
}
