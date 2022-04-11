import 'package:flutter/material.dart';
import 'package:uber_rider/models/address_model.dart';

class LocationNotifier extends ChangeNotifier {
  AddressModel? pickupLocation;
  AddressModel? dropoffLocation;

  void updatePickupLocation(AddressModel pickupAddress) {
    pickupLocation = pickupAddress;

    notifyListeners();
  }

  void updateDropoffLocation(AddressModel dropoffAddress) {
    dropoffLocation = dropoffAddress;

    notifyListeners();
  }
}
