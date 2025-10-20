// lib/widgets/house_card.dart
import 'package:flutter/material.dart';
import '../models/house.dart';
import '../theme/app_theme.dart';

class HouseCard extends StatelessWidget {
  final House house;
  final VoidCallback onTap;
  final double? distance; // NEW

  const HouseCard({
    super.key,
    required this.house,
    required this.onTap,
    this.distance,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  house.imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("\$${house.price.toStringAsFixed(0)}",
                        style: AppTextStyles.title02),
                    Text("${house.postalCode} ${house.city}",
                        style: AppTextStyles.body),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.bed, size: 16, color: AppColors.textMedium),
                        const SizedBox(width: 4),
                        Text("${house.bedrooms}", style: AppTextStyles.detail),
                        const SizedBox(width: 12),
                        Icon(Icons.bathtub,
                            size: 16, color: AppColors.textMedium),
                        const SizedBox(width: 4),
                        Text("${house.bathrooms}", style: AppTextStyles.detail),
                        const SizedBox(width: 12),
                        Icon(Icons.square_foot,
                            size: 16, color: AppColors.textMedium),
                        const SizedBox(width: 4),
                        Text("${house.size}", style: AppTextStyles.detail),
                        const SizedBox(width: 12),
                        Icon(Icons.location_on,
                            size: 16, color: AppColors.textMedium),
                        const SizedBox(width: 4),
                        // show distance only if provided
                        if (distance != null)
                          Text("${distance!.toStringAsFixed(1)} km",
                              style: AppTextStyles.detail)
                        else
                          Text("-", style: AppTextStyles.detail),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
