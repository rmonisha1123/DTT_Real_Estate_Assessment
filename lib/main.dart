import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/overview_screen.dart';
import 'screens/detail_screen.dart';
import 'screens/info_screen.dart';
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
        fontFamily: 'GothamSSm',
      ),
      // Start at splash screen
      initialRoute: '/',

      // 👇 Use onGenerateRoute for custom transitions
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return PageRouteBuilder(
              pageBuilder: (_, __, ___) => SplashScreen(),
              transitionsBuilder: (_, animation, __, child) => FadeTransition(
                opacity: animation,
                child: child,
              ),
            );

          case '/overview':
            return PageRouteBuilder(
              pageBuilder: (_, __, ___) => const OverviewScreen(),
              transitionsBuilder: (_, animation, __, child) =>
                  FadeTransition(opacity: animation, child: child),
            );

          case '/detail':
            final house = settings.arguments as House;
            return PageRouteBuilder(
              pageBuilder: (_, __, ___) => DetailScreen(house: house),
              transitionsBuilder: (_, animation, __, child) => SlideTransition(
                position: Tween(
                  begin: const Offset(1, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );

          case '/info':
            return PageRouteBuilder(
              pageBuilder: (_, __, ___) => InfoScreen(),
              transitionsBuilder: (_, animation, __, child) => SlideTransition(
                position: Tween(
                  begin: const Offset(1, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );

          default:
            return null;
        }
      },
    );
  }
}
