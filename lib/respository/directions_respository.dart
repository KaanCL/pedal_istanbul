import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pedal_istanbul/models/routeinfo.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class  DirectionsRepository{

  static const String _baseUrl =  'https://maps.googleapis.com/maps/api/directions/json?';

  final Dio _dio;

  DirectionsRepository({Dio? dio}) : _dio = dio ?? Dio();

  Future<RouteInfo> getRouteInfo({
    required LatLng origin,
    required LatLng destination,})async{

    final response = await _dio.get(_baseUrl,queryParameters:{
      'origin':'${origin.latitude},${origin.longitude}',
      'destination':'${destination.latitude},${destination.longitude}',
      'key':'${dotenv.env['GOOGLE_API_KEY']}'
    });

    if (response.statusCode == 200){
         return RouteInfo.fromMap(response.data);
    }
    throw  Exception('Failed to fetch directions');

}

}