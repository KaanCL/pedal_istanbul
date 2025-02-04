import 'dart:ui';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pedal_istanbul/respository/directions_respository.dart';


  class RouteMarker extends Marker {
    Set<Marker> markers;
    Set<Polyline> polylines;
    List<LatLng> routePos;
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
      required this.routePos,
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

    List<LatLng> get getRoutePos{
      return routePos;
    }

   factory RouteMarker.fromJson(Map<String,dynamic> json){

      Set<Marker> markers = (json['markers'] as List)
          .map((marker)=>Marker(
             markerId: MarkerId(marker['_id']),
             position: LatLng(marker['position']['lat'],marker['position']['lng']),
             infoWindow: InfoWindow(title: marker['type'] ? "Başlangıc" : "Varış"),
             icon: BitmapDescriptor.defaultMarkerWithHue(marker['type'] ? BitmapDescriptor.hueGreen : BitmapDescriptor.hueBlue),
      )).toSet();

      Set<Polyline> polylines = (json['polylines'] as List)
         .map((polyline)=>Polyline(
                polylineId: PolylineId(polyline['_id']),
                points: (polyline['points'] as List)
                    .map((point) => LatLng(point['lat'], point['lng']))
                    .toList(),
      )).toSet();

      List<LatLng> routePos = (json['routePos'] as List)
          .map((pos) => LatLng(pos['lat'], pos['lng']))
          .toList();

      return RouteMarker(
        markers: markers,
        polylines: polylines,
        routePos: routePos
      );

    }



  }
