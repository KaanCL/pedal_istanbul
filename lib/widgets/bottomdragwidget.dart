import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pedal_istanbul/models/routedata.dart';
import 'package:provider/provider.dart';
import 'package:pedal_istanbul/providers/appstate.dart';

class BottomDragWidget extends StatefulWidget {
  const BottomDragWidget({super.key});

  @override
  _BottomDragWidgetState createState() => _BottomDragWidgetState();
}

class _BottomDragWidgetState extends State<BottomDragWidget> {
  @override
  Widget build(BuildContext context) {
    AppState appState = Provider.of<AppState>(context);
    final routeData = Provider.of<AppState>(context).selectedMarker;

    if (routeData == null) {
      return SizedBox.shrink();
    }

    return DraggableScrollableSheet(
      initialChildSize: 0.14,
      minChildSize: 0.14,
      maxChildSize: 0.3,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                spreadRadius: 0.5,
                offset: Offset(0.7, 0.7),
              ),
            ],
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20, top: 10),
                  child: Row(
                    children: [
                      Text(
                        routeData.name,
                        style: TextStyle(
                          fontSize: 22,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              routeData.isFavorite = !routeData.isFavorite;
                              routeData.toJsonAsync().then((json){
                                appState.updateFavoriteRoute(json);
                              });

                            });
                          },
                          child: Image.asset(
                            routeData.isFavorite ? 'assets/images/favoriteicon.png' : 'assets/images/unfavoriteicon.png',
                            width: 20,
                            height: 20,
                          ),
                        ),
                      ),
                      Spacer(),
                      Text(
                        routeData.getTotalValues(),
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xff797878),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20, top: 10),
                  child: Text(
                    routeData.startAddress,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xff797878),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20, top: 10),
                  child: Container(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: routeData.photos.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(right: 5),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CachedNetworkImage(
                              imageUrl: routeData.photos[index],
                              width: 107,
                              height: 90,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Center(
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                              errorWidget: (context, url, error) => Icon(Icons.error, size: 20),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}