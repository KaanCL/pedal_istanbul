import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pedal_istanbul/models/routemarker.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

 late GoogleMapController _mapController;
 final List<LatLng> _routePoints = [];
 final Set<Polyline> _polylines = {};
 final Set<Marker> _markers = {};

 final Set<Marker> _tempMarkers= {};
 List<LatLng> _tempRoutePoints = [];

 int _polyLineIdCounter = 0;
 int _markerIdCounter = 0;

 bool _isEditing = false;



 @override
  void initState() {
   super.initState();
   _isEditing = true;
  }


 RouteMarker? _selectedMarker = null;

 final LatLngBounds istanbulBounds = LatLngBounds(
       southwest: LatLng(40.8024, 28.5245),
       northeast: LatLng(41.3201, 29.4305),
 );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
             initialCameraPosition: CameraPosition(target: LatLng(41.0082, 28.9784), zoom: 12),
              polylines: _isEditing ? _polylines : (_selectedMarker?.getPolylines ?? {}),
              markers:   _isEditing ? _tempMarkers : (_selectedMarker == null ? _markers : (_selectedMarker?.getMarkers ?? {})),
              onTap: _addRoutePoint,
              onMapCreated: (GoogleMapController controller) {_mapController = controller;},
              minMaxZoomPreference: MinMaxZoomPreference(10, 15),
              cameraTargetBounds: CameraTargetBounds(istanbulBounds),
          ),
          Positioned(
            top: 50,
            right: 10,
            child: Column(
              children: [
                FloatingActionButton(
                  onPressed: _clearRoute,
                  child: Icon(Icons.clear),
                ),
                SizedBox(height: 5,),
                FloatingActionButton(
                  onPressed:(){
                    setState(() {
                      _routePoints.clear();
                      if(_isEditing){
                        _tempMarkers.clear();
                        _polylines.clear();
                      }else{
                        _markers.clear();
                        _isEditing = true;
                      }
                  });} ,
                  child: Icon(Icons.cleaning_services_outlined),
                ),
                SizedBox(height: 5,),
                if(_isEditing==false)
                  FloatingActionButton(
                    backgroundColor: Colors.deepOrange,
                    onPressed: () {
                      setState(() {
                        _isEditing = true;
                      });
                    },
                    child: Icon(Icons.add),
                  ),
                SizedBox(height: 5,),
                if(_isEditing)
                FloatingActionButton(
                  onPressed:(){
                    setState(() {
                      _addRouteMarker();
                      _isEditing=false;
                      _selectedMarker=null;
                    });} ,
                  child: Icon(Icons.offline_pin),
                ),
              ],
            ),
          )
        ],
      ),

    );
  }

  void _addRoutePoint(LatLng point){
    setState(() {
      _routePoints.add(point);

      _tempRoutePoints = _routePoints;

      _tempMarkers.add(Marker(
          markerId: MarkerId('marker_${_markerIdCounter++}'),
          position:point,
          infoWindow:InfoWindow(title: "Başlangıc"),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen)
      ));

      if(_routePoints.length >= 2){
        _polylines.clear();
        _polylines.add(Polyline(
            polylineId: PolylineId('route_${_polyLineIdCounter++}'),
            points: _tempRoutePoints,
            color:Colors.blue,
            width: 5,
        ));
        _tempMarkers.remove(_tempMarkers.elementAt(_tempMarkers.length-1));
        _tempMarkers.add(Marker(
            markerId: MarkerId('marker'),
            position:_routePoints.last,
            infoWindow:InfoWindow(title: "varis"),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue)
        ));


      }
    });
  }

  void _addRouteMarker(){

    _tempRoutePoints = _routePoints;
    setState(() {

    RouteMarker? routeMarker = null;
    Marker? tempRouteMarker = null;
    if (_routePoints.length < 2) return;

    final midPoint = LatLng(
      (_routePoints.first.latitude + _routePoints.last.latitude) / 2,
      (_routePoints.first.longitude + _routePoints.last.longitude) / 2,
    );


    routeMarker = RouteMarker(
       position: midPoint,
       infoWindow:InfoWindow(title: "Rota Bilgisi"),
       icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
       markers: Set.from(_tempMarkers),
       polylines: Set.from(_polylines),
       onTap: () {
         _onMarkerTap(routeMarker!);
       });

    tempRouteMarker= Marker(
        markerId: routeMarker.markerId,
        position: midPoint,
        infoWindow:InfoWindow(title: "Rota Bilgisi"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
        onTap: () {
          _onMarkerTap(routeMarker!);
        });

       _tempMarkers.clear();
      _markers.add(routeMarker!);
      _routePoints.clear();
      _polylines.clear();
    });
  }

 void _onMarkerTap(RouteMarker marker) {
   setState(() {
     print("Tapped marker position: ${marker.position}");
     _selectedMarker = marker;
     print("${marker.polylines.first.points}");
   });
 }

  void _clearRoute(){
    setState(() {
      if(_routePoints.isNotEmpty){
        _routePoints.removeLast();


        if(_routePoints.length >= 2){
          _polylines.clear();
          _polylines.add(
              Polyline(
                polylineId: PolylineId('route_${_polyLineIdCounter++}'),
                points: _routePoints,
                color: Colors.blue,
                width: 5,
              ),
          );
          _markers.remove(_markers.elementAt(_markers.length-1));
          _markers.add(Marker(
              markerId: MarkerId('marker'),
              position:_routePoints.last,
              infoWindow:InfoWindow(title: "varis"),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue)
          ));
        }else{
          _routePoints.clear();
          _polylines.clear();
          _markers.clear();
        }

      }

    });
  }




}
