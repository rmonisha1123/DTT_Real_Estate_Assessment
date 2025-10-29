import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/house.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../utils/location_helper.dart';
import '../widgets/house_card.dart';
import '../widgets/empty_state.dart';
import '../widgets/house_card_shimmer.dart';
import 'info_screen.dart';
import 'detail_screen.dart';
import 'wishlist_screen.dart';

class OverviewScreen extends StatefulWidget {
  const OverviewScreen({super.key});

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  final ApiService api = ApiService();
  List<House> _houses = [];
  List<House> _filteredHouses = [];
  bool _loading = true;
  final TextEditingController _searchController = TextEditingController();
  Position? _userPosition;

  late final AnimationController _transitionController;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;
  late final Animation<Offset> _backgroundParallax;

  @override
  void initState() {
    super.initState();
    _initData();

    // Main animation controller for transitions
    _transitionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.15, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _transitionController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = CurvedAnimation(
      parent: _transitionController,
      curve: Curves.easeInOut,
    );

    _scaleAnimation = Tween<double>(begin: 0.98, end: 1.0).animate(
      CurvedAnimation(parent: _transitionController, curve: Curves.easeOut),
    );

    // 👇 Parallax background animation
    _backgroundParallax = Tween<Offset>(
      begin: const Offset(0.05, 0), // subtle shift right
      end: Offset.zero, // comes back to center
    ).animate(
      CurvedAnimation(parent: _transitionController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _transitionController.dispose();
    super.dispose();
  }

  Future<void> _initData() async {
    setState(() => _loading = true);

    try {
      final houses = await api.fetchHouses();
      final position = await LocationHelper.getUserLocation();

      setState(() {
        _houses = houses;
        _filteredHouses = houses;
        _userPosition = position;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  void _filterHouses(String query) {
    query = query.toLowerCase().trim();

    setState(() {
      if (query.isEmpty) {
        _filteredHouses = _houses;
      } else {
        _filteredHouses = _houses.where((house) {
          final cityMatch = house.city.toLowerCase().contains(query);
          final postalMatch = house.postalCode.toLowerCase().contains(query);
          return cityMatch || postalMatch;
        }).toList();
      }
    });
  }

  Widget _buildOverviewPage() {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: Text(
          "DTT REAL ESTATE",
          style: AppTextStyles.title01.copyWith(color: AppColors.textStrong),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              onChanged: _filterHouses,
              decoration: InputDecoration(
                hintText: "Search for a home",
                labelStyle: AppTextStyles.input,
                hintStyle: AppTextStyles.hint,
                suffixIcon: const Icon(Icons.search),
                // suffixIcon: _searchController.text.isNotEmpty
                //     ? IconButton(
                //         icon: const Icon(Icons.clear),
                //         onPressed: () {
                //           _searchController.clear();
                //           _filterHouses("");
                //         },
                //       )
                //     : null,
                filled: true,
                fillColor: AppColors.lightGray,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),
      body: _loading
          ? ListView.builder(
              itemCount: 5, // number of shimmer placeholders
              itemBuilder: (_, __) => const HouseCardShimmer(),
            )
          : _filteredHouses.isEmpty
              ? const EmptyState(
                  message: "No results found! Try another search.")
              : ListView.builder(
                  itemCount: _filteredHouses.length,
                  itemBuilder: (context, index) {
                    final house = _filteredHouses[index];
                    double? distanceKm;

                    if (_userPosition != null) {
                      distanceKm = LocationHelper.calculateDistance(
                            _userPosition!.latitude,
                            _userPosition!.longitude,
                            house.latitude,
                            house.longitude,
                          ) /
                          1000;
                    }

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration:
                                const Duration(milliseconds: 500),
                            reverseTransitionDuration:
                                const Duration(milliseconds: 400),
                            pageBuilder: (_, animation, secondaryAnimation) =>
                                DetailScreen(house: house),
                            transitionsBuilder:
                                (_, animation, secondaryAnimation, child) {
                              // Combine fade + slide + scale
                              final slideAnimation = Tween<Offset>(
                                begin: const Offset(0.1, 0.05),
                                end: Offset.zero,
                              ).animate(
                                CurvedAnimation(
                                    parent: animation,
                                    curve: Curves.easeOutCubic),
                              );

                              final fadeAnimation = CurvedAnimation(
                                parent: animation,
                                curve: Curves.easeInOut,
                              );

                              final scaleAnimation = Tween<double>(
                                begin: 0.96,
                                end: 1.0,
                              ).animate(
                                CurvedAnimation(
                                    parent: animation,
                                    curve: Curves.easeOutBack),
                              );

                              return FadeTransition(
                                opacity: fadeAnimation,
                                child: SlideTransition(
                                  position: slideAnimation,
                                  child: ScaleTransition(
                                    scale: scaleAnimation,
                                    child: child,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                      child: Hero(
                        tag: 'house-image-${house.id}',
                        child: HouseCard(
                          house: house,
                          distance: distanceKm,
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  Widget _buildInfoPage() {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: InfoScreen(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildOverviewPage(),
      _buildInfoPage(),
      const WishlistScreen(),
    ];

    return Scaffold(
      body: Stack(
        children: [
          SlideTransition(
            position: _backgroundParallax,
            child: Container(
              color: _selectedIndex == 0 ? Colors.white : Colors.grey.shade100,
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 450),
            child: pages[_selectedIndex],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.primaryRed,
        unselectedItemColor: AppColors.textMedium,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) {
          if (index != _selectedIndex) {
            if (index == 1 || index == 2) {
              _transitionController.forward(from: 0);
            } else {
              _transitionController.reverse(from: 1);
            }
            setState(() => _selectedIndex = index);
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.info_outline), label: ""),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_outline), label: ""),
        ],
      ),
    );
  }
}
