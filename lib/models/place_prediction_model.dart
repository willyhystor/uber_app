class PlacePredictionModel {
  String? id;
  String? mainText;
  String? secondaryText;

  PlacePredictionModel(this.id, this.mainText, this.secondaryText);

  PlacePredictionModel.fromJson(Map<dynamic, dynamic> json) {
    id = json['place_id'];
    mainText = json['structured_formatting']['main_text'];
    secondaryText = json['structured_formatting']['secondary_text'];
  }
}
