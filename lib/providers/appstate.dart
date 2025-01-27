import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pedal_istanbul/models/routemarker.dart';

class AppState with ChangeNotifier{

  int _currentPageIndex = 0;
  bool _isEditing = false;
  RouteMarker? _selectedMarker;

  bool get isEditing => _isEditing;
  RouteMarker? get selectedMarker => _selectedMarker;
  int get currentPageIndex => _currentPageIndex;

  void setEditing(bool editing) {
    _isEditing = editing;
    notifyListeners();
  }

  void setSelectedMarker(RouteMarker? marker) {
    _selectedMarker = marker;
    notifyListeners();
  }

  void setCurrentPageIndex (int pageIndex){
    _currentPageIndex = pageIndex;
    notifyListeners();
  }


}