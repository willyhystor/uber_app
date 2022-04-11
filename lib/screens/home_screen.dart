import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uber_rider/configs/asset_config.dart';
import 'package:uber_rider/models/address_model.dart';
import 'package:uber_rider/notifiers/location_notifier.dart';
import 'package:uber_rider/repositories/map_repository.dart';
import 'package:uber_rider/screens/search_location_screen.dart';
import 'package:uber_rider/widgets/divider_widget.dart';
import 'package:uber_rider/widgets/loading_dialog.dart';

class HomeScreen extends StatefulWidget {
  static const String route = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  MapRepository mapRepository = MapRepository();

  final Completer<GoogleMapController> _mapControllerCompleter = Completer();
  late GoogleMapController _googleMapController;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Position? _currentPosition;
  // final _geolocator = Geolocator();
  var _bottomPadding = 0.0;

  final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  Set<Circle> circles = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  @override
  void initState() {
    super.initState();

    // /// origin marker
    // _addMarker(LatLng(_originLatitude, _originLongitude), "origin",
    //     BitmapDescriptor.defaultMarker);

    // /// destination marker
    // _addMarker(LatLng(_destLatitude, _destLongitude), "destination",
    //     BitmapDescriptor.defaultMarkerWithHue(90));
    // _getPolyline();
  }

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
            markers: markers,
            polylines: polylines,
            circles: circles,
            onMapCreated: _onMapCreated,
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
                      onTap: () => _getDropoffLocation(context),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black54,
                              blurRadius: 2,
                              spreadRadius: 0.5,
                              offset: Offset(1, 0.5),
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
                                Provider.of<LocationNotifier>(context)
                                            .pickupLocation !=
                                        null
                                    ? Provider.of<LocationNotifier>(context)
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
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                Provider.of<LocationNotifier>(context)
                                            .dropoffLocation !=
                                        null
                                    ? Provider.of<LocationNotifier>(context)
                                        .dropoffLocation!
                                        .formattedAddress!
                                    : 'Add Work',
                                maxLines: 2,
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Your work address',
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
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) async {
    _mapControllerCompleter.complete(controller);
    _googleMapController = controller;
    _locatePosition();

    setState(() {
      _bottomPadding = 320;
    });
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

    await mapRepository.searchCoordinateAddress(context, _currentPosition!);
  }

  void _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    final marker = Marker(
      markerId: MarkerId(id),
      icon: descriptor,
      position: position,
      infoWindow: InfoWindow(title: 'test', snippet: 'snippet test'),
    );
    markers.add(marker);
  }

  void _addCircle(LatLng position, Color color, String id) {
    final circle = Circle(
      circleId: CircleId(id),
      fillColor: color,
      strokeColor: color,
      radius: 12,
      strokeWidth: 4,
    );

    setState(() {
      circles.add(circle);
    });
  }

  void _addPolyline() {
    final polyline = Polyline(
      polylineId: PolylineId("poly"),
      color: Colors.blue,
      jointType: JointType.round,
      width: 4,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      geodesic: true,
      points: polylineCoordinates,
    );

    setState(() {
      polylines.add(polyline);
    });
  }

  void _animateCamera(
      AddressModel pickupLocation, AddressModel dropoffLocation) {
    LatLngBounds latLngBounds;
    if (pickupLocation.latitude! > dropoffLocation.latitude! &&
        pickupLocation.longitude! > dropoffLocation.longitude!) {
      latLngBounds = LatLngBounds(
          southwest: dropoffLocation.latLng!,
          northeast: pickupLocation.latLng!);
    } else if (pickupLocation.latitude! > dropoffLocation.latitude!) {
      latLngBounds = LatLngBounds(
          southwest:
              LatLng(dropoffLocation.latitude!, pickupLocation.longitude!),
          northeast:
              LatLng(pickupLocation.latitude!, dropoffLocation.longitude!));
    } else if (pickupLocation.longitude! > dropoffLocation.longitude!) {
      latLngBounds = LatLngBounds(
          southwest:
              LatLng(pickupLocation.latitude!, dropoffLocation.longitude!),
          northeast:
              LatLng(dropoffLocation.latitude!, pickupLocation.longitude!));
    } else {
      latLngBounds = LatLngBounds(
          southwest: pickupLocation.latLng!,
          northeast: dropoffLocation.latLng!);
    }

    _googleMapController
        .animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 72));
  }

  void _getDropoffLocation(context) async {
    await Navigator.pushNamed(context, SearchLocationScreen.route);

    final dropoffLocation =
        Provider.of<LocationNotifier>(context, listen: false).dropoffLocation;

    if (dropoffLocation?.formattedAddress != null) {
      showDialog(
        context: context,
        builder: (context) => LoadingDialog(msg: 'Please wait...'),
      );

      final pickupLocation =
          Provider.of<LocationNotifier>(context, listen: false).pickupLocation;

      final direction = await mapRepository.getDirectionDetail(
          pickupLocation!.latLng!, dropoffLocation!.latLng!);

      Navigator.pop(context);

      List<PointLatLng> decodedPolylinePointsResult =
          polylinePoints.decodePolyline(direction.encodedPoints!);

      polylineCoordinates.clear();
      if (decodedPolylinePointsResult.isNotEmpty) {
        for (var e in decodedPolylinePointsResult) {
          polylineCoordinates.add(LatLng(e.latitude, e.longitude));
        }
      }

      // Set marker
      markers.clear();
      // _addMarker(
      //   LatLng(pickupLocation.latitude!, pickupLocation.longitude!),
      //   "origin",
      //   BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      // );

      _addMarker(
        LatLng(dropoffLocation.latitude!, dropoffLocation.longitude!),
        "destination",
        BitmapDescriptor.defaultMarker,
      );

      // Set polyline or path
      _addPolyline();

      // Animate Camera to zoom out
      _animateCamera(pickupLocation, dropoffLocation);

      // Add circle poisition
      circles.clear;
      _addCircle(pickupLocation.latLng!, Colors.blueAccent, 'pickupId');
      _addCircle(dropoffLocation.latLng!, Colors.deepPurple, 'dropoffId');
    }
  }
}
