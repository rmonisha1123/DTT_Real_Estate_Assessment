import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/house.dart';
import '../theme/app_theme.dart';
import '../utils/location_helper.dart';
import '../utils/price_formatter.dart';

class DetailScreen extends StatefulWidget {
  final House house;

  const DetailScreen({super.key, required this.house});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  double? distanceKm;
  Position? _userPosition;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    // setState(() => _loading = true);

    try {
      // final houses = await api.fetchHouses();
      final position = await LocationHelper.getUserLocation();

      setState(() {
        _userPosition = position;
      });

      if (_userPosition != null) {
        distanceKm = LocationHelper.calculateDistance(
              _userPosition!.latitude,
              _userPosition!.longitude,
              widget.house.latitude,
              widget.house.longitude,
            ) /
            1000;
      } else {
        print("ELSE");
      }
    } catch (e) {
      // setState(() => _loading = false);
    }
  }

  // Open Google Maps when tapped
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
    final LatLng houseLocation =
        LatLng(widget.house.latitude, widget.house.longitude);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          // ---------- FIXED IMAGE (NEVER SCROLLS) ----------
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 250,
              child: Hero(
                tag: 'house-image-${widget.house.id}',
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  child: Image.network(
                    widget.house.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),

          // ---------- SCROLLABLE CONTENT ----------
          Positioned(
            top: 215, // where white container starts
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(formatPrice(widget.house.price),
                              style: AppTextStyles.title01),
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
                                distanceKm != null
                                    ? "${distanceKm!.toStringAsFixed(1)} km"
                                    : "-",
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),
                    Text("Description",
                        style: AppTextStyles.title02.copyWith(
                            fontWeight: FontWeight.w500, fontSize: 17)),
                    const SizedBox(height: 20),
                    Text(
                      widget.house.description ?? "No description available.",
                      style: AppTextStyles.body
                          .copyWith(fontWeight: FontWeight.w300),
                    ),
                    const SizedBox(height: 24),
                    Text("Location",
                        style: AppTextStyles.title02.copyWith(
                            fontWeight: FontWeight.w500, fontSize: 17)),
                    const SizedBox(height: 15),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SizedBox(
                        height: 200,
                        child: GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: houseLocation,
                            zoom: 14,
                          ),
                          markers: {
                            Marker(
                              markerId: const MarkerId("house"),
                              position: houseLocation,
                            ),
                          },
                          onTap: (_) => _openMaps(
                              widget.house.latitude, widget.house.longitude),
                          zoomControlsEnabled: false,
                          myLocationButtonEnabled: false,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),

          // Back Button Overlay
          Positioned(
            top: 40,
            left: 16,
            child: CircleAvatar(
              backgroundColor: Colors.black.withOpacity(0.5),
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: SvgPicture.asset(
                  'assets/Icons/ic_back.svg',
                  height: 22,
                  // ignore: deprecated_member_use
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

// 🔧 Helper widget to combine SVG icon and text neatly
  Widget _iconWithText(String assetPath, String text) {
    return Row(
      children: [
        SvgPicture.asset(
          assetPath,
          width: 16,
          height: 16,
          colorFilter: const ColorFilter.mode(
            AppColors.textMedium,
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: AppTextStyles.detail.copyWith(
              color: AppColors.textMedium,
              fontWeight: FontWeight.w400,
              fontSize: 10),
        ),
      ],
    );
  }
}
