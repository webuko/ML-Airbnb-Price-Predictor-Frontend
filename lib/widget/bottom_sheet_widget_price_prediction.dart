import 'package:airbnb/api/flatProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';

class BottomSheetWidgetPricePrediction extends StatefulWidget {
  @override
  State<StatefulWidget> createState() =>
      _BottomSheetWidgetPricePredictionState();
}

class FilterSettingsPredictPrice {
  //Numeric filters
  int _bathrooms = 1;
  int _bedrooms = 1;
  int _accommodates = 1;
  int _guestIncluded = 1;

  bool _checkedAirCondition = false;
  bool _checkedElevator = false;
  bool _checkedGym = false;

  bool get checkedAirCondition {
    return _checkedAirCondition;
  }

  bool get checkedElevator {
    return _checkedElevator;
  }

  bool get checkedGym {
    return _checkedGym;
  }

  int get currentBathrooms {
    return _bathrooms;
  }

  int get currentBedrooms {
    return _bedrooms;
  }

  int get currentAccommodates {
    return _accommodates;
  }

  int get currentGuestIncluded {
    return _guestIncluded;
  }

  //Filters by String
  String? propertyType = "";
  String? roomType = "";
  String? neighbourhood = "";

  String get currentPropertyType {
    return propertyType!;
  }

  String get currentRoomType {
    return roomType!;
  }

  String get currentNeighbourhood {
    return neighbourhood!;
  }
}

class _BottomSheetWidgetPricePredictionState
    extends State<BottomSheetWidgetPricePrediction> {
  final String title = "BottomSheetWidget";
  FilterSettingsPredictPrice filterSettings = FilterSettingsPredictPrice();

  final controllerPropertyType = TextEditingController();
  final controllerRoomType = TextEditingController();
  final controllerNeighbourhood = TextEditingController();

  final formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final myFlatProvider = context.watch<FlatProvider>();

    List<String> getSuggestionsPropertyTypes(String query) =>
        List.of(myFlatProvider.allPropertyType).where((input) {
          final inputLower = input.toLowerCase();
          final queryLower = query.toLowerCase();
          return inputLower.contains(queryLower);
        }).toList();

    List<String> getSuggestionsRoomTypes(String query) =>
        List.of(myFlatProvider.allRoomTypes).where((input) {
          final inputLower = input.toLowerCase();
          final queryLower = query.toLowerCase();
          return inputLower.contains(queryLower);
        }).toList();

    List<String> getSuggestionsNeighbourhood(String query) =>
        List.of(myFlatProvider.allNeighbourhoodCleansed).where((input) {
          final inputLower = input.toLowerCase();
          final queryLower = query.toLowerCase();
          return inputLower.contains(queryLower);
        }).toList();

    Widget buildPropertyType() => TypeAheadFormField<String?>(
          direction: AxisDirection.up,
          textFieldConfiguration: TextFieldConfiguration(
            textAlign: TextAlign.center,
            controller: controllerPropertyType,
          ),
          suggestionsCallback: getSuggestionsPropertyTypes,
          itemBuilder: (context, String? suggestion) => ListTile(
            title: Text(suggestion!),
          ),
          onSuggestionSelected: (String? suggestion) => {
            controllerPropertyType.text = suggestion!,
          },
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Please select a property type!';
            } else if (!myFlatProvider.allPropertyType.contains(value)) {
              return 'Please select a existing property type!';
            } else {
              return null;
            }
          },
          onSaved: (value) => filterSettings.propertyType = value,
        );

    Widget buildRoomType() => TypeAheadFormField<String?>(
          direction: AxisDirection.up,
          textFieldConfiguration: TextFieldConfiguration(
            textAlign: TextAlign.center,
            controller: controllerRoomType,
          ),
          suggestionsCallback: getSuggestionsRoomTypes,
          itemBuilder: (context, String? suggestion) => ListTile(
            title: Text(suggestion!),
          ),
          onSuggestionSelected: (String? suggestion) => {
            controllerRoomType.text = suggestion!,
          },
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Please select a property type!';
            } else if (!myFlatProvider.allRoomTypes.contains(value)) {
              return 'Please select a existing room type!';
            } else {
              return null;
            }
          },
          onSaved: (value) => filterSettings.roomType = value,
        );

    Widget buildNeighbourhoodType() => TypeAheadFormField<String?>(
          direction: AxisDirection.up,
          textFieldConfiguration: TextFieldConfiguration(
            textAlign: TextAlign.center,
            controller: controllerNeighbourhood,
          ),
          suggestionsCallback: getSuggestionsNeighbourhood,
          itemBuilder: (context, String? suggestion) => ListTile(
            title: Text(suggestion!),
          ),
          onSuggestionSelected: (String? suggestion) => {
            controllerNeighbourhood.text = suggestion!,
          },
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Please select a property type!';
            } else if (!myFlatProvider.allNeighbourhoodCleansed
                .contains(value)) {
              return 'Please select a existing neighbourhood!';
            } else {
              return null;
            }
          },
          onSaved: (value) => filterSettings.neighbourhood = value,
        );

    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(16),
      child: Form(
        key: formKey,
        child: ListView(
          children: <Widget>[
            (myFlatProvider.predictedPrice == "")
                ? Container(
                    height: 50,
                    alignment: Alignment.center,
                    child: Text(
                      "Price Prediciton",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  )
                : Container(
                    height: 50,
                    alignment: Alignment.center,
                    child: Text(
                      "The predicted price is: " +
                          myFlatProvider.predictedPrice +
                          "€",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: Theme.of(context).primaryColor),
                    ),
                  ),
            Container(
              height: 60,
              child: Row(
                children: [
                  Container(
                    width: 200,
                    child: Text("Accommondates"),
                  ),
                  Expanded(
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      initialValue: 1.toString(),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null) {
                          return null;
                        }
                        final n = num.tryParse(value);
                        if (n == null) {
                          return '"$value" is not a valid number';
                        }
                        return null;
                      },
                      onSaved: (value) =>
                          {filterSettings._accommodates = int.parse(value!)},
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: 60,
              child: Row(
                children: [
                  Container(
                    width: 200,
                    child: Text("Bathrooms"),
                  ),
                  Expanded(
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      initialValue: 1.toString(),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null) {
                          return null;
                        }
                        final n = num.tryParse(value);
                        if (n == null) {
                          return '"$value" is not a valid number';
                        }
                        return null;
                      },
                      onSaved: (value) =>
                          {filterSettings._bathrooms = int.parse(value!)},
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: 60,
              child: Row(
                children: [
                  Container(
                    width: 200,
                    child: Text("Bedrooms"),
                  ),
                  Expanded(
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      initialValue: 1.toString(),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null) {
                          return null;
                        }
                        final n = num.tryParse(value);
                        if (n == null) {
                          return '"$value" is not a valid number';
                        }
                        return null;
                      },
                      onSaved: (value) =>
                          {filterSettings._bedrooms = int.parse(value!)},
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: 60,
              child: Row(
                children: [
                  Container(
                    width: 200,
                    child: Text("Guets Included"),
                  ),
                  Expanded(
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      initialValue: 1.toString(),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null) {
                          return null;
                        }
                        final n = num.tryParse(value);
                        if (n == null) {
                          return '"$value" is not a valid number';
                        }
                        return null;
                      },
                      onSaved: (value) =>
                          {filterSettings._guestIncluded = int.parse(value!)},
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 60,
              child: Row(
                children: [
                  Container(
                    width: 200,
                    child: Text("Property Type"),
                  ),
                  Expanded(
                    child: buildPropertyType(),
                  ),
                ],
              ),
            ),
            Container(
              height: 60,
              child: Row(
                children: [
                  Container(
                    width: 200,
                    child: Text("Room Type"),
                  ),
                  Expanded(
                    child: buildRoomType(),
                  ),
                ],
              ),
            ),
            Container(
              height: 60,
              child: Row(
                children: [
                  Container(
                    width: 200,
                    child: Text("Neighbourhood"),
                  ),
                  Expanded(
                    child: buildNeighbourhoodType(),
                  ),
                ],
              ),
            ),
            Container(
              height: 60,
              child: Row(
                children: [
                  Container(
                    width: 200,
                    child: Text("Air Conditioning"),
                  ),
                  Expanded(
                    child: Checkbox(
                      value: this.filterSettings._checkedAirCondition,
                      onChanged: (value) {
                        setState(() {
                          this.filterSettings._checkedAirCondition = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 60,
              child: Row(
                children: [
                  Container(
                    width: 200,
                    child: Text("Elevator Available?"),
                  ),
                  Expanded(
                    child: Checkbox(
                      value: this.filterSettings._checkedElevator,
                      onChanged: (value) {
                        setState(() {
                          this.filterSettings._checkedElevator = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 60,
              child: Row(
                children: [
                  Container(
                    width: 200,
                    child: Text("Gymnastic Available?"),
                  ),
                  Expanded(
                    child: Checkbox(
                      value: this.filterSettings._checkedGym,
                      onChanged: (value) {
                        setState(() {
                          this.filterSettings._checkedGym = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              child: Text('Save'),
              onPressed: () => {
                if (formKey.currentState!.validate())
                  {
                    formKey.currentState!.save(),
                    _submit(filterSettings, myFlatProvider)
                  }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit(
      FilterSettingsPredictPrice filterSettings, myFlatProvider) async {
    setState(() {
      _isLoading = true;
    });
    await myFlatProvider.predictPrice(filterSettings);
    setState(() {
      _isLoading = false;
    });
  }
}
