import 'dart:async';

import 'package:dtt_real_estate_assessment/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Displays the launch splash screen.
///
/// This screen is shown briefly when the app starts and is responsible
/// for transitioning the user to the overview screen once initialization
/// is complete.
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 900),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _controller.forward();

    //  Short display → acts as animated continuation of native splash
    Timer(const Duration(milliseconds: 1200), () {
      Navigator.of(context).pushReplacementNamed('/overview');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryRed,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Image.asset(
              'assets/Images/launcher_icon.png',
              width: 120,
            ),
          ),
        ),
      ),
    );
  }
}
