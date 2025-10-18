import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/overview_screen.dart';

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
      // Start with splash screen
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/overview': (context) => OverviewScreen(),
      },
    );
  }
}
