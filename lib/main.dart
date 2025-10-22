import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/overview_screen.dart';
import 'screens/detail_screen.dart';
import 'models/house.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DTT Real Estate Assessment',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/overview': (context) => OverviewScreen(),
        '/detail': (context) {
          // get the House object passed as argument
          final house = ModalRoute.of(context)!.settings.arguments as House;
          return DetailScreen(house: house);
        },
      },
    );
  }
}
