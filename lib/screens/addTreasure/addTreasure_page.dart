import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class AddTreasurePage extends StatefulWidget {
  const AddTreasurePage({super.key});

  @override
  AddTreasurePageState createState() => AddTreasurePageState();
}

class AddTreasurePageState extends State<AddTreasurePage> {
  int selectedDifficulty = 1;
  File? _image;
  final ImagePicker _picker = ImagePicker();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // APP Bar
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildTextField('Title', 'Treasure of Cortés'),
            const SizedBox(height: 30),
            buildLocationField(),
            const SizedBox(height: 30),
            buildTextField('Hint', 'Treasure of Cortés'),
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
    );
  }

  // Text Field

  Widget buildTextField(String label, String hint) {
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
        TextField(
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
            filled: true,
            fillColor: Colors.white,
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
        TextField(
          decoration: InputDecoration(
            hintText: 'Colombo 07, Sri Lanka',
            suffixIcon: const Icon(
              Icons.location_on_outlined,
              color: Color(0xFF7033FA),
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
            filled: true,
            fillColor: Colors.white,
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
            child: _image == null ?
            Column(
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
        TextField(
          maxLines: 5,
          decoration: InputDecoration(
            hintText: 'Enter description here...',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
            filled: true,
            fillColor: Colors.white,
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
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF7033FA),
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
