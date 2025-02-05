import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pedal_istanbul/models/routedata.dart';
import 'package:pedal_istanbul/providers/appstate.dart';
import 'package:pedal_istanbul/respository/directions_respository.dart';
import 'package:provider/provider.dart';


  class RouteMarker extends Marker {
    Set<Marker> markers;
    Set<Polyline> polylines;
    List<LatLng> routePos;
    static int _idCounter = 0;
    final int id;

    void Function() onTapCallBack;

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
      void Function(LatLng)? onDrag,
      void Function(LatLng)? onDragStart,
      void Function(LatLng)? onDragEnd,
      required this.markers,
      required this.polylines,
      required this.routePos,
      required this.onTapCallBack

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
          onTap: onTapCallBack,
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

      RouteMarker? routermarker = null;

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
                color: Colors.blue,
                width: 5,
      )).toSet();

      List<LatLng> routePos = (json['routePos'] as List)
          .map((pos) => LatLng(pos['lat'], pos['lng']))
          .toList();

      routermarker =RouteMarker(
          markers: markers,
          polylines: polylines,
          position: markers.first.position,
          routePos: routePos,
          icon:BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
          onTapCallBack: (){},
          infoWindow: InfoWindow(title: json['name']),);

      return routermarker;
    }

    Map<String, dynamic> toJson() {
      return {
        'markers': markers.map((marker) {
          return {
            'type': marker == markers.first ? true : false,
            'position': {
              'lat': marker.position.latitude,
              'lng': marker.position.longitude,
            },
          };
        }).toList(),

        'polylines': polylines.map((polyline) {
          return {
            'points': polyline.points.map((point) {
              return {
                'lat': point.latitude,
                'lng': point.longitude,
              };
            }).toList(),
          };
        }).toList(),

        'routePos': routePos.map((routePos) {
          return {
            'lat': routePos.latitude,
            'lng': routePos.longitude,
          };
        }).toList(),
      };
    }


  }
