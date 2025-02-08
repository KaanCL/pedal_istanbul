import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pedal_istanbul/models/routedata.dart';
import 'package:pedal_istanbul/providers/appstate.dart';
import 'package:pedal_istanbul/views/home.dart';
import 'package:pedal_istanbul/views/mainscreen.dart';
import 'package:provider/provider.dart';


class RouteCard extends StatefulWidget {

 final RouteData routeData;


  const RouteCard({super.key, required this.routeData});

  @override
  State<RouteCard> createState() => _RouteCardState();
}

class _RouteCardState extends State<RouteCard> {

  @override
  Widget build(BuildContext context) {

    double deviceWidth = MediaQuery.of(context).size.width;
    double cardWidth = deviceWidth * 0.45;
    double imageHeight = cardWidth * 0.647;
    double topOffset = cardWidth * (15 / 170);
    double rightOffset = cardWidth * (10 / 170);
    double iconSize = cardWidth * (20 / 170);

    AppState appState = Provider.of<AppState>(context);

    RouteData routeData = widget.routeData;

    return GestureDetector(
      onTap: () {
        setState(() {
          appState.setSelectedMarker(routeData);
          appState.setCameraPosition(routeData.routeMarker.position);
          appState.setCurrentPageIndex(0);
        });
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        margin: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: routeData.photos[0],
                    height: imageHeight,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: topOffset,
                  right: rightOffset,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        routeData.isFavorite = !routeData.isFavorite;
                        appState.updateFavoriteRoute(routeData.toJson());
                      });
                    },
                    child: Image.asset(
                      routeData.isFavorite
                          ? 'assets/images/favoriteicon.png'
                          : 'assets/images/unfavoriteicon.png',
                      width: iconSize,
                      height: iconSize,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Spacer(),
                    Text(
                      routeData.name,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Spacer(),
                    Container(
                      width: cardWidth * (100 / 170),
                      child: Text(
                        routeData.startAddress,
                        maxLines: 2,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Spacer(),
                    Text(
                      routeData.getTotalValues(),
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xff797878),
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


}
