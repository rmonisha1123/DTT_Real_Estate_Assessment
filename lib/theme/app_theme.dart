import 'package:flutter/material.dart';

class AppColors {
  static const Color deepRed = Color(0xFFB71C1C);
  static const Color primaryRed = Color(0xFFE65541);
  static const Color white = Color(0xFFFFFFFF);
  static const Color lightGray = Color(0xFFF7F7F7);
  static const Color darkGray = Color(0xFFEBEBEB);
  static const Color textStrong = Color(0xCC000000);
  static const Color textMedium = Color(0x66000000);
  static const Color textLight = Color(0x33000000);
}

class AppTextStyles {
  // Title 01 – Bold | 18dp
  static const TextStyle title01 = TextStyle(
    fontFamily: 'GothamSSm',
    fontSize: 18,
    color: AppColors.textStrong,
  );

  // Title 02 – Bold | 16dp
  static const TextStyle title02 = TextStyle(
    fontFamily: 'GothamSSm',
    fontSize: 16,
    color: AppColors.textStrong,
  );

  // Title 03 – Medium | 16dp
  static const TextStyle title03 = TextStyle(
    fontFamily: 'GothamSSm',
    fontSize: 16,
    color: AppColors.textMedium,
  );

  // Body – Book | 12dp
  static const TextStyle body = TextStyle(
    fontFamily: 'GothamSSm',
    fontSize: 12,
    color: AppColors.textMedium,
  );

  // Input – Light | 12dp
  static const TextStyle input = TextStyle(
    fontFamily: 'GothamSSm',
    fontSize: 12,
    color: AppColors.textMedium,
  );

  // Hint – Book | 12dp
  static const TextStyle hint = TextStyle(
    fontFamily: 'GothamSSm',
    fontSize: 12,
    color: AppColors.textLight,
  );

  // Subtitle – Book | 10dp
  static const TextStyle subtitle = TextStyle(
    fontFamily: 'GothamSSm',
    fontSize: 10,
    color: AppColors.textMedium,
  );

  // Detail – Book | 12dp
  static const TextStyle detail = TextStyle(
    fontFamily: 'GothamSSm',
    fontSize: 12,
    color: AppColors.textLight,
  );
}
