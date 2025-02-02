
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pedal_istanbul/models/routemarker.dart';
import 'package:pedal_istanbul/respository/directions_respository.dart';

class RouteData {
  final String name;
  bool isFavorite = false;
  final RouteMarker routeMarker;
  String startAddress = "";
  String endAddress = "";
  String totalDistance = "0 km";
  String totalDuration = "0 min";
  int distanceValue = 0;
  double durationValue = 0;
  String caloriesBurned = "0 kcal";
  List<String> photos = [];

  List<LatLng> routePos = [];

  RouteData(this.name, this.routeMarker) {
      routePos = routeMarker!.getRoutePos;
      getRouteInfo();
      getStreetViewUrls();
  }


  Future<void> getRouteInfo() async {

    LatLng origin = routeMarker.getMarkers.first.position;
    LatLng destination = routeMarker.getMarkers.last.position;
    if (routeMarker == null) return;

    try {
      final direction = await DirectionsRepository().getDirection(
        origin:origin,
        destination: destination,
      );

      startAddress = direction.startAddress;
      endAddress = direction.endAddress;
      totalDistance = direction.totalDistance;
      distanceValue = direction.distanceValue;
      durationValue = (direction.durationValue / 3);
      totalDuration = "${(durationValue / 120).toInt()} mins";


      calculateCalories();
    } catch (e) {
      print("Hata: ${e.toString()}");
    }
  }

  void calculateCalories() {
    if (durationValue == 0 || distanceValue == 0) {
      caloriesBurned = "0 kcal";
      return;
    }
    double distanceInKm = distanceValue / 1000;
    double avgSpeed = (distanceInKm) / (durationValue / 3600);
    double caloriesPerHour;

    if (avgSpeed < 15) {
      caloriesPerHour = 280;
    } else if (avgSpeed < 20) {
      caloriesPerHour = 400;
    } else if (avgSpeed < 25) {
      caloriesPerHour = 600;
    } else {
      caloriesPerHour = 800;
    }

    double calories = (caloriesPerHour / 60) * (durationValue / 60);

    caloriesBurned = "${calories.toStringAsFixed(1)} kcal";
  }

  void getStreetViewUrls() {
    if (routePos.isEmpty) {
      photos = [];
      return;
    }
    photos = routePos.map((e) {
      return "https://maps.googleapis.com/maps/api/streetview?size=600x300&location=${e.latitude},${e.longitude}&key=${dotenv.env['GOOGLE_API_KEY']}";
    }).toList();
  }

  String getTotalValues() {
    return "$totalDistance • $totalDuration • $caloriesBurned";
  }

  RouteMarker? getRouteMarker() {
    return routeMarker;
  }

  Set<Marker> get getMarkers {
    return routeMarker?.getMarkers ?? {};
  }

  Set<Polyline> get getPolylines {
    return routeMarker?.getPolylines ?? {};
  }
}