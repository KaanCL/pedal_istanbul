
import 'package:dio/dio.dart';
import 'package:pedal_istanbul/models/routedata.dart';

class RoutesRespository{

  static const String _baseUrl = 'http://192.168.1.143:5000/';

  final Dio _dio;

  RoutesRespository({Dio? dio}) : _dio = dio ?? Dio();

  Future<List<RouteData>> getRoutes() async{

    final response = await _dio.get(_baseUrl +"route");

    if(response.statusCode == 200){
      List<dynamic> jsonResponse = response.data;
      print(jsonResponse);
      return jsonResponse.map((route)=>RouteData.fromJson(route)).toList();
    }
    throw  Exception('Failed to fetch routes');
  }


  Future<void> postRoutes(Map<String,dynamic> routeData) async {
    final response = await _dio.post(_baseUrl + "route/", data: routeData);

    if (response.statusCode == 201) {
      print('Route created: ${response.data}');
    } else {
      throw Exception('Failed to post routes');
    }
  }

}