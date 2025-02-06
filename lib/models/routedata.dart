
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pedal_istanbul/models/routemarker.dart';
import 'package:pedal_istanbul/respository/directions_respository.dart';

class RouteData {
  final String name;
  bool isFavorite = false;
 RouteMarker routeMarker;
  final bool isDirectionDataFetched;
  String startAddress = "";
  String endAddress = "";
  String totalDistance = "0 km";
  String totalDuration = "0 min";
  int distanceValue = 0;
  double durationValue = 0;
  String caloriesBurned = "0 kcal";
  List<String> photos = [];
  List<LatLng> routePos = [];



  RouteData({
    required this.name,
    required this.routeMarker,
    required this.isDirectionDataFetched,
    this.isFavorite = false,
    this.startAddress = "",
    this.endAddress = "",
    this.totalDistance = "0 km",
    this.totalDuration = "0 min",
    this.distanceValue = 0,
    this.durationValue = 0.0,
    this.caloriesBurned = "0 kcal",
    this.photos = const [],
  }) {
    routePos = routeMarker.getRoutePos;
    initialize();

  }



  Future<void> initialize() async{
    if (!isDirectionDataFetched) {
      getStreetViewUrls();
      await getRouteInfo();
    }
}

  Future<Map<String, dynamic>> toJsonAsync() async {
    await initialize() ;
    return toJson();
  }


  factory RouteData.fromJson(Map<String,dynamic> json){
    RouteData? routeData = null;
    RouteMarker routeMarker = RouteMarker.fromJson(json['routeMarker']);

    routeData = RouteData(
      name: json['name'],
      routeMarker: routeMarker,
      isDirectionDataFetched: true,
      isFavorite: json['isFavorite'] ?? false,
      startAddress: json['startAddress'] ?? "",
      endAddress: json['endAddress'] ?? "",
      totalDistance: json['totalDistance'] ?? "0 km",
      totalDuration: json['totalDuration'] ?? "0 min",
      distanceValue: json['distanceValue'] ?? 0,
      durationValue: json['durationValue']?.toDouble() ?? 0.0,
      caloriesBurned: json['calorie'] ?? "0 kcal",
      photos: List<String>.from(json['photos'] ?? []),

    );


    return routeData;

  }

  Map<String,dynamic> toJson() {
    return {
      'name': name,
      'routeMarker': routeMarker.toJson(),
      'isFavorite': isFavorite,
      'startAddress': startAddress,
      'endAddress': endAddress,
      'totalDistance': totalDistance,
      'totalDuration': totalDuration,
      'distanceValue': distanceValue,
      'durationValue': durationValue,
      'calorie': caloriesBurned,
      'photos': photos,
    };
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