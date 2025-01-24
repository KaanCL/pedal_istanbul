import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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

 int _polyLineIdCounter = 0;
 int _markerIdCounter = 0;


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
             initialCameraPosition: CameraPosition(
              target: LatLng(41.0082, 28.9784),
              zoom: 12),
              polylines: _polylines,
              markers: _markers,
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
                      _polylines.clear();
                      _markers.clear();
                  });} ,
                  child: Icon(Icons.cleaning_services_outlined),
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

      _markers.add(Marker(
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
        _markers.remove(_markers.elementAt(_markers.length-1));
        _markers.add(Marker(
            markerId: MarkerId('marker'),
            position:_routePoints.last,
            infoWindow:InfoWindow(title: "varis"),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue)
        ));


      }

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
