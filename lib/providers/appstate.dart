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

  CameraPosition _cameraPosition = CameraPosition(target: LatLng(41.0082, 28.9784), zoom: 12);


  CameraPosition get cameraPosition => _cameraPosition;

 void setCameraPosition(LatLng value) {
    _cameraPosition = CameraPosition(target: value,zoom:14);
    notifyListeners();
  }

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
        route.routeMarker = RouteMarker(
          markers: route.routeMarker.getMarkers,
          polylines: route.routeMarker.getPolylines,
          routePos: route.routeMarker.getRoutePos,
          position: route.routeMarker.position,
          icon: route.routeMarker.icon,
          infoWindow: route.routeMarker.infoWindow,
          onTapCallBack: () {setSelectedMarker(route);},
        );
        print(route.routeMarker.position);
        _markers.add(route.routeMarker);
      }
      notifyListeners();
    }catch(e){
      print("Hata: $e");

    }
  }

  Future<void> postRoutes(Map<String,dynamic> routeData)async{

    print(routeData);

    try{
      await RoutesRespository().postRoutes(routeData);
      notifyListeners();
    }catch(e){
      print("Hata: $e");
    }

  }

  Future<void> updateFavoriteRoute(Map<String,dynamic> routeData) async{

    try{
      await RoutesRespository().updateFavoriteRoute(routeData);
      notifyListeners();
    }catch(e){
      print("Hata: $e");

    }

  }

  }