import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:torva/models/treasure_model.dart';

class TreasureDetailScreen extends StatefulWidget {
  final Treasure treasure;

  const TreasureDetailScreen({super.key, required this.treasure});

  @override
  State<TreasureDetailScreen> createState() => _TreasureDetailScreenState();
}

class _TreasureDetailScreenState extends State<TreasureDetailScreen> {
  late GoogleMapController _mapController;
  late LatLng _treasureLocation;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    // Parse location string (assuming format is "latitude,longitude")
    final locationParts = widget.treasure.location.split(',');
    if (locationParts.length == 2) {
      try {
        double lat = double.parse(locationParts[0].trim());
        double lng = double.parse(locationParts[1].trim());
        _treasureLocation = LatLng(lat, lng);
      } catch (e) {
        // Fallback to a default location if parsing fails
        _treasureLocation = const LatLng(0, 0);
      }
    } else {
      _treasureLocation = const LatLng(0, 0);
    }

    // Create marker for treasure location
    _markers.add(
      Marker(
        markerId: MarkerId(widget.treasure.id),
        position: _treasureLocation,
        infoWindow: InfoWindow(
          title: widget.treasure.title,
          snippet: widget.treasure.description,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Map section (takes top half of screen)
          Expanded(
            flex: 1,
            child: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _treasureLocation,
                    zoom: 15,
                  ),
                  markers: _markers,
                  onMapCreated: (GoogleMapController controller) {
                    _mapController = controller;
                  },
                ),
                // Back button with transparent background
                Positioned(
                  top: 40,
                  left: 16,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Details section (takes bottom half of screen)
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and favorite button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            widget.treasure.title,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            widget.treasure.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color:
                                widget.treasure.isFavorite
                                    ? Colors.pink
                                    : Colors.grey,
                          ),
                          onPressed: () {
                            // Implement favorite toggle
                          },
                        ),
                      ],
                    ),

                    // Treasure ID
                    Text(
                      "#${widget.treasure.id.substring(0, 7).toUpperCase()}",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Rating stars
                    Row(
                      children: List.generate(
                        5,
                        (index) => Icon(
                          index < widget.treasure.difficultyLevel
                              ? Icons.star
                              : Icons.star_border,
                          color: const Color(0xFF7033FA),
                          size: 20,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Distance info
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          color: Colors.grey,
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "${widget.treasure.location}m Away",
                          style: TextStyle(
                            color: const Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.hiking_outlined,
                          color: Colors.grey,
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "Hint - ${widget.treasure.hint}",
                          style: TextStyle(
                            color: const Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Description
                    const Text(
                      "Description",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.treasure.description,
                      style: TextStyle(color: Colors.grey[700], height: 1.5),
                    ),

                    const SizedBox(height: 24),

                    // Navigate button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7033FA),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          // Launch navigation
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.navigation_outlined),
                            SizedBox(width: 8),
                            Text(
                              "Navigate",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
