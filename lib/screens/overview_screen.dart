import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:connectivity_plus/connectivity_plus.dart'; // 👈 Added for offline handling
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
  bool _isOffline = false; // 👈 Track internet status

  final TextEditingController _searchController = TextEditingController();
  Position? _userPosition;

  late final Connectivity _connectivity;

  // Animation controllers
  late final AnimationController _transitionController;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;
  late final Animation<Offset> _backgroundParallax;

  @override
  void initState() {
    super.initState();
    _initConnectivityListener(); // 👈 Start internet monitoring
    _initData();

    // Main animation controller for transitions
    _transitionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.15, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _transitionController,
        curve: Curves.easeOutCubic,
      ),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _transitionController,
      curve: Curves.easeInOut,
    );

    _scaleAnimation = Tween<double>(begin: 0.98, end: 1.0).animate(
      CurvedAnimation(
        parent: _transitionController,
        curve: Curves.easeOut,
      ),
    );

    // Parallax background animation
    _backgroundParallax = Tween<Offset>(
      begin: const Offset(0.05, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _transitionController,
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  void dispose() {
    _transitionController.dispose();
    super.dispose();
  }

  /// 🔌 Connectivity listener setup
  void _initConnectivityListener() {
    _connectivity = Connectivity();
    _connectivity.onConnectivityChanged.listen((status) {
      final connected = status != ConnectivityResult.none;
      if (!connected) {
        setState(() => _isOffline = true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("⚠️ No internet connection"),
            backgroundColor: Colors.redAccent,
            duration: Duration(seconds: 3),
          ),
        );
      } else {
        if (_isOffline) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("✅ Back online — refreshing data..."),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
          _initData();
        }
        setState(() => _isOffline = false);
      }
    });
  }

  /// 🔁 Fetch data from API (when online)
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
      // If API fails (offline or other)
      setState(() {
        _loading = false;
        _isOffline = true;
      });
    }
  }

  /// 🔍 Filter houses by search query
  void _filterHouses(String query) {
    query = query.toLowerCase().trim();

    setState(() {
      _filteredHouses = query.isEmpty
          ? _houses
          : _houses.where((house) {
              final cityMatch = house.city.toLowerCase().contains(query);
              final postalMatch =
                  house.postalCode.toLowerCase().contains(query);
              return cityMatch || postalMatch;
            }).toList();
    });
  }

  /// 🏡 Overview Page (shows empty state when offline)
  Widget _buildOverviewPage() {
    if (_isOffline) {
      return const EmptyState(
        message: "No internet connection.\nPlease reconnect to load data.",
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: Text(
          "DTT REAL ESTATE",
          style: AppTextStyles.title01.copyWith(
              color: AppColors.textStrong, fontWeight: FontWeight.w700),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                _filterHouses(value);
                setState(() {}); // 👈 To update UI when user types
              },
              decoration: InputDecoration(
                hintText: "Search for a home",
                labelStyle: AppTextStyles.input,
                hintStyle: AppTextStyles.hint,
                filled: true,
                fillColor: AppColors.lightGray,
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, color: AppColors.textMedium),
                        onPressed: () {
                          _searchController.clear();
                          _filterHouses("");
                          setState(() {});
                        },
                      )
                    : Padding(
                        padding: const EdgeInsets.all(
                            12.0), // Adjust padding as needed
                        child: SvgPicture.asset(
                          'assets/Icons/ic_search.svg',
                          width: 20, // ✅ control width
                          height: 20, // ✅ control height
                          color: AppColors.textMedium,
                        ),
                      ),
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
              itemCount: 5,
              itemBuilder: (_, __) => const HouseCardShimmer(),
            )
          : _filteredHouses.isEmpty
              ? const EmptyState(
                  message: "No results found!\nPerhaps try another search?")
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
                        if (_isOffline) return;
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration:
                                const Duration(milliseconds: 500),
                            reverseTransitionDuration:
                                const Duration(milliseconds: 400),
                            pageBuilder: (_, animation, __) =>
                                DetailScreen(house: house),
                            transitionsBuilder: (_, animation, __, child) {
                              // Combine fade + slide + scale
                              final slideAnimation = Tween<Offset>(
                                begin: const Offset(0.1, 0.05),
                                end: Offset.zero,
                              ).animate(
                                CurvedAnimation(
                                  parent: animation,
                                  curve: Curves.easeOutCubic,
                                ),
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
                                  curve: Curves.easeOutBack,
                                ),
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

  /// ℹ️ Info Page (always available)
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
      if (!_isOffline) const WishlistScreen(), // 👈 Hide wishlist when offline
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
          // Prevent tapping wishlist if offline
          if (_isOffline && index == 2) return;

          if (index != _selectedIndex) {
            if (index == 1 || index == 2) {
              _transitionController.forward(from: 0);
            } else {
              _transitionController.reverse(from: 1);
            }
            setState(() => _selectedIndex = index);
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/Icons/ic_home.svg',
              width: 20, // ✅ control width
              height: 20, // ✅ control height
              color: _selectedIndex == 0
                  ? AppColors.primaryRed
                  : AppColors.textMedium,
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/Icons/ic_info.svg',
              width: 20, // ✅ control width
              height: 20, // ✅ control height
              color: _selectedIndex == 1
                  ? AppColors.primaryRed
                  : AppColors.textMedium,
            ),
            label: "",
          ),
          if (!_isOffline)
            const BottomNavigationBarItem(
              icon: Icon(Icons.favorite_outline),
              label: "",
            ),
        ],
      ),
    );
  }
}
