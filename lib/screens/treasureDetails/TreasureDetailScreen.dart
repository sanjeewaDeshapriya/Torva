import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:torva/models/treasure_model.dart';
// You might need to import services for distance calculation if you want the "m Away" part
// import 'package:torva/Services/location_service.dart'; // Example import

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

    // --- THIS IS THE MODIFIED PART ---
    // Use latitude and longitude directly from the Treasure model
    if (widget.treasure.latitude != null && widget.treasure.longitude != null) {
      _treasureLocation = LatLng(widget.treasure.latitude!, widget.treasure.longitude!);
    } else {
      // Handle cases where lat/lng might be missing (shouldn't happen if AddTreasurePage validation is correct)
      // You might want to show an error or navigate back in a real app
      print('Error: Treasure ${widget.treasure.id} has missing latitude or longitude.');
      _treasureLocation = const LatLng(0, 0); // Default to a fallback location
       WidgetsBinding.instance.addPostFrameCallback((_) {
         ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(content: Text('Treasure location data is missing.')),
         );
       });
    }


    // Create marker for treasure location using the obtained LatLng
    if (_treasureLocation.latitude != 0 || _treasureLocation.longitude != 0) { // Only add marker if location is not the default fallback
      _markers.add(
        Marker(
          markerId: MarkerId(widget.treasure.id),
          position: _treasureLocation, // Position the marker using LatLng
          infoWindow: InfoWindow(
            title: widget.treasure.title,
            snippet: widget.treasure.location, // Show the address in the info window
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
        ),
      );
    }
     // --- END OF MODIFIED PART ---
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
                  // Set the initial camera position using the obtained LatLng
                  initialCameraPosition: CameraPosition(
                    target: _treasureLocation,
                    zoom: 15,
                  ),
                  markers: _markers,
                  onMapCreated: (GoogleMapController controller) {
                    _mapController = controller;
                  },
                  // Disable map interactions if location data is missing
                  // zoomGesturesEnabled: (_treasureLocation.latitude != 0 || _treasureLocation.longitude != 0),
                  // scrollGesturesEnabled: (_treasureLocation.latitude != 0 || _treasureLocation.longitude != 0),
                  // tiltGesturesEnabled: (_treasureLocation.latitude != 0 || _treasureLocation.longitude != 0),
                  // rotateGesturesEnabled: (_treasureLocation.latitude != 0 || _treasureLocation.longitude != 0),
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

                    // Location Address info (using the location string)
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          color: Colors.grey,
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        // Display the location string (address from picker)
                        Expanded( // Use Expanded to prevent overflow
                          child: Text(
                            widget.treasure.location,
                            style: const TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                            overflow: TextOverflow.ellipsis, // Handle long addresses
                          ),
                        ),
                         // If you want to display distance, you'd calculate it here
                         // const SizedBox(width: 8),
                         // Text("(${calculateDistance()}m Away)") // Example
                      ],
                    ),
                    SizedBox(height: 8),
                    // Coordinates info (optional, but helpful for debugging)
                    if (widget.treasure.latitude != null && widget.treasure.longitude != null)
                      Row(
                        children: [
                          const Icon(
                            Icons.gps_fixed,
                            color: Colors.grey,
                            size: 18,
                          ),
                          const SizedBox(width: 4),
                           Text(
                            'Lat: ${widget.treasure.latitude!.toStringAsFixed(5)}, Lng: ${widget.treasure.longitude!.toStringAsFixed(5)}',
                             style: TextStyle(color: Colors.grey[600], fontSize: 12),
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
                        Expanded( // Use Expanded to prevent overflow
                          child: Text(
                            "Hint - ${widget.treasure.hint}",
                            style: const TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                            overflow: TextOverflow.ellipsis, // Handle long hints
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