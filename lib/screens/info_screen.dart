import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';

class InfoScreen extends StatelessWidget {
  final bool isOffline; // 👈 new flag to detect offline state
  final Uri _url = Uri.parse('http://www.d-tt.nl/');

  InfoScreen({super.key, this.isOffline = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "ABOUT",
          style: AppTextStyles.title01.copyWith(color: AppColors.white),
        ),
        backgroundColor: AppColors.primaryRed,
      ),
      body: Stack(
        children: [
          // 👇 Main Info Content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariature. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incidididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident.",
                  style: AppTextStyles.body,
                ),
                const SizedBox(height: 30),
                Text(
                  "Design and Development",
                  style: AppTextStyles.title02,
                ),
                const SizedBox(height: 25),
                Row(
                  children: [
                    Image.asset(
                      "assets/Images/dtt_banner/mdpi/dtt_banner.png",
                      height: 40,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("by DTT", style: AppTextStyles.body),
                        GestureDetector(
                          onTap: _launchUrl,
                          child: Text(
                            "d-tt.nl",
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
                const SizedBox(height: 40),
                // 👇 Small note if offline
                if (isOffline)
                  Column(
                    children: [
                      const Divider(height: 30),
                      Center(
                        child: Text(
                          "⚠️ You’re offline — some links may not work.",
                          style: AppTextStyles.body.copyWith(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),

          // 👇 Floating offline banner (same as other screens)
          if (isOffline)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.redAccent,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                child: SafeArea(
                  bottom: false,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.wifi_off, color: Colors.white, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        "No internet connection",
                        style: AppTextStyles.body.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }
}
