import 'package:pedal_istanbul/models/routemarker.dart';

class RouteInfo{

  final String totalDistance;
  final String totalDuration;
  final int distanceValue;
  final int durationValue;
  late List<String> photos;


  RouteInfo({
    required this.totalDistance,
    required this.totalDuration ,
    required this.distanceValue,
    required this.durationValue,
  });

  factory RouteInfo.fromMap(Map<String, dynamic> map){

    if ((map['routes'] as List).isEmpty)return throw Exception("No routes found");

    final data = Map<String,dynamic>.from(map['routes'][0]);

    String distance = '';
    String duration = '';
    int durationValue = 0;
    int distanceValue = 0;

    if ((data['legs'] as List).isNotEmpty) {
      final leg = data['legs'][0];
      distance = leg['distance']['text'];
      duration = leg['duration']['text'];
      distanceValue =leg['distance']['value'];
      durationValue = leg['duration']['value'];
    }

    return RouteInfo(
        totalDistance:distance,
        totalDuration:duration ,
        distanceValue: distanceValue,
        durationValue: durationValue);
  }






}