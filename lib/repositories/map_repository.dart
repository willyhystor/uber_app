import 'package:geolocator/geolocator.dart';
import 'package:uber_rider/remotes/map_remote.dart';

class MapRepository {
  static Future<String> searchCoordinateAddress(
      context, Position position) async {
    MapRemote mapRemote = MapRemote();

    return mapRemote.searchCoordinateAddress(context, position);
  }
}
