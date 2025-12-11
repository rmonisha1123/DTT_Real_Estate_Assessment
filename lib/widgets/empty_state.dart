import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

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
            "assets/Images/search_state_empty.png", // add an illustration (from your assets)
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
