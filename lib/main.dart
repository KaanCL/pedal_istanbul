import 'package:flutter/material.dart';
import 'package:pedal_istanbul/providers/appstate.dart';
import 'package:pedal_istanbul/views/chatbot.dart';
import 'package:pedal_istanbul/views/favorites.dart';
import 'package:pedal_istanbul/views/home.dart';
import 'package:pedal_istanbul/views/mainscreen.dart';
import 'package:pedal_istanbul/views/routes.dart';
import 'package:pedal_istanbul/widgets/mapscreen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

void main() async{
  await dotenv.load();
  runApp(ChangeNotifierProvider(
    create: (context) => AppState(),
    child: MyApp(),
  ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: MainScreen()
    );

  }

}


