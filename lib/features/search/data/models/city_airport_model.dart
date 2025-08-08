class CityAirportModel {
  final String cityName;
  final String cityCode;
  final String airportName;

  CityAirportModel({
    required this.cityName,
    required this.cityCode,
    required this.airportName,
  });

  factory CityAirportModel.fromJson(Map<String, dynamic> json) {
    return CityAirportModel(
      cityName: json['cityName'] ?? '',
      cityCode: json['cityCode'] ?? '',
      airportName: json['airportName'] ?? '',
    );
  }
}
