import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pedal_istanbul/models/routemarker.dart';

class AppState with ChangeNotifier{

  bool _isEditing = false;
  RouteMarker? _selectedMarker;

  bool get isEditing => _isEditing;
  RouteMarker? get selectedMarker => _selectedMarker;


  void setEditing(bool editing) {
    _isEditing = editing;
    notifyListeners();
  }

  void setSelectedMarker(RouteMarker? marker) {
    _selectedMarker = marker;
    notifyListeners();
  }


}