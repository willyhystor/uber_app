import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uber_rider/configs/asset_config.dart';
import 'package:uber_rider/notifiers/pickup_notifier.dart';

class SearchLocationScreen extends StatefulWidget {
  static const String route = 'search-location';
  @override
  State<SearchLocationScreen> createState() => _SearchLocationScreenState();
}

class _SearchLocationScreenState extends State<SearchLocationScreen> {
  final _pickupController = TextEditingController();
  final _dropoffController = TextEditingController();

  String _placeAddress = '';

  @override
  void didChangeDependencies() {
    _placeAddress =
        Provider.of<PickupNotifier>(context).pickupLocation?.name ?? "";
    _pickupController.text = _placeAddress;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
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
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(4),
                              child: TextField(
                                controller: _pickupController,
                                decoration: InputDecoration(
                                  hintText: 'Pick Up Location',
                                  fillColor: Colors.grey[400],
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
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(4),
                              child: TextField(
                                controller: _dropoffController,
                                decoration: InputDecoration(
                                  hintText: 'Where to?',
                                  fillColor: Colors.grey[400],
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
          ],
        ),
      ),
    );
  }
}
