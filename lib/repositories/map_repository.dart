import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uber_rider/models/direction_model.dart';
import 'package:uber_rider/models/place_prediction_model.dart';
import 'package:uber_rider/notifiers/location_notifier.dart';
import 'package:uber_rider/remotes/map_remote.dart';

class MapRepository {
  final mapRemote = MapRemote();

  Future<void> searchCoordinateAddress(context, Position position) async {
    final address = await mapRemote.searchCoordinateAddress(context, position);

    Provider.of<LocationNotifier>(context, listen: false)
        .updatePickupLocation(address);
  }

  Future<List<PlacePredictionModel>> autocompletePlaceName(
      context, String place) async {
    return mapRemote.autocompletePlaceName(context, place);
  }

  Future<void> getPlaceDetailById(context, String id) async {
    final address = await mapRemote.getPlaceDetailById(id);

    Provider.of<LocationNotifier>(context, listen: false)
        .updateDropoffLocation(address);
  }

  Future<DirectionModel> getDirectionDetail(
      LatLng origin, LatLng destination) async {
    return mapRemote.getDirectionDetail(origin, destination);
  }
}
