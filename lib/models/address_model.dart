import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddressModel {
  String? formattedAddress;
  String? name;
  String? id;
  double? latitude;
  double? longitude;
  LatLng? latLng;

  AddressModel({
    this.formattedAddress,
    this.name,
    this.id,
    this.latitude,
    this.longitude,
    this.latLng,
  });
}
