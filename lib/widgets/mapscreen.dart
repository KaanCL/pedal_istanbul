import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pedal_istanbul/models/routedata.dart';
import 'package:pedal_istanbul/models/routemarker.dart';
import 'package:pedal_istanbul/providers/appstate.dart';
import 'package:pedal_istanbul/respository/directions_respository.dart';
import 'package:pedal_istanbul/views/routes.dart';
import 'package:pedal_istanbul/widgets/bottombar.dart';
import 'package:pedal_istanbul/widgets/bottomdragwidget.dart';
import 'package:pedal_istanbul/widgets/menubutton.dart';
import 'package:pedal_istanbul/widgets/rightmenu.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapController;
  String? _mapStyle;
  final List<LatLng> _routePoints = [];
  final Set<Polyline> _polylines = {};
  final Set<Marker> _tempMarkers = {};


  late AppState appState;
  bool _appStateIsInitialized = false;

  int _polyLineIdCounter = 0;
  int _markerIdCounter = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_appStateIsInitialized) {
      appState = Provider.of<AppState>(context, listen: false);
      if (appState.markers.length == 0) {
        appState.setEditing(true);
      }
      _appStateIsInitialized = true;
    }
  }

  @override
  void initState() {
    super.initState();
    _loadMapStyle();
  }


  @override
  void dispose() {
    _mapController.dispose();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      appState.setSelectedMarker(null);
    });

    super.dispose();
  }

  @override
  Future<void> _loadMapStyle() async {
    String style = await rootBundle.loadString('assets/mapstyle/mapstyle.json');
    if (!mounted) return;
    setState(() {
      _mapStyle = style;
    });
  }


  final LatLngBounds istanbulBounds = LatLngBounds(
    southwest: LatLng(40.8024, 28.5245),
    northeast: LatLng(41.3201, 29.4305),
  );

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(target: LatLng(41.0082, 28.9784), zoom: 12),
          polylines: appState.isEditing ? _polylines : (appState.selectedMarker?.getPolylines ?? {}),
          markers: appState.isEditing ? _tempMarkers : (appState.selectedMarker == null ? appState.markers : (appState.selectedMarker?.getMarkers ?? {})),
          onTap: (LatLng pos) {
            if (appState.isEditing) {
              _addRoutePoint(pos);
            } else {
              setState(() {
                appState.setSelectedMarker(null);
                appState.setEditing(false);
              });
            }
          },
          onMapCreated: (GoogleMapController controller) {
            _mapController = controller;
            if(_mapStyle !=null){_mapController.setMapStyle(_mapStyle!);}
          },
          minMaxZoomPreference: MinMaxZoomPreference(10, 15),
          cameraTargetBounds: CameraTargetBounds(istanbulBounds),
        ),
        Positioned(
            top: 50,
            right: 10,
            child: RightMenu(
              setEdit: _setEdit,
              deleteRoute: _deleteRoute,
              cancelEdit: _cancelEdit,
              confirmEdit: _showRouteNameDialog,
              undoRoute: _undoRoute,
            )
        ),
        BottomDragWidget(),
      ],
    );

  }

  void _showRouteNameDialog() {

    String routeName = "";

    showDialog(
        context: context,
        builder: (BuildContext context){
          String inputText = '';
          return AlertDialog(
            title: Text("Rota İsmi Girin"),
            content: TextField(
              onChanged: (value){
                  inputText = value;
              },
              decoration:InputDecoration(hintText: "Rota İsmi"),
            ),
            actions: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
                child: TextButton(
                   child: Text(
                       'İptal',
                       style: TextStyle(
                         color: Colors.white
                   ),),
                  onPressed: (){
                     Navigator.of(context).pop();
                  },
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
                child: TextButton(
                  child: Text(
                      'Kaydet',
                       style: TextStyle(
                         color: Colors.white
                       ),),
                  onPressed: (){
                    routeName = inputText;
                    _confirmEdit(routeName);
                    Navigator.of(context).pop();
                  },
                ),
              )
            ],
          );
        }
    );



  }

  void _addRoutePoint(LatLng point) {
    setState(() {
      _routePoints.add(point);

      _tempMarkers.add(Marker(
        markerId: MarkerId('marker_${_markerIdCounter++}'),
        position: point,
        infoWindow: InfoWindow(title: "Başlangıc"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ));

      if (_routePoints.length >= 2) {
        _polylines.clear();
        _polylines.add(Polyline(
          polylineId: PolylineId('route_${_polyLineIdCounter++}'),
          points: _routePoints,
          color: Colors.blue,
          width: 5,
        ));
        _tempMarkers.remove(_tempMarkers.elementAt(_tempMarkers.length - 1));
        _tempMarkers.add(Marker(
          markerId: MarkerId('marker'),
          position: _routePoints.last,
          infoWindow: InfoWindow(title: "varis"),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ));
      }
    });
  }

  void _addRouteMarker(Set<Marker> markers, Set<Polyline> polylines , List<LatLng> routePoints , String name) {
    setState(() {
      RouteMarker? routeMarker = null;
      RouteData? routeData = null;

      routeMarker = RouteMarker(
        position: markers.first.position,
        infoWindow: InfoWindow(title: name),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        markers: Set.from(markers.map((m) => Marker(
          markerId: m.markerId,
          position: m.position,
          infoWindow: m.infoWindow,
          icon: m.icon,
        ))),
        routePos: routePoints,
        polylines: Set.from(polylines.map((p) => Polyline(
          polylineId: p.polylineId,
          points: List<LatLng>.from(p.points),
          color: p.color,
          width: p.width,
        ))),
        onTap: () {
          _onMarkerTap(routeData!);
        },
      );
      routeData = RouteData(name,routeMarker) ;
      _tempMarkers.clear();
      appState.markers.add(routeMarker);
      _routePoints.clear();
      _polylines.clear();
    });
  }

  void _onMarkerTap(RouteData route) {
      appState.setSelectedMarker(route);
  }
  void _cancelEdit(){
    setState(() {
      appState.setSelectedMarker(null);
      appState.setEditing(false);
    });
  }

  void _undoRoute() {
    setState(() {
      if (_routePoints.isNotEmpty) {
        _routePoints.removeLast();

        if (_routePoints.length >= 2) {
          _polylines.clear();
          _polylines.add(Polyline(
            polylineId: PolylineId('route_${_polyLineIdCounter++}'),
            points: _routePoints,
            color: Colors.blue,
            width: 5,
          ));
          _tempMarkers.remove(_tempMarkers.elementAt(_tempMarkers.length - 1));
          _tempMarkers.add(Marker(
            markerId: MarkerId('marker'),
            position: _routePoints.last,
            infoWindow: InfoWindow(title: "varis"),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          ));
        } else {
          _routePoints.clear();
          _polylines.clear();
          _tempMarkers.clear();
        }
      }
    });
  }

  void _deleteRoute() {
    setState(() {
      if (appState.selectedMarker != null) {
        appState.markers.remove(appState.selectedMarker);
        appState.setSelectedMarker(null);
      } else {
        _routePoints.clear();
        _tempMarkers.clear();
        _polylines.clear();
      }
    });
  }

  void _confirmEdit(String routeName){
    setState(() {
      _addRouteMarker(_tempMarkers, _polylines , _routePoints ,(routeName.length == 0 ? "Rota Bilgisi" : routeName));
      appState.setEditing(false);
      appState.setSelectedMarker(null);
    });
  }

  void _setEdit(){
    setState(() {
      appState.setSelectedMarker(null);
      appState.setEditing(true);
    });
  }



}