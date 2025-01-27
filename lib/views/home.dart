import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pedal_istanbul/providers/appstate.dart';
import 'package:pedal_istanbul/widgets/mapscreen.dart';
import 'package:pedal_istanbul/widgets/bottombar.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {

  const Home({super.key});

  @override
  State<Home> createState() => _State();
}

class _State extends State<Home> {

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("${appState.isEditing ? "Add Route" : "Select Route"}",style: TextStyle(color: Colors.white),),
        centerTitle: true,
      ),
      body: MapScreen(),

    );
  }
}
