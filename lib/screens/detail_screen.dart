import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/house.dart';
import '../theme/app_theme.dart';

class DetailScreen extends StatelessWidget {
  final House house;

  const DetailScreen({super.key, required this.house});

  // Open default maps app
  Future<void> _openMaps(double lat, double lng) async {
    final Uri googleMapsUrl =
        Uri.parse("https://www.google.com/maps/search/?api=1&query=$lat,$lng");
    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
    } else {
      throw "Could not open the map.";
    }
  }

  @override
  Widget build(BuildContext context) {
    final LatLng houseLocation = LatLng(house.latitude, house.longitude);

    return Scaffold(
      appBar: AppBar(
        title: Text("DETAILS",
            style: AppTextStyles.title01.copyWith(color: AppColors.white)),
        backgroundColor: AppColors.primaryRed,
      ),
      body: ListView(
        children: [
          // House image
          ClipRRect(
            borderRadius:
                const BorderRadius.vertical(bottom: Radius.circular(12)),
            child: Image.network(
              house.imageUrl,
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("\$${house.price.toStringAsFixed(0)}",
                  style: AppTextStyles.title01),
              const SizedBox(height: 4),
              Text("${house.postalCode} ${house.city}",
                  style: AppTextStyles.body),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.bed, size: 18, color: AppColors.textMedium),
                  const SizedBox(width: 4),
                  Text("${house.bedrooms}", style: AppTextStyles.detail),
                  const SizedBox(width: 16),
                  Icon(Icons.bathtub, size: 18, color: AppColors.textMedium),
                  const SizedBox(width: 4),
                  Text("${house.bathrooms}", style: AppTextStyles.detail),
                  const SizedBox(width: 16),
                  Icon(Icons.square_foot,
                      size: 18, color: AppColors.textMedium),
                  const SizedBox(width: 4),
                  Text("${house.size} m²", style: AppTextStyles.detail),
                ],
              ),
              const SizedBox(height: 20),
              Text("Description", style: AppTextStyles.title02),
              const SizedBox(height: 6),
              Text(
                house.description ?? "No description available.",
                style: AppTextStyles.body,
              ),
              const SizedBox(height: 20),
              Text("Location", style: AppTextStyles.title02),
              const SizedBox(height: 12),
              SizedBox(
                height: 200,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: GoogleMap(
                    initialCameraPosition:
                        CameraPosition(target: houseLocation, zoom: 14),
                    markers: {
                      Marker(
                        markerId: const MarkerId("house"),
                        position: houseLocation,
                      ),
                    },
                    onTap: (_) => _openMaps(house.latitude, house.longitude),
                    zoomControlsEnabled: false,
                    myLocationButtonEnabled: false,
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
