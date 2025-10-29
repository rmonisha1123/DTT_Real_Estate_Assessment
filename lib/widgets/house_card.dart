// lib/widgets/house_card.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/house.dart';
import '../theme/app_theme.dart';

class HouseCard extends StatefulWidget {
  final House house;
  final VoidCallback? onTap;
  final double? distance;

  const HouseCard({
    super.key,
    required this.house,
    this.onTap,
    this.distance,
  });

  @override
  State<HouseCard> createState() => _HouseCardState();
}

class _HouseCardState extends State<HouseCard> {
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
  }

  // ✅ Load favorite status from SharedPreferences
  Future<void> _loadFavoriteStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = prefs.getStringList('wishlist') ?? [];

    final isFav = favoritesJson.any((item) {
      final data = jsonDecode(item);
      return data['id'] == widget.house.id;
    });

    setState(() {
      _isFavorite = isFav;
    });
  }

  // ✅ Toggle favorite status and persist to SharedPreferences
  Future<void> _toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = prefs.getStringList('wishlist') ?? [];

    if (_isFavorite) {
      // Remove from wishlist
      favoritesJson.removeWhere((item) {
        final data = jsonDecode(item);
        return data['id'] == widget.house.id;
      });
    } else {
      // Add to wishlist
      favoritesJson.add(jsonEncode(widget.house.toJson()));
    }

    await prefs.setStringList('wishlist', favoritesJson);

    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Card(
        color: AppColors.white,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🏠 House image with favorite icon overlay
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      widget.house.imageUrl,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: _toggleFavorite,
                      child: Icon(
                        _isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: _isFavorite
                            ? AppColors.primaryRed
                            : AppColors.textMedium,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "\$${widget.house.price.toStringAsFixed(0)}",
                      style: AppTextStyles.title02,
                    ),
                    Text(
                      "${widget.house.postalCode} ${widget.house.city}",
                      style: AppTextStyles.body,
                    ),
                    const SizedBox(height: 25),
                    Row(
                      children: [
                        _iconWithText("assets/Icons/ic_bed.svg",
                            "${widget.house.bedrooms}"),
                        const SizedBox(width: 23),
                        _iconWithText("assets/Icons/ic_bath.svg",
                            "${widget.house.bathrooms}"),
                        const SizedBox(width: 23),
                        _iconWithText("assets/Icons/ic_layers.svg",
                            "${widget.house.size}"),
                        const SizedBox(width: 23),
                        _iconWithText(
                          "assets/Icons/ic_location.svg",
                          widget.distance != null
                              ? "${widget.distance!.toStringAsFixed(1)} km"
                              : "-",
                        ),
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

  // 🔧 Helper widget to combine SVG icon and text neatly
  Widget _iconWithText(String assetPath, String text) {
    return Row(
      children: [
        SvgPicture.asset(
          assetPath,
          width: 14,
          height: 14,
          colorFilter: const ColorFilter.mode(
            AppColors.textMedium,
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: AppTextStyles.detail.copyWith(color: AppColors.textMedium),
        ),
      ],
    );
  }
}
