import 'package:flutter/material.dart';
import 'package:uber_rider/models/place_prediction_model.dart';
import 'package:uber_rider/repositories/map_repository.dart';
import 'package:uber_rider/screens/home_screen.dart';
import 'package:uber_rider/widgets/loading_dialog.dart';

class PredictionTileWidget extends StatelessWidget {
  final PlacePredictionModel placePrediction;

  PredictionTileWidget(this.placePrediction);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => _getPlaceDetailsById(context, placePrediction.id!),
      child: Row(
        children: [
          Icon(Icons.add_location),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8),
                Text(
                  placePrediction.mainText!,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  placePrediction.secondaryText!,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _getPlaceDetailsById(context, String id) async {
    showDialog(
      context: context,
      builder: (context) =>
          LoadingDialog(msg: 'Finding your drop off location, please wait...'),
    );

    MapRepository mapRepository = MapRepository();

    await mapRepository.getPlaceDetailById(context, id);

    Navigator.popUntil(context, ModalRoute.withName(HomeScreen.route));
  }
}
