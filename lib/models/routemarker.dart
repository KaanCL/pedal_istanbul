import 'dart:ui';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pedal_istanbul/respository/directions_respository.dart';


  class RouteMarker extends Marker {
    Set<Marker> markers;
    Set<Polyline> polylines;
    static int _idCounter = 0;
    final int id;

    RouteMarker({
      double alpha = 1.0,
      Offset anchor = const Offset(0.5, 1.0),
      bool consumeTapEvents = false,
      bool draggable = false,
      bool flat = false,
      BitmapDescriptor icon = BitmapDescriptor.defaultMarker,
      InfoWindow infoWindow = InfoWindow.noText,
      LatLng position = const LatLng(0.0, 0.0),
      double rotation = 0.0,
      bool visible = true,
      double zIndex = 0.0,
      String? clusterManagerId,
      void Function()? onTap,
      void Function(LatLng)? onDrag,
      void Function(LatLng)? onDragStart,
      void Function(LatLng)? onDragEnd,
      required this.markers,
      required this.polylines,
    })
        : id = _idCounter++,
          super(
          markerId: MarkerId("route_${_idCounter}"),
          alpha: alpha,
          anchor: anchor,
          consumeTapEvents: consumeTapEvents,
          draggable: draggable,
          flat: flat,
          icon: icon,
          infoWindow: infoWindow,
          position: position,
          rotation: rotation,
          visible: visible,
          zIndex: zIndex,
          onTap: onTap,
          onDrag: onDrag,
          onDragStart: onDragStart,
          onDragEnd: onDragEnd,
        );

    Set<Marker> get getMarkers {
    return markers;
    }


    Set<Polyline> get getPolylines {
        return polylines;
    }


    Future<void> getRouteInfo() async{

      try{
        final Direction = await DirectionsRepository().getRouteInfo(
            origin: markers.first.position,
            destination: markers.last.position);
          print("${Direction.totalDistance} " + " ${Direction.totalDuration} " +" ${Direction.caloriesBurned} " );
         }catch(e){
        print(e.toString());
      }

    }

  }
