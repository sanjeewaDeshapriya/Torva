import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:torva/Services/treasure_service.dart';
import 'package:torva/models/treasure_model.dart';
import 'package:torva/screens/shared/MapLocationPicker.dart';

class AddTreasurePage extends StatefulWidget {
  const AddTreasurePage({super.key});

  @override
  AddTreasurePageState createState() => AddTreasurePageState();
}

class AddTreasurePageState extends State<AddTreasurePage> {
  final _formKey = GlobalKey<FormState>();
  int selectedDifficulty = 1;
  File? _image;
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();
  final TreasureService _treasureService = TreasureService();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _hintController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _codeController =
      TextEditingController(); // New controller for code

  String _selectedAddress = '';
  double? _selectedLatitude;
  double? _selectedLongitude;

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _hintController.dispose();
    _descriptionController.dispose();
    _codeController.dispose(); // Dispose code controller
    super.dispose();
  }

  Future<void> _pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _takePhoto() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _openMapPicker(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => MapLocationPicker(
              onLocationSelected: (address, latitude, longitude) {
                setState(() {
                  _selectedAddress = address;
                  _selectedLatitude = latitude;
                  _selectedLongitude = longitude;
                  _locationController.text = address;
                });
              },
            ),
      ),
    );
  }

  Future<void> _saveTreasure() async {
    if (_formKey.currentState!.validate()) {
      try {
        setState(() {
          _isLoading = true;
        });

        // Upload image if selected
        List<String> photoUrls = [];
        if (_image != null) {
          String url = await _treasureService.uploadImage(_image!);
          photoUrls.add(url);
        }

        // Create treasure object with location coordinates and code
        final treasure = Treasure(
          title: _titleController.text,
          location: _locationController.text,
          hint: _hintController.text,
          difficultyLevel: selectedDifficulty,
          photoUrls: photoUrls,
          description: _descriptionController.text,
          latitude: _selectedLatitude,
          longitude: _selectedLongitude,
          code:
              _codeController.text.isNotEmpty
                  ? _codeController.text
                  : null, // Add code
        );

        // Save to Firebase
        await _treasureService.addTreasure(treasure);
        Navigator.pushReplacementNamed(context, '/homepage');

        // Rest of your existing code
      } catch (e) {
        // Error handling code
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Treasure',
          style: TextStyle(
            color: Color(0xFF7033FA),
            fontWeight: FontWeight.bold,
            fontSize: 28.0,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF7033FA)),
          onPressed: () => Navigator.pushNamed(context, '/homepage'),
        ),
        backgroundColor: const Color(0xFFF2F2F2),
      ),
      backgroundColor: const Color(0xFFF2F2F2),
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildFormField(
                    label: 'Title',
                    hint: 'Treasure of Cortés',
                    controller: _titleController,
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? 'Please enter a title'
                                : null,
                  ),
                  const SizedBox(height: 30),
                  buildLocationField(),
                  const SizedBox(height: 30),
                  buildFormField(
                    label: 'Hint',
                    hint: 'Enter a hint',
                    controller: _hintController,
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? 'Please enter a hint'
                                : null,
                  ),
                  const SizedBox(height: 30),
                  // Add code field
                  buildFormField(
                    label: 'Secret Code (Optional)',
                    hint: 'Enter a secret code for this treasure',
                    controller: _codeController,
                    validator:
                        (value) => null, // Optional field, no validation needed
                  ),
                  const SizedBox(height: 30),
                  buildDifficultySelector(),
                  const SizedBox(height: 30),
                  buildPhotoUploader(),
                  const SizedBox(height: 30),
                  buildDescriptionField(),
                  const SizedBox(height: 32),
                  buildActionButtons(context),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(color: Color(0xFF7033FA)),
              ),
            ),
        ],
      ),
    );
  }

  Widget buildFormField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required String? Function(String?) validator,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          style: const TextStyle(color: Colors.black),
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
            filled: true,
            fillColor: Colors.white,
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: const BorderSide(color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildLocationField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Location',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _locationController,
          style: const TextStyle(color: Colors.black),
          readOnly: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select a location';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: 'Tap to select location',
            suffixIcon: IconButton(
              icon: const Icon(
                Icons.location_on_outlined,
                color: Color(0xFF7033FA),
              ),
              onPressed: () => _openMapPicker(context),
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
            filled: true,
            fillColor: Colors.white,
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: const BorderSide(color: Colors.red),
            ),
          ),
          onTap: () => _openMapPicker(context),
        ),
        if (_selectedLatitude != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'Coordinates: ${_selectedLatitude!.toStringAsFixed(5)}, ${_selectedLongitude!.toStringAsFixed(5)}',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ),
      ],
    );
  }

  Widget buildDifficultySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Difficulty Level',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            ...List.generate(5, (index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedDifficulty = index + 1;
                  });
                },
                child: Icon(
                  Icons.local_fire_department,
                  size: 40,
                  color:
                      index < selectedDifficulty
                          ? const Color(0xFF7033FA)
                          : Colors.grey.shade400,
                ),
              );
            }),
            const SizedBox(width: 20),
            Text(
              getDifficultyText(selectedDifficulty),
              style: const TextStyle(
                color: Color(0xFF7033FA),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  String getDifficultyText(int level) {
    switch (level) {
      case 1:
        return 'Easy';
      case 2:
        return 'Medium';
      case 3:
        return 'Hard';
      case 4:
        return 'Very Hard';
      case 5:
        return 'Extreme';
      default:
        return 'Easy';
    }
  }

  Widget buildPhotoUploader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Add Photos',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _pickImageFromGallery,
          child: Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.grey),
              color: Colors.white,
            ),
            child:
                _image == null
                    ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.image, size: 30, color: Colors.grey),
                        SizedBox(height: 4),
                        Text(
                          'Select File',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    )
                    : ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Image.file(
                        _image!,
                        width: double.infinity,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: const [
            Expanded(child: Divider(color: Colors.black)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text('or', style: TextStyle(fontSize: 12)),
            ),
            Expanded(child: Divider(color: Colors.black)),
          ],
        ),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: _takePhoto,
          icon: const Icon(Icons.camera_alt, color: Color(0xFF7033FA)),
          label: const Text(
            'Open Camera & Take Photo',
            style: TextStyle(color: Color(0xFF7033FA)),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF2F2F2),
            foregroundColor: const Color(0xFF7033FA),
            side: const BorderSide(color: Color(0xFF7033FA)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
        ),
      ],
    );
  }

  Widget buildDescriptionField() {
    return buildFormField(
      label: 'Description',
      hint: 'Enter description here...',
      controller: _descriptionController,
      maxLines: 5,
      validator:
          (value) =>
              value == null || value.isEmpty
                  ? 'Please enter a description'
                  : null,
    );
  }

  Widget buildActionButtons(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _saveTreasure,
        child: const Text(
          'Save Treasure',
          style: TextStyle(color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF7033FA),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
}
