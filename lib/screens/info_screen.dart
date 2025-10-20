import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class InfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ABOUT",
            style: AppTextStyles.title01.copyWith(color: AppColors.white)),
        backgroundColor: AppColors.primaryRed,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit. "
              "Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. "
              "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi "
              "ut aliquip ex ea commodo consequat.",
              style: AppTextStyles.body,
            ),
            const SizedBox(height: 20),
            Text(
              "Design and Development",
              style: AppTextStyles.title02,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Image.asset(
                  "assets/Images/launcher_icon.png", // place your DTT logo in assets
                  height: 40,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("by DTT", style: AppTextStyles.body),
                    GestureDetector(
                      onTap: () {
                        // Later: launch URL with url_launcher package
                      },
                      child: Text(
                        "www.d-tt.nl",
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.primaryRed,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
