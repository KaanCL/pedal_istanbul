import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pedal_istanbul/models/routemarker.dart';
import 'package:pedal_istanbul/respository/routes_respository.dart';

import '../models/routedata.dart';

class AppState with ChangeNotifier{

  int _currentPageIndex = 0;
  bool _isEditing = false;
  RouteData? _selectedMarker;
  List<RouteData> routes = [];

  Set<Marker> _markers = {};


  Set<Marker> get markers => _markers;

  bool get isEditing => _isEditing;
  RouteData? get selectedMarker => _selectedMarker;
  int get currentPageIndex => _currentPageIndex;

  void setEditing(bool editing) {
    _isEditing = editing;
    notifyListeners();
  }

  void setSelectedMarker(RouteData? route) {
    _selectedMarker = route;
    notifyListeners();
  }

  void setCurrentPageIndex(int pageIndex) {
    _currentPageIndex = pageIndex;
    notifyListeners();
  }

  void setMarkers(Set<Marker> markers){
    _markers = markers;
    notifyListeners();
  }

  Future<void> fetchRoutes() async{
    try{
      List<RouteData> fetchedRoutes = await RoutesRespository().getRoutes();

      routes = fetchedRoutes;


      _markers.clear();

      for(var route in routes){
        print(route.routeMarker.position);
        _markers.add(route.routeMarker);
      }
      notifyListeners();
    }catch(e){
      print("Hata: $e");

    }


  }







}