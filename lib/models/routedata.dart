import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pedal_istanbul/models/routemarker.dart';
import 'package:pedal_istanbul/respository/directions_respository.dart';

class RouteData {
  final String name;
  bool isFavorite = false;
  final RouteMarker? routeMarker;
  String destinationAddress = "";
  String originAddress = "";
  String totalDistance = "0 km";
  String totalDuration = "0 min";
  int distanceValue = 0;
  int durationValue = 0;
  String caloriesBurned = "0 kcal";
  List<String> photos = [];

  LatLng origin = LatLng(0, 0);
  LatLng destination = LatLng(0, 0);
  List<LatLng> routePos = [];

  RouteData(this.name, this.routeMarker) {
    if (routeMarker != null) {
      origin = routeMarker!.getMarkers.first.position;
      destination = routeMarker!.getMarkers.last.position;
      routePos = routeMarker!.getRoutePos;
      getRouteInfo();
      getStreetViewUrls();
    }
  }

  Future<void> getRouteInfo() async {
    if (routeMarker == null) return;

    try {
      final direction = await DirectionsRepository().getRouteInfo(
        origin: origin,
        destination: destination,
      );

      totalDistance = direction.totalDistance;
      totalDuration = direction.totalDuration;
      distanceValue = direction.distanceValue;
      durationValue = direction.durationValue;

      calculateCalories(); // Kalori hesaplamasını burada yap
    } catch (e) {
      print("Hata: ${e.toString()}");
    }
  }

  void calculateCalories() {
    if (durationValue == 0 || distanceValue == 0) {
      caloriesBurned = "0 kcal";
      return;
    }

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