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


 int _polyLineIdCounter = 0;
 int _markerIdCounter = 0;

 bool _isEditing = false;

 RouteMarker? _selectedMarker = null;


 @override
  void initState() {
   super.initState();
   _isEditing = true;
  }




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
              onTap: (LatLng pos){
                  if(_isEditing){
                    _addRoutePoint(pos);
                  }else{
                    setState(() {
                      _selectedMarker = null;
                      _isEditing = false;
                    });
                  }

              } ,
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
                      _addRouteMarker(_tempMarkers,_polylines);
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
            points: _routePoints,
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

  void _addRouteMarker(Set<Marker> markers , Set<Polyline> polylines){

    setState(() {

    RouteMarker? routeMarker = null;
    Marker? tempRouteMarker = null;

    routeMarker = RouteMarker(
      position: markers.first.position,
      infoWindow: InfoWindow(title: "Rota Bilgisi"),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      markers: Set.from(markers.map((m) => Marker(
        markerId: m.markerId,
        position: m.position,
        infoWindow: m.infoWindow,
        icon: m.icon,
      ))),
      polylines: Set.from(polylines.map((p) => Polyline(
        polylineId: p.polylineId,
        points: List<LatLng>.from(p.points),
        color: p.color,
        width: p.width,
      ))),
      onTap: () {
        _onMarkerTap(routeMarker!);
      },
    );

    tempRouteMarker= Marker(
        markerId: routeMarker.markerId,
        position: markers.first.position,
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
     marker.getRouteInfo();
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
          _tempMarkers.remove(_tempMarkers.elementAt(_tempMarkers.length-1));
          _tempMarkers.add(Marker(
              markerId: MarkerId('marker'),
              position:_routePoints.last,
              infoWindow:InfoWindow(title: "varis"),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue)
          ));
        }else{
          _routePoints.clear();
          _polylines.clear();
          _tempMarkers.clear();
        }

      }

    });
  }




}
