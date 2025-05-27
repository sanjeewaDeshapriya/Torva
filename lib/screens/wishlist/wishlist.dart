import 'package:flutter/material.dart';
import 'package:torva/Services/treasure_service.dart';
import 'package:torva/models/treasure_model.dart';
import 'package:torva/screens/shared/TreasureCard.dart';
import 'package:torva/screens/shared/TreasureCardFav.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  final TreasureService _treasureService = TreasureService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Wishlist',
          style: TextStyle(
            color: Color(0xFF7033FA),
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: StreamBuilder<List<Treasure>>(
            // Use StreamBuilder to get real-time updates on favorite treasures
            stream: _treasureService.getFavoriteTreasures(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFF7033FA)),
                );
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              final treasures = snapshot.data ?? [];

              if (treasures.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.favorite_border,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No favorites yet',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Add treasures to your wishlist by tapping the heart icon',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                itemCount: treasures.length,
                itemBuilder: (context, index) {
                  final treasure = treasures[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Treasurecardfav(
                      treasure: treasure,
                      onFavoritePressed: () async {
                        try {
                          await _treasureService.toggleFavoriteTreasure(
                            treasure.id,
                            treasure.isFavorite,
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Failed to update favorite status'),
                            ),
                          );
                        }
                      },
                      onNavigatePressed: () {
                        // Navigate to treasure details or map
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
