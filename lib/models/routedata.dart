import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pedal_istanbul/respository/directions_respository.dart';

class RouteData {
  final int id;
  final String name;
  final LatLng origin;
  final LatLng destination;
  String totalDistance = "0 km";
  String totalDuration = "0 min";
  int distanceValue = 0;
  int durationValue = 0;
  String caloriesBurned = "0";
  final Set<Marker> routePoints;
  List<String> photos = [];

  RouteData(
      this.id,
      this.name,
      this.origin,
      this.destination,
      this.routePoints,
      ){getRouteInfo();getStreetViewUrls();}

  Future<void> getRouteInfo() async {
    try {
      final routeInfo = await DirectionsRepository().getRouteInfo(
        origin: origin,
        destination: destination,
      );

      totalDistance = routeInfo.totalDistance;
      totalDuration = routeInfo.totalDuration;
      distanceValue = routeInfo.distanceValue;
      durationValue = routeInfo.durationValue;
    } catch (e) {
      print("Hata: ${e.toString()}");
    }
  }

  void calculateCalories() {
    if (durationValue == 0) return; // Bölme hatasını önlemek için

    double avgSpeed = (distanceValue / 1000) / (durationValue / 3600);
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

    caloriesBurned = "${(calorieRate * (durationValue / 60)).toStringAsFixed(2)} kcal";
  }


  void getStreetViewUrls() {
    photos = routePoints.map((e) {
      return "https://maps.googleapis.com/maps/api/streetview?size=600x300&location=${e.position.latitude},${e.position.longitude}&key=${dotenv.env['GOOGLE_API_KEY']}";
    }).toList();
  }
}
