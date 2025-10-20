import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/house.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../utils/location_helper.dart';
import '../widgets/house_card.dart';
import '../widgets/empty_state.dart';
import 'info_screen.dart';

class OverviewScreen extends StatefulWidget {
  const OverviewScreen({super.key});

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  int _selectedIndex = 0;
  final ApiService api = ApiService();
  List<House> _houses = [];
  List<House> _filteredHouses = [];
  bool _loading = true;
  final TextEditingController _searchController = TextEditingController();
  Position? _userPosition;

  @override
  void initState() {
    super.initState();
    _initData();
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
                hintStyle: AppTextStyles.hint,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _filterHouses("");
                        },
                      )
                    : null,
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
          ? Center(
              child: CircularProgressIndicator(color: AppColors.primaryRed),
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
                          1000; // convert meters → km
                    }

                    return HouseCard(
                      house: house,
                      distance: distanceKm,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/detail',
                          arguments: house,
                        );
                      },
                    );
                  },
                ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildOverviewPage(),
      InfoScreen(),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.primaryRed,
        unselectedItemColor: AppColors.textMedium,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.info_outline), label: ""),
        ],
      ),
    );
  }
}
