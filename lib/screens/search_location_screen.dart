import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uber_rider/configs/asset_config.dart';
import 'package:uber_rider/models/place_prediction_model.dart';
import 'package:uber_rider/notifiers/location_notifier.dart';
import 'package:uber_rider/repositories/map_repository.dart';
import 'package:uber_rider/widgets/divider_widget.dart';
import 'package:uber_rider/widgets/prediction_tile_widget.dart';

class SearchLocationScreen extends StatefulWidget {
  static const String route = 'search-location';
  @override
  State<SearchLocationScreen> createState() => _SearchLocationScreenState();
}

class _SearchLocationScreenState extends State<SearchLocationScreen> {
  MapRepository mapRepository = MapRepository();

  final _pickupController = TextEditingController();
  final _dropoffController = TextEditingController();

  var _placePredictions = <PlacePredictionModel>[];

  @override
  void didChangeDependencies() {
    _pickupController.text =
        Provider.of<LocationNotifier>(context).pickupLocation?.name ?? "";

    _dropoffController.text =
        Provider.of<LocationNotifier>(context).dropoffLocation?.name ?? "";

    if (_dropoffController.text != "") {
      findPlace(_dropoffController.text);
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            // Input field container
            Container(
              height: 220,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 6,
                    spreadRadius: 0.5,
                    offset: Offset(0.7, 0.7),
                  )
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                child: Column(
                  children: [
                    // Drop Off
                    SizedBox(height: 4),
                    Stack(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Icon(Icons.arrow_back),
                        ),
                        Center(
                          child: Text(
                            'Set Drop Off',
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: "Bolt Semi Bold",
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                    // Pickup Location
                    Row(
                      children: [
                        // Icon
                        Image.asset(
                          AssetConfig.imagePickIcon,
                          height: 20,
                          width: 20,
                        ),
                        SizedBox(width: 16),

                        // Pickup Input
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(4),
                              child: TextField(
                                controller: _pickupController,
                                enabled: false,
                                decoration: InputDecoration(
                                  hintText: 'Pick Up Location',
                                  fillColor: Colors.grey[200],
                                  filled: true,
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.only(
                                    left: 12,
                                    top: 8,
                                    bottom: 8,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                    // Dropoff Location
                    Row(
                      children: [
                        // Icon
                        Image.asset(
                          AssetConfig.imageDestIcon,
                          height: 20,
                          width: 20,
                        ),
                        SizedBox(width: 16),

                        // Dropoff Input
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(4),
                              child: TextField(
                                controller: _dropoffController,
                                onChanged: (String value) => findPlace(value),
                                decoration: InputDecoration(
                                  hintText: 'Where to?',
                                  fillColor: Colors.grey[200],
                                  filled: true,
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.only(
                                    left: 12,
                                    top: 8,
                                    bottom: 8,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // Generate place predictions
            (_placePredictions.isNotEmpty)
                ? Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    child: ListView.separated(
                      itemCount: _placePredictions.length,
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemBuilder: (context, index) =>
                          PredictionTileWidget(_placePredictions[index]),
                      separatorBuilder: (context, index) => DividerWidget(),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  void findPlace(String place) async {
    if (place.isNotEmpty) {
      final predictions =
          await mapRepository.autocompletePlaceName(context, place);

      // prevent setState after dispose
      if (!mounted) {
        return;
      }

      setState(() {
        _placePredictions = predictions;
      });
    }
  }
}
