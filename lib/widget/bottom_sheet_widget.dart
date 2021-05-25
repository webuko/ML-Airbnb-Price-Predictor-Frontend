import 'package:airbnb/api/flatProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomSheetWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BottomSheetWidgetState();
}

class FilterSettings {
  RangeValues _currentRangeValuesPrice = const RangeValues(0, 200);
  RangeValues _currentRangeValuesBedrooms = const RangeValues(1, 10);
  RangeValues _currentRangeValuesBathrooms = const RangeValues(1, 10);
  RangeValues _currentRangeValuesAccommodates = const RangeValues(1, 20);
  bool _priceChecked = false;
  bool _bedroomsChecked = false;
  bool _bathroomsChecked = false;
  bool _accommodatesChecked = false;

  bool get priceChecked {
    return _priceChecked;
  }

  bool get bedroomsChecked {
    return _bedroomsChecked;
  }

  bool get bathroomsChecked {
    return _bathroomsChecked;
  }

  bool get accommodatesChecked {
    return _accommodatesChecked;
  }

  RangeValues get currentRangeValuesPrice {
    return _currentRangeValuesPrice;
  }

  RangeValues get currentRangeValuesBedrooms {
    return _currentRangeValuesBedrooms;
  }

  RangeValues get currentRangeValuesBathrooms {
    return _currentRangeValuesBathrooms;
  }

  RangeValues get currentRangeValuesAccommodates {
    return _currentRangeValuesAccommodates;
  }
}

class _BottomSheetWidgetState extends State<BottomSheetWidget> {
  final String title = "BottomSheetWidget";
  FilterSettings filterSettings = FilterSettings();

  @override
  Widget build(BuildContext context) {
    final myFlatProvider = context.watch<FlatProvider>();
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text("Filter Listings (" +
              myFlatProvider.allFlats.length.toString() +
              " flats left)"),
          Container(
            height: 50,
            child: Row(
              children: [
                Checkbox(
                  value: this.filterSettings._priceChecked,
                  onChanged: (value) {
                    setState(() {
                      this.filterSettings._priceChecked = value!;
                    });
                  },
                ),
                Container(
                  width: 100,
                  child: Text("Price"),
                ),
                filterSettings._priceChecked == false
                    ? Container()
                    : Container(
                        width: 80,
                        child: Text(
                          "(" +
                              filterSettings._currentRangeValuesPrice.start
                                  .round()
                                  .toString() +
                              "€ - " +
                              filterSettings._currentRangeValuesPrice.end
                                  .round()
                                  .toString() +
                              "€)",
                          textAlign: TextAlign.center,
                        ),
                      ),
                filterSettings._priceChecked == false
                    ? Container()
                    : Expanded(
                        child: RangeSlider(
                          values: filterSettings._currentRangeValuesPrice,
                          min: 0,
                          max: 1000,
                          divisions: 1000,
                          labels: RangeLabels(
                            filterSettings._currentRangeValuesPrice.start
                                .round()
                                .toString(),
                            filterSettings._currentRangeValuesPrice.end
                                .round()
                                .toString(),
                          ),
                          onChanged: (RangeValues values) {
                            setState(() {
                              filterSettings._currentRangeValuesPrice = values;
                            });
                          },
                        ),
                      )
              ],
            ),
          ),
          Container(
            height: 50,
            child: Row(
              children: [
                Checkbox(
                  value: this.filterSettings._bedroomsChecked,
                  onChanged: (value) {
                    setState(() {
                      this.filterSettings._bedroomsChecked = value!;
                    });
                  },
                ),
                Container(
                  width: 100,
                  child: Text("Bedrooms"),
                ),
                filterSettings._bedroomsChecked == false
                    ? Container()
                    : Container(
                        width: 80,
                        child: Text(
                          "(" +
                              filterSettings._currentRangeValuesBedrooms.start
                                  .round()
                                  .toString() +
                              " - " +
                              filterSettings._currentRangeValuesBedrooms.end
                                  .round()
                                  .toString() +
                              ")",
                          textAlign: TextAlign.center,
                        ),
                      ),
                filterSettings._bedroomsChecked == false
                    ? Container()
                    : Expanded(
                        child: RangeSlider(
                          values: filterSettings._currentRangeValuesBedrooms,
                          min: 1,
                          max: 10,
                          divisions: 9,
                          labels: RangeLabels(
                            filterSettings._currentRangeValuesBedrooms.start
                                .round()
                                .toString(),
                            filterSettings._currentRangeValuesBedrooms.end
                                .round()
                                .toString(),
                          ),
                          onChanged: (RangeValues values) {
                            setState(() {
                              filterSettings._currentRangeValuesBedrooms =
                                  values;
                            });
                          },
                        ),
                      )
              ],
            ),
          ),
          Container(
            height: 50,
            child: Row(
              children: [
                Checkbox(
                  value: this.filterSettings._bathroomsChecked,
                  onChanged: (value) {
                    setState(() {
                      this.filterSettings._bathroomsChecked = value!;
                    });
                  },
                ),
                Container(
                  width: 100,
                  child: Text("Bathrooms"),
                ),
                filterSettings._bathroomsChecked == false
                    ? Container()
                    : Container(
                        width: 80,
                        child: Text(
                          "(" +
                              filterSettings._currentRangeValuesBathrooms.start
                                  .round()
                                  .toString() +
                              " - " +
                              filterSettings._currentRangeValuesBathrooms.end
                                  .round()
                                  .toString() +
                              ")",
                          textAlign: TextAlign.center,
                        ),
                      ),
                filterSettings._bathroomsChecked == false
                    ? Container()
                    : Expanded(
                        child: RangeSlider(
                          values: filterSettings._currentRangeValuesBathrooms,
                          min: 1,
                          max: 10,
                          divisions: 9,
                          labels: RangeLabels(
                            filterSettings._currentRangeValuesBathrooms.start
                                .round()
                                .toString(),
                            filterSettings._currentRangeValuesBathrooms.end
                                .round()
                                .toString(),
                          ),
                          onChanged: (RangeValues values) {
                            setState(() {
                              filterSettings._currentRangeValuesBathrooms =
                                  values;
                            });
                          },
                        ),
                      )
              ],
            ),
          ),
          Container(
            height: 50,
            child: Row(
              children: [
                Checkbox(
                  value: this.filterSettings._accommodatesChecked,
                  onChanged: (value) {
                    setState(() {
                      this.filterSettings._accommodatesChecked = value!;
                    });
                  },
                ),
                Container(
                  width: 100,
                  child: Text("Accommodates"),
                ),
                filterSettings._accommodatesChecked == false
                    ? Container()
                    : Container(
                        width: 80,
                        child: Text(
                          "(" +
                              filterSettings
                                  ._currentRangeValuesAccommodates.start
                                  .round()
                                  .toString() +
                              " - " +
                              filterSettings._currentRangeValuesAccommodates.end
                                  .round()
                                  .toString() +
                              ")",
                          textAlign: TextAlign.center,
                        ),
                      ),
                filterSettings._accommodatesChecked == false
                    ? Container()
                    : Expanded(
                        child: RangeSlider(
                          values:
                              filterSettings._currentRangeValuesAccommodates,
                          min: 1,
                          max: 20,
                          divisions: 19,
                          labels: RangeLabels(
                            filterSettings._currentRangeValuesAccommodates.start
                                .round()
                                .toString(),
                            filterSettings._currentRangeValuesAccommodates.end
                                .round()
                                .toString(),
                          ),
                          onChanged: (RangeValues values) {
                            setState(() {
                              filterSettings._currentRangeValuesAccommodates =
                                  values;
                            });
                          },
                        ),
                      ),
              ],
            ),
          ),
          ElevatedButton(
            child: Text('Speichern'),
            onPressed: () => {
              _submit(filterSettings, myFlatProvider),
            },
          ),
        ],
      ),
    );
  }

  Future<void> _submit(FilterSettings filterSettings, myFlatProvider) async {
    await myFlatProvider.filterListings(filterSettings, context);
  }
}
