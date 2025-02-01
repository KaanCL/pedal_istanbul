import 'package:flutter/material.dart';
import 'package:pedal_istanbul/providers/appstate.dart';
import 'package:pedal_istanbul/widgets/bottombarbutton.dart';
import 'package:provider/provider.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: BottomBarButton(img:Image.asset("assets/images/home.png")),
            label: "Home",
        ),
        BottomNavigationBarItem(
            icon: BottomBarButton(img:Image.asset("assets/images/routes.png")),
            label: "Routes",
        ),
        BottomNavigationBarItem(
            icon: BottomBarButton(img:Image.asset("assets/images/chatbot.png")),
            label: "Chatbot",
        ),
        BottomNavigationBarItem(
            icon: BottomBarButton(img:Image.asset("assets/images/unfavoriteicon.png")),
            label: "Favorites",
        ),

      ],
      backgroundColor: Colors.black,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey,
      currentIndex: Provider.of<AppState>(context, listen: false).currentPageIndex,
      onTap: Provider.of<AppState>(context, listen: false).setCurrentPageIndex,
    );
  }




}
