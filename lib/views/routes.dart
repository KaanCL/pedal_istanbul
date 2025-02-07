import 'package:flutter/material.dart';
import 'package:pedal_istanbul/widgets/routecard.dart';
import 'package:pedal_istanbul/widgets/routescolumn.dart';
class Routes extends StatefulWidget {
  const Routes({super.key});

  @override
  State<Routes> createState() => _RoutesState();
}

class _RoutesState extends State<Routes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(backgroundColor: Colors.black, title: Text("Routes",style: TextStyle(color: Colors.white),), centerTitle: true),
            body:RoutesColumn()
    );
  }
}
