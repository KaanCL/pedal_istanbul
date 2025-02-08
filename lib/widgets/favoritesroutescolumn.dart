import 'package:flutter/material.dart';
import 'package:pedal_istanbul/models/routedata.dart';
import 'package:pedal_istanbul/providers/appstate.dart';
import 'package:pedal_istanbul/widgets/routecard.dart';
import 'package:provider/provider.dart';
class FavoritesRoutesColumn extends StatefulWidget {
  const FavoritesRoutesColumn({super.key});

  @override
  State<FavoritesRoutesColumn> createState() => _FavoritesRoutesColumnState();
}

class _FavoritesRoutesColumnState extends State<FavoritesRoutesColumn> {



  @override
  Widget build(BuildContext context) {
    AppState appState = Provider.of<AppState>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.8,
                ),
                itemCount:appState.favoriteRoutes.length ,
                itemBuilder: (context,index){
                  return RouteCard(routeData:appState.favoriteRoutes[index]);
                }),
          )

        ],
      ),
    );
  }
}
