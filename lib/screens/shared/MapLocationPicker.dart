// Add to pubspec.yaml dependencies:
// Maps_flutter: ^2.5.0
// geolocator: ^10.1.0
// geocoding: ^2.1.1

import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapLocationPicker extends StatefulWidget {
  final Function(String address, double latitude, double longitude)
  onLocationSelected;

  const MapLocationPicker({super.key, required this.onLocationSelected});

  @override
  MapLocationPickerState createState() => MapLocationPickerState();
}

class MapLocationPickerState extends State<MapLocationPicker> {
  GoogleMapController? _mapController;
  LatLng? _selectedLocation;
  LatLng? _currentLocation;
  bool _isLoading = true;
  String _currentAddress = '';
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Use a default location if permission is denied
          _setDefaultLocation();
          // Optionally show a message to the user
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Location permission denied. Using default location.',
                ),
              ),
            );
          }
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Use a default location if permission is permanently denied
        _setDefaultLocation();
        // Optionally show a message to the user
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Location permission permanently denied. Using default location.',
              ),
            ),
          );
        }
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Update state with current location
      if (mounted) {
        setState(() {
          _currentLocation = LatLng(position.latitude, position.longitude);
          _selectedLocation = _currentLocation;
          _isLoading = false;
          _updateMarker(_selectedLocation!);
        });

        // Get address for the current location
        _getAddressFromLatLng(_selectedLocation!);
      }
    } catch (e) {
      print('Error getting location: $e');
      _setDefaultLocation();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not get current location: ${e.toString()}'),
          ),
        );
      }
    }
  }

  void _setDefaultLocation() {
    // Default to a central location (e.g., Colombo, Sri Lanka)
    if (mounted) {
      setState(() {
        _currentLocation = const LatLng(6.9271, 79.8612); // Colombo coordinates
        _selectedLocation = _currentLocation;
        _isLoading = false;
        _updateMarker(_selectedLocation!);
      });
      _getAddressFromLatLng(
        _selectedLocation!,
      ); // Get address for the default location
    }
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty && mounted) {
        Placemark place = placemarks[0];
        setState(() {
          // Construct a readable address string
          _currentAddress = [
            place.street,
            place.subLocality,
            place.locality,
            place.administrativeArea,
            place.country,
          ].where((item) => item != null && item.isNotEmpty).join(', ');
        });
        // Update marker info window with the new address
        _updateMarker(_selectedLocation!);
      } else if (mounted) {
        setState(() {
          _currentAddress = 'Address not found';
        });
        _updateMarker(_selectedLocation!);
      }
    } catch (e) {
      print('Error getting address: $e');
      if (mounted) {
        setState(() {
          _currentAddress = 'Could not get address';
        });
        _updateMarker(_selectedLocation!);
      }
    }
  }

  void _updateMarker(LatLng position) {
    if (mounted) {
      setState(() {
        _markers = {
          Marker(
            markerId: const MarkerId('selectedLocation'),
            position: position,
            // Use the _currentAddress for the InfoWindow snippet
            infoWindow: InfoWindow(
              title: 'Selected Location',
              snippet: _currentAddress,
            ),
          ),
        };
      });
    }
  }

  void _onMapTap(LatLng position) {
    setState(() {
      _selectedLocation = position;
      // No need to call _updateMarker here, as _getAddressFromLatLng calls it
      // _updateMarker(position);
    });
    _getAddressFromLatLng(
      position,
    ); // This will update the marker and address text
  }

  void _confirmLocation() {
    if (_selectedLocation != null && _currentAddress.isNotEmpty) {
      widget.onLocationSelected(
        _currentAddress, // Pass the formatted address
        _selectedLocation!.latitude,
        _selectedLocation!.longitude,
      );
      Navigator.pop(context);
    } else {
      // Inform the user if location or address is not ready
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a location on the map.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Select Location',
          style: TextStyle(
            color: Color(0xFF7033FA),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF7033FA)),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: const Color(0xFFF2F2F2),
      ),
      body: Stack(
        children: [
          _isLoading
              ? const Center(
                child: CircularProgressIndicator(color: Color(0xFF7033FA)),
              )
              : GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _currentLocation!,
                  zoom: 15,
                ),
                onMapCreated: (controller) {
                  _mapController = controller;
                },
                markers: _markers,
                onTap: _onMapTap,
                myLocationEnabled: true, // Blue dot for current location
                myLocationButtonEnabled:
                    true, // Button to center on current location
                zoomControlsEnabled: true, // Zoom in/out buttons
                mapType: MapType.normal,
                // The position of the zoom controls is fixed by the Google Maps SDK,
                // typically top-right.
              ),

          // Location info at bottom
          Positioned(
            bottom:
                100, // Adjust position to not overlap with the confirm button
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Selected Location:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    _currentAddress.isNotEmpty
                        ? _currentAddress
                        : 'Tap on the map to select a location',
                    style: const TextStyle(fontSize: 14),
                  ),
                  if (_selectedLocation != null) ...[
                    const SizedBox(height: 5),
                    Text(
                      'Coordinates: ${_selectedLocation!.latitude.toStringAsFixed(5)}, ${_selectedLocation!.longitude.toStringAsFixed(5)}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Confirm button
          Positioned(
            bottom: 20, // Position above the bottom edge
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed:
                  (_selectedLocation != null &&
                          _currentAddress.isNotEmpty &&
                          !_isLoading)
                      ? _confirmLocation
                      : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7033FA),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text(
                'Confirm Location',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
