import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
// import '../theme/app_theme.dart';

class HouseCardShimmer extends StatelessWidget {
  const HouseCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image placeholder
              Container(
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Container(
                  width: 160,
                  height: 7,
                  color: Colors.grey.shade300,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Container(
                  width: 100,
                  height: 6,
                  color: Colors.grey.shade300,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
