import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uber_rider/configs/asset_config.dart';
import 'package:uber_rider/notifiers/pickup_notifier.dart';
import 'package:uber_rider/repositories/map_repository.dart';
import 'package:uber_rider/screens/search_location_screen.dart';
import 'package:uber_rider/widgets/divider_widget.dart';

class HomeScreen extends StatefulWidget {
  static const String route = 'home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Completer<GoogleMapController> _mapControllerCompleter = Completer();
  late GoogleMapController _googleMapController;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Position? _currentPosition;
  final _geolocator = Geolocator();
  var _bottomPadding = 0.0;

  final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      // appBar: AppBar(
      //   title: Text('Uber Rider Mock'),
      // ),
      drawer: _drawer(),
      body: _body(),
    );
  }

  Widget _drawer() {
    return Container(
      color: Colors.white,
      width: 260,
      child: Drawer(
        child: ListView(
          children: [
            // Drawer Header
            SizedBox(
              height: 160,
              child: DrawerHeader(
                child: Row(
                  children: [
                    Image.asset(
                      AssetConfig.imageUserIcon,
                      height: 64,
                      width: 64,
                    ),
                    SizedBox(width: 16),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Profile name',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Bolt Semi Bold',
                          ),
                        ),
                        SizedBox(height: 4),
                        Text('Visit Profile'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12),

            // Drawer Body
            ListTile(
              leading: Icon(Icons.history),
              title: Text(
                'History',
                style: TextStyle(fontSize: 16),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text(
                'Visit Profile',
                style: TextStyle(fontSize: 16),
              ),
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text(
                'About',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _body() {
    return SafeArea(
      child: Stack(
        children: [
          // Google map
          GoogleMap(
            padding: EdgeInsets.only(bottom: _bottomPadding),
            initialCameraPosition: _kGooglePlex,
            mapType: MapType.normal,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            compassEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              _mapControllerCompleter.complete(controller);
              _googleMapController = controller;
              _locatePosition();

              setState(() {
                _bottomPadding = 320;
              });
            },
          ),

          // HamburgerButton for drawer
          Positioned(
            top: 45,
            left: 22,
            child: GestureDetector(
              onTap: () {
                _scaffoldKey.currentState?.openDrawer();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 4,
                      spreadRadius: 0.5,
                      offset: Offset(0.7, 0.73),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.menu,
                    color: Colors.black,
                  ),
                  radius: 20,
                ),
              ),
            ),
          ),

          // Menu
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 300,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 16,
                    spreadRadius: 0.5,
                    offset: Offset(0.7, 0.7),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Greetings
                    Text(
                      'Hi there, ',
                      style: TextStyle(fontSize: 12),
                    ),
                    Text(
                      'Where to?',
                      style:
                          TextStyle(fontSize: 20, fontFamily: 'Bolt Semi Bold'),
                    ),
                    SizedBox(height: 20),

                    // Search drop off
                    GestureDetector(
                      onTap: () {
                        print('object');
                        Navigator.pushNamed(
                            context, SearchLocationScreen.route);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black54,
                              blurRadius: 6,
                              spreadRadius: 0.5,
                              offset: Offset(0.7, 0.7),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.search,
                                color: Colors.blueAccent,
                              ),
                              SizedBox(width: 10),
                              Text('Search drop off'),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24),

                    // Add Home
                    Row(
                      children: [
                        Icon(
                          Icons.home,
                          color: Colors.grey,
                        ),
                        SizedBox(width: 12),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                Provider.of<PickupNotifier>(context)
                                            .pickupLocation !=
                                        null
                                    ? Provider.of<PickupNotifier>(context)
                                        .pickupLocation!
                                        .formattedAddress!
                                    : 'Name',
                                maxLines: 2,
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Your home address',
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 12,
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 8),

                    // Divider
                    DividerWidget(),
                    SizedBox(height: 16),

                    // Add Work
                    Row(
                      children: [
                        Icon(
                          Icons.work,
                          color: Colors.grey,
                        ),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Add Work'),
                            SizedBox(height: 4),
                            Text(
                              'Your work address',
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 12,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _locatePosition() async {
    await Geolocator.requestPermission();

    _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    final latLngPosition =
        LatLng(_currentPosition!.latitude, _currentPosition!.longitude);

    final cameraPosition = CameraPosition(target: latLngPosition, zoom: 14);
    _googleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String address =
        await MapRepository.searchCoordinateAddress(context, _currentPosition!);

    print(address);
  }
}
