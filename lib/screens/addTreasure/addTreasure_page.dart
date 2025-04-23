import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:torva/Services/treasure_service.dart';
import 'package:torva/models/treasure_model.dart';

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

  // Form controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _hintController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    // Dispose controllers when widget is disposed
    _titleController.dispose();
    _locationController.dispose();
    _hintController.dispose();
    _descriptionController.dispose();
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

        print('Title: ${_titleController.text}');
        print('Location: ${_locationController.text}');
        print('Hint: ${_hintController.text}');
        print('Difficulty Level: $selectedDifficulty');
        print('Photo URLs: $photoUrls');
        print('Description: ${_descriptionController.text}');

        // Create treasure object
        final treasure = Treasure(
          title: _titleController.text,
          location: _locationController.text,
          hint: _hintController.text,
          difficultyLevel: selectedDifficulty,
          photoUrls: photoUrls,
          description: _descriptionController.text,
        );

        // Save to Firebase
        await _treasureService.addTreasure(treasure);

        setState(() {
          _isLoading = false;
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Treasure added successfully!')),
        );

        // Navigate back
        Navigator.pop(context);
      } catch (e) {
        setState(() {
          _isLoading = false;
        });

        // Show error message
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
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
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Color(0xFFF2F2F2),
      ),
      backgroundColor: Color(0xFFF2F2F2),
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  buildLocationField(),
                  const SizedBox(height: 30),
                  buildFormField(
                    label: 'Hint',
                    hint: 'Treasure of Cortés',
                    controller: _hintController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a hint';
                      }
                      return null;
                    },
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

  // Form Field
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
          style: TextStyle(color: Colors.black),
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
            filled: true,
            fillColor: Colors.white,
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }

  // Location Field
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
          style: TextStyle(color: Colors.black),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a location';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: 'Colombo 07, Sri Lanka',
            suffixIcon: const Icon(
              Icons.location_on_outlined,
              color: Color(0xFF7033FA),
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
            filled: true,
            fillColor: Colors.white,
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }

  // Difficulty Selector
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
          mainAxisAlignment: MainAxisAlignment.start,
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
            const SizedBox(width: 105),
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

  // Get Difficulty Text
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

  // Photo Uploader
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
                        Icon(
                          Icons.image,
                          size: 30,
                          color: Color.fromARGB(255, 99, 98, 98),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Select File',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: Divider(color: Colors.black, thickness: 1)),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'or',
                style: TextStyle(color: Colors.black, fontSize: 12),
              ),
            ),
            Expanded(child: Divider(color: Colors.black, thickness: 1)),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _takePhoto,
            icon: Container(
              child: const Icon(Icons.camera_alt, color: Color(0xFF7033FA)),
            ),
            label: const Text(
              'Open Camera & Take Photo',
              style: TextStyle(color: Color(0xFF7033FA)),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFF2F2F2),
              foregroundColor: Color(0xFF7033FA),
              side: const BorderSide(color: Color(0xFF7033FA), width: 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            ),
          ),
        ),
      ],
    );
  }

  // Description Field
  Widget buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Description',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _descriptionController,
          style: TextStyle(color: Colors.black),
          maxLines: 5,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a description';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: 'Enter description here...',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
            filled: true,
            fillColor: Colors.white,
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }

  // Action Buttons
  Widget buildActionButtons(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 244, 243, 245),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: _isLoading ? null : _saveTreasure,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF7033FA),
                disabledBackgroundColor: Color(0xFF7033FA).withOpacity(0.5),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: const Text(
                  'Save',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
