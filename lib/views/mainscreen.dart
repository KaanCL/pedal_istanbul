import 'package:flutter/material.dart';import 'package:flutter/material.dart';
import 'package:pedal_istanbul/providers/appstate.dart';
import 'package:pedal_istanbul/views/chatbot.dart';
import 'package:pedal_istanbul/views/favorites.dart';
import 'package:pedal_istanbul/views/home.dart';
import 'package:pedal_istanbul/views/routes.dart';
import 'package:pedal_istanbul/widgets/bottombar.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Scaffold(
      body: _getPage(appState.currentPageIndex),
      bottomNavigationBar:BottomBar() ,
    );
  }

  Widget _getPage(int index){
    switch (index) {
      case 0:
        return Home();
      case 1:
        return Routes();
      case 2:
        return ChatBot();
      default:
        return Favorites();
    }
  }

}
