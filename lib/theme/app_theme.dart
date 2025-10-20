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
  static const title01 = TextStyle(
      fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textStrong);
  static const title02 = TextStyle(
      fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textStrong);
  static const title03 = TextStyle(
      fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.textStrong);
  static const body = TextStyle(
      fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.textMedium);
  static const input = TextStyle(
      fontSize: 12, fontWeight: FontWeight.w300, color: AppColors.textStrong);
  static const hint = TextStyle(
      fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.textLight);
  static const subtitle = TextStyle(
      fontSize: 10, fontWeight: FontWeight.w400, color: AppColors.textMedium);
  static const detail = TextStyle(
      fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.textMedium);
}
