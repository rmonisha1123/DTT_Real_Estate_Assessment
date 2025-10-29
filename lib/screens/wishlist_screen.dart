// lib/screens/wishlist_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/house.dart';
import '../widgets/house_card.dart';
import '../widgets/empty_state.dart';
import '../theme/app_theme.dart';
import 'detail_screen.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  List<House> _wishlist = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadWishlist();
  }

  Future<void> _loadWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = prefs.getStringList('wishlist') ?? [];

    final List<House> houses = favoritesJson.map((item) {
      final data = jsonDecode(item);
      return House.fromJson(data);
    }).toList();

    setState(() {
      _wishlist = houses;
      _loading = false;
    });
  }

  Future<void> _refreshWishlist() async {
    await _loadWishlist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: Text(
          "WISHLIST",
          style: AppTextStyles.title01.copyWith(color: AppColors.textStrong),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _wishlist.isEmpty
              ? const EmptyState(message: "Your wishlist is empty.")
              : RefreshIndicator(
                  onRefresh: _refreshWishlist,
                  child: ListView.builder(
                    itemCount: _wishlist.length,
                    itemBuilder: (context, index) {
                      final house = _wishlist[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration:
                                  const Duration(milliseconds: 500),
                              reverseTransitionDuration:
                                  const Duration(milliseconds: 400),
                              pageBuilder: (_, animation, __) =>
                                  DetailScreen(house: house),
                              transitionsBuilder: (_, animation, __, child) =>
                                  FadeTransition(
                                opacity: animation,
                                child: child,
                              ),
                            ),
                          );
                        },
                        child: Hero(
                          tag: 'house-image-${house.id}',
                          child: HouseCard(
                            house: house,
                            distance: house.distance,
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
