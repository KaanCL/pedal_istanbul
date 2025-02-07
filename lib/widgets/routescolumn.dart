import 'package:flutter/material.dart';
import 'package:pedal_istanbul/providers/appstate.dart';
import 'package:pedal_istanbul/widgets/routecard.dart';
import 'package:provider/provider.dart';


class RoutesColumn extends StatefulWidget {
  const RoutesColumn({super.key});

  @override
  State<RoutesColumn> createState() => _RoutescolumnState();
}

class _RoutescolumnState extends State<RoutesColumn> {
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
                itemCount:appState.routes.length ,
                itemBuilder: (context,index){
                  return RouteCard(routeData: appState.routes[index]);
                }),
          )

        ],
      ),
    );
  }
}
