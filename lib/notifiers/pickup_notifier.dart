import 'package:flutter/material.dart';
import 'package:uber_rider/models/address_model.dart';

class PickupNotifier extends ChangeNotifier {
  AddressModel? pickupLocation;

  void updatePickupLocation(AddressModel pickupAddress) {
    pickupLocation = pickupAddress;

    notifyListeners();
  }
}
