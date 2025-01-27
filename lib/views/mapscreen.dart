import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pedal_istanbul/models/routemarker.dart';
import 'package:pedal_istanbul/providers/appstate.dart';
import 'package:pedal_istanbul/widgets/bottombar.dart';
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
  final Set<Marker> _markers = {};
  final Set<Marker> _tempMarkers = {};



  int _polyLineIdCounter = 0;
  int _markerIdCounter = 0;

  @override
  void initState() {
    super.initState();
    _loadMapStyle();
    Provider.of<AppState>(context, listen: false).setEditing(true);
  }

  Future<void> _loadMapStyle() async{
    String style = await rootBundle.loadString('assets/mapstyle/mapstyle.json');
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
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("${appState.isEditing ? "Add Route" : "Select Route"}",style: TextStyle(color: Colors.white),),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(target: LatLng(41.0082, 28.9784), zoom: 12),
            polylines: appState.isEditing ? _polylines : (appState.selectedMarker?.getPolylines ?? {}),
            markers: appState.isEditing ? _tempMarkers : (appState.selectedMarker == null ? _markers : (appState.selectedMarker?.getMarkers ?? {})),
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
              if(_mapStyle !=null){
                print("AAAAAAAAAAAAAAAAAAAAA"*100);
                _mapController.setMapStyle(_mapStyle!);
              }
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
              confirmEdit: _confirmEdit,
              undoRoute: _undoRoute,
            )

          ),
        ],
      ),
      bottomNavigationBar:BottomBar()
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

  void _addRouteMarker(Set<Marker> markers, Set<Polyline> polylines) {
    setState(() {
      RouteMarker? routeMarker = null;

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

      _tempMarkers.clear();
      _markers.add(routeMarker!);
      _routePoints.clear();
      _polylines.clear();
    });
  }

  void _onMarkerTap(RouteMarker marker) {
    setState(() {
      print("Tapped marker position: ${marker.position}");
      Provider.of<AppState>(context, listen: false).setSelectedMarker(marker);
      marker.getRouteInfo();
    });
  }

  void _cancelEdit(){
    setState(() {
      Provider.of<AppState>(context, listen: false).setSelectedMarker(null);
      Provider.of<AppState>(context, listen: false).setEditing(false);
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
      if (Provider.of<AppState>(context, listen: false).selectedMarker != null) {
        _markers.remove(Provider.of<AppState>(context, listen: false).selectedMarker);
        Provider.of<AppState>(context, listen: false).setSelectedMarker(null);
      } else {
        _routePoints.clear();
        _tempMarkers.clear();
        _polylines.clear();
      }
    });
  }

  void _confirmEdit(){
    setState(() {
      _addRouteMarker(_tempMarkers, _polylines);
      Provider.of<AppState>(context, listen: false).setEditing(false);
      Provider.of<AppState>(context, listen: false).setSelectedMarker(null);
    });
  }

  void _setEdit(){
    setState(() {
      Provider.of<AppState>(context, listen: false).setSelectedMarker(null);
      Provider.of<AppState>(context, listen: false).setEditing(true);
    });
  }

}