import 'package:pedal_istanbul/models/routemarker.dart';

class RouteInfo{

  late String name;
  final String totalDistance;
  final String totalDuration;
  final int distanceValue;
  final int durationValue;
  late String caloriesBurned;


  RouteInfo({
    required this.totalDistance,
    required this.totalDuration ,
    required this.distanceValue,
    required this.durationValue,
  }){calculateCalories();}

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


 void calculateCalories() {

    double avgSpeed = (distanceValue / 1000) /  (durationValue / 3600) ;


    double calorieRate;


    switch (avgSpeed ~/ 5) {
      case 0:
      case 1:
      case 2:
        calorieRate = 4;
        break;
      case 3:
        calorieRate = 7;
        break;
      case 4:
        calorieRate = 10;
        break;
      default:
        calorieRate = 14;
    }

    caloriesBurned = "${calorieRate * (durationValue / 60)}";
  }


}