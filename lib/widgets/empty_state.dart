import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Displays a placeholder view when no content is available.
///
/// Commonly used to show empty results, error messages, or offline
/// states with a clear message to the user.
class EmptyState extends StatelessWidget {
  final String message;

  const EmptyState({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/Images/search_state_empty.png",
            width: 200,
          ),
          const SizedBox(height: 20),
          Text(
            message,
            style: AppTextStyles.body.copyWith(
                color: AppColors.textMedium,
                fontWeight: FontWeight.w100,
                fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
