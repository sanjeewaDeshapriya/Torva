import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:torva/Services/treasure_service.dart';
import 'package:torva/models/treasure_model.dart';
import 'package:torva/screens/shared/TreasureCard.dart';
import 'package:torva/screens/treasureDetails/TreasureDetailScreen.dart';


class TreasureListScreen extends StatefulWidget {
  const TreasureListScreen({super.key});

  @override
  State<TreasureListScreen> createState() => _TreasureListScreenState();
}

class _TreasureListScreenState extends State<TreasureListScreen> {
  final TreasureService _treasureService = TreasureService();
  bool _isMapView = false;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
    });
  }

  // Navigate to the treasure detail screen
  void _navigateToTreasureDetail(Treasure treasure) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TreasureDetailScreen(treasure: treasure),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Search Bar
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search for Treasures',
                          hintStyle: TextStyle(color: Colors.black),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                          suffixIcon:
                              _searchQuery.isNotEmpty
                                  ? IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                      _searchController.clear();
                                    },
                                  )
                                  : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16,
                          ),
                        ),
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF7033FA),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.chat_outlined,
                          color: Colors.white,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // View Toggle
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _isMapView = false;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color:
                                !_isMapView
                                    ? const Color.fromARGB(255, 162, 186, 231)
                                    : Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Center(
                            child: Text(
                              'Map',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _isMapView = true;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color:
                                _isMapView
                                    ? const Color.fromARGB(255, 162, 186, 231)
                                    : Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Center(
                            child: Text(
                              'List',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Treasure List
              Expanded(
                child: StreamBuilder<List<Treasure>>(
                  stream: _treasureService.getTreasures(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF7033FA),
                        ),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    final allTreasures = snapshot.data ?? [];

                    // Filter treasures based on search query
                    final treasures =
                        _searchQuery.isEmpty
                            ? allTreasures
                            : allTreasures.where((treasure) {
                              return treasure.title.toLowerCase().contains(
                                    _searchQuery,
                                  ) ||
                                  treasure.description.toLowerCase().contains(
                                    _searchQuery,
                                  ) ||
                                  treasure.location.toLowerCase().contains(
                                    _searchQuery,
                                  );
                            }).toList();

                    if (treasures.isEmpty && _searchQuery.isNotEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No treasures found',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Try a different search term',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    if (treasures.isEmpty) {
                      return const Center(child: Text('No treasures found'));
                    }

                    // Use either map or list view based on the toggle
                    if (_isMapView) {
                      // List view
                      return ListView.builder(
                        itemCount: treasures.length,
                        itemBuilder: (context, index) {
                          final treasure = treasures[index];
                          return TreasureCard(
                            treasure: treasure,
                            onFavoritePressed: () async {
                              try {
                                // Call the service method to update Firestore
                                await _treasureService.toggleFavoriteTreasure(
                                  treasure.id,
                                  treasure.isFavorite,
                                );
                              } catch (e) {
                                // Show error message to user
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Failed to update favorite status',
                                    ),
                                  ),
                                );
                              }
                            },
                            onNavigatePressed: () {
                              // Navigate to treasure details with map
                              _navigateToTreasureDetail(treasure);
                            },
                          );
                        },
                      );
                    } else {
                      // Map view implementation
                      // This would be implemented with Google Maps showing treasure locations
                      // For now, we'll show a placeholder that directs users to implement this
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.map,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Map View Coming Soon',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF7033FA),
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isMapView = true;
                                });
                              },
                              child: const Text('Switch to List View'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}