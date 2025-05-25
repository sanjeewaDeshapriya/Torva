import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
  bool _isMapView = true;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
    });
  }

  // Create markers from treasures (synchronous version for build phase)
  Set<Marker> _createMarkersFromTreasuresSync(List<Treasure> treasures) {
    final markers = <Marker>{};

    for (int i = 0; i < treasures.length; i++) {
      final treasure = treasures[i];

      // Assuming your Treasure model has latitude and longitude fields
      // If not, you'll need to add them or parse from location string
      if (treasure.latitude != null && treasure.longitude != null) {
        markers.add(
          Marker(
            markerId: MarkerId(treasure.id),
            position: LatLng(treasure.latitude!, treasure.longitude!),
            infoWindow: InfoWindow(
              title: treasure.title,
              snippet: treasure.description,
              onTap: () => _navigateToTreasureDetail(treasure),
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              treasure.isFavorite
                  ? BitmapDescriptor.hueRed
                  : BitmapDescriptor.hueBlue,
            ),
            onTap: () => _showTreasureBottomSheet(treasure),
          ),
        );
      }
    }

    return markers;
  }

  // Create markers from treasures (async version for setState)
  void _createMarkersFromTreasures(List<Treasure> treasures) {
    _markers.clear();
    _markers = _createMarkersFromTreasuresSync(treasures);
    setState(() {});
  }

  // Show treasure details in bottom sheet when marker is tapped
  void _showTreasureBottomSheet(Treasure treasure) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            height: MediaQuery.of(context).size.height * 0.4,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Treasure title
                Text(
                  treasure.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),

                // Location
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.grey, size: 16),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        treasure.location,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Description
                Expanded(
                  child: Text(
                    treasure.description,
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          try {
                            await _treasureService.toggleFavoriteTreasure(
                              treasure.id,
                              treasure.isFavorite,
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Failed to update favorite status',
                                ),
                              ),
                            );
                          }
                        },
                        icon: Icon(
                          treasure.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: treasure.isFavorite ? Colors.red : Colors.grey,
                        ),
                        label: Text(
                          treasure.isFavorite ? 'Favorited' : 'Favorite',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[100],
                          foregroundColor: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _navigateToTreasureDetail(treasure);
                        },
                        icon: const Icon(Icons.explore),
                        label: const Text('Explore'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7033FA),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
    );
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
                          hintStyle: const TextStyle(color: Colors.black),
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
                        style: const TextStyle(color: Colors.black),
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

              // Treasure List/Map
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

                    // Create markers for map view (without setState)
                    if (!_isMapView) {
                      _createMarkersFromTreasuresSync(treasures);
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
                                  const SnackBar(
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
                      if (treasures.any(
                        (t) => t.latitude != null && t.longitude != null,
                      )) {
                        final mapMarkers = _createMarkersFromTreasuresSync(
                          treasures,
                        );
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: GoogleMap(
                            onMapCreated: (GoogleMapController controller) {
                              _mapController = controller;
                            },
                            initialCameraPosition: CameraPosition(
                              target:
                                  treasures.isNotEmpty &&
                                          treasures.first.latitude != null &&
                                          treasures.first.longitude != null
                                      ? LatLng(
                                        treasures.first.latitude!,
                                        treasures.first.longitude!,
                                      )
                                      : const LatLng(
                                        37.7749,
                                        -122.4194,
                                      ), // Default to SF
                              zoom: 12,
                            ),
                            markers: mapMarkers,
                            myLocationEnabled: true,
                            myLocationButtonEnabled: true,
                            zoomControlsEnabled: false,
                            mapType: MapType.normal,
                          ),
                        );
                      } else {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.location_off,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No Location Data Available',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Treasures need location coordinates to show on map',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[500],
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
