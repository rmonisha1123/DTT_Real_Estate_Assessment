import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Banner displayed when the device is offline.
///
/// Informs the user about connectivity issues and prevents actions
/// that require an active internet connection.
class NoInternetBanner extends StatelessWidget {
  const NoInternetBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red.shade600,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Center(
        child: Text(
          '⚠️ No Internet Connection',
          style: AppTextStyles.body.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
