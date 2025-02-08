import 'package:flutter/material.dart';
import 'package:pedal_istanbul/widgets/favoritesroutescolumn.dart';

class Favorites extends StatefulWidget {
  const Favorites({super.key});

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(backgroundColor: Colors.black, title: Text("Favorites",style: TextStyle(color: Colors.white),), centerTitle: true,),
        body:FavoritesRoutesColumn(),
    );
  }
}
