import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_rider/configs/map_config.dart';
import 'package:uber_rider/models/address_model.dart';
import 'package:uber_rider/models/direction_model.dart';
import 'package:uber_rider/models/place_prediction_model.dart';
import 'package:uber_rider/remotes/remote.dart';

class MapRemote {
  final remote = Remote();

  Future<AddressModel> searchCoordinateAddress(
      context, Position position) async {
    String url = 'maps.googleapis.com';

    String path = '/maps/api/geocode/json';

    final param = {
      'latlng': '${position.latitude},${position.longitude}',
      'key': MapConfig.key,
    };

    var response =
        await remote.getRequestHttps(url: url, path: path, parameter: param);

    if (response != "") {
      AddressModel address = AddressModel();
      address.latitude = position.latitude;
      address.longitude = position.longitude;
      address.latLng = LatLng(position.latitude, position.longitude);
      address.formattedAddress = response['results'][0]['formatted_address'];
      address.name = response['results'][0]['address_components'][3]
              ['long_name'] +
          ', ' +
          response['results'][0]['address_components'][4]['long_name'] +
          ', ' +
          response['results'][0]['address_components'][5]['long_name'] +
          ', ' +
          response['results'][0]['address_components'][6]['long_name'];

      return address;
    }

    return AddressModel();
  }

  Future<List<PlacePredictionModel>> autocompletePlaceName(
      context, String place) async {
    String url = 'maps.googleapis.com';

    String path = '/maps/api/place/autocomplete/json';

    final param = {
      'input': place,
      // 'location': '${position.latitude},${position.longitude}',
      // 'radius': 500.toString(),
      // 'strictbounds': true.toString(),
      'types': 'geocode',
      'key': MapConfig.key,
      'components': 'country:us',
    };

    var response =
        await remote.getRequestHttps(url: url, path: path, parameter: param);

    return (response['predictions'] as List)
        .map((e) => PlacePredictionModel.fromJson(e))
        .toList();
  }

  Future<AddressModel> getPlaceDetailById(String id) async {
    String url = 'maps.googleapis.com';

    String path = '/maps/api/place/details/json';

    final param = {
      'place_id': id,
      'key': MapConfig.key,
    };

    var response =
        await remote.getRequestHttps(url: url, path: path, parameter: param);

    if (response['result'] != null) {
      final address = AddressModel(
        id: id,
        formattedAddress: response['result']['formatted_address'],
        name: response['result']['name'],
        latitude: response['result']['geometry']['location']['lat'],
        longitude: response['result']['geometry']['location']['lng'],
        latLng: LatLng(response['result']['geometry']['location']['lat'],
            response['result']['geometry']['location']['lng']),
      );

      return address;
    }

    return AddressModel();
  }

  Future<DirectionModel> getDirectionDetail(
      LatLng origin, LatLng destination) async {
    String url = 'maps.googleapis.com';

    String path = '/maps/api/directions/json';

    final param = {
      'origin': '${origin.latitude},${origin.longitude}',
      'destination': '${destination.latitude},${destination.longitude}',
      'key': MapConfig.key,
    };

    var response =
        await remote.getRequestHttps(url: url, path: path, parameter: param);

    if (response['routes'] != null) {
      return DirectionModel(
        encodedPoints: response['routes'][0]['overview_polyline']['points'],
        distanceText: response['routes'][0]['legs'][0]['distance']['text'],
        distanceValue: response['routes'][0]['legs'][0]['distance']['value'],
        durationText: response['routes'][0]['legs'][0]['duration']['text'],
        durationValue: response['routes'][0]['legs'][0]['duration']['value'],
      );
    }

    return DirectionModel();
  }
}
