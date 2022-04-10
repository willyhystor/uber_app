import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:uber_rider/configs/map_config.dart';
import 'package:uber_rider/models/address_model.dart';
import 'package:uber_rider/notifiers/pickup_notifier.dart';
import 'package:uber_rider/remotes/remote.dart';

class MapRemote {
  Future<String> searchCoordinateAddress(context, Position position) async {
    Remote remote = Remote();

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
      address.formattedAddress = response['results'][0]['formatted_address'];
      address.name = response['results'][0]['address_components'][3]
              ['long_name'] +
          ', ' +
          response['results'][0]['address_components'][4]['long_name'] +
          ', ' +
          response['results'][0]['address_components'][5]['long_name'] +
          ', ' +
          response['results'][0]['address_components'][6]['long_name'];

      Provider.of<PickupNotifier>(context, listen: false)
          .updatePickupLocation(address);

      return response['results'][0]['formatted_address'];
    }

    return response;
  }
}
