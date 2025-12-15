import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/overview_screen.dart';

void main() {
  runApp(MyApp());
}

/// Root widget of the application.
///
/// Sets up global theming and defines the top-level navigation flow.
/// The app starts with a splash screen and transitions into the
/// overview screen, where further navigation is handled internally.
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
      initialRoute: '/',

      // Use onGenerateRoute for custom transitions
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

          default:
            return MaterialPageRoute(
              builder: (_) => const OverviewScreen(),
            );
        }
      },
    );
  }
}
