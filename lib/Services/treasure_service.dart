import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:torva/models/treasure_model.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as path;

class TreasureService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final String _collectionName = 'treasures';
  final Uuid _uuid = Uuid();

  // Add a new treasure to Firestore
  Future<String> addTreasure(Treasure treasure) async {
    try {
      final docRef = await _firestore
          .collection(_collectionName)
          .add(treasure.toMap());
      return docRef.id;
    } catch (e) {
      print('Error adding treasure: $e');
      rethrow;
    }
  }

  // Upload an image to Firebase Storage and get its download URL
  Future<String> uploadImage(File imageFile) async {
    try {
      final fileName = '${_uuid.v4()}${path.extension(imageFile.path)}';
      final storageRef = _storage.ref().child('treasure_images/$fileName');

      // Upload the file
      final uploadTask = storageRef.putFile(imageFile);
      await uploadTask.whenComplete(() => null);

      // Get download URL
      final downloadUrl = await storageRef.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      rethrow;
    }
  }

  // Upload multiple images and return list of download URLs
  Future<List<String>> uploadImages(List<File> imageFiles) async {
    List<String> downloadUrls = [];

    for (var imageFile in imageFiles) {
      final url = await uploadImage(imageFile);
      downloadUrls.add(url);
    }

    return downloadUrls;
  }

  // Get all treasures from Firestore
  Stream<List<Treasure>> getTreasures() {
    return _firestore
        .collection(_collectionName)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return Treasure.fromMap(doc.id, doc.data());
          }).toList();
        });
  }

  // Get a specific treasure by ID
  Future<Treasure?> getTreasureById(String id) async {
    try {
      final doc = await _firestore.collection(_collectionName).doc(id).get();

      if (doc.exists) {
        return Treasure.fromMap(doc.id, doc.data()!);
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting treasure: $e');
      rethrow;
    }
  }

  // Update an existing treasure
  Future<void> updateTreasure(String id, Treasure treasure) async {
    try {
      await _firestore
          .collection(_collectionName)
          .doc(id)
          .update(treasure.toMap());
    } catch (e) {
      print('Error updating treasure: $e');
      rethrow;
    }
  }

  // Delete a treasure and its images
  Future<void> deleteTreasure(Treasure treasure) async {
    try {
      // Delete the document
      await _firestore.collection(_collectionName).doc(treasure.id).delete();

      // Delete associated images
      for (String photoUrl in treasure.photoUrls) {
        try {
          // Extract file path from URL and delete
          final ref = _storage.refFromURL(photoUrl);
          await ref.delete();
        } catch (e) {
          print('Error deleting image: $e');
          // Continue with other deletions even if one fails
        }
      }
    } catch (e) {
      print('Error deleting treasure: $e');
      rethrow;
    }
  }

  // Query treasures by location
  Stream<List<Treasure>> getTreasuresByLocation(String location) {
    return _firestore
        .collection(_collectionName)
        .where('location', isEqualTo: location)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return Treasure.fromMap(doc.id, doc.data());
          }).toList();
        });
  }

  // Query treasures by difficulty level
  Stream<List<Treasure>> getTreasuresByDifficulty(int difficultyLevel) {
    return _firestore
        .collection(_collectionName)
        .where('difficultyLevel', isEqualTo: difficultyLevel)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return Treasure.fromMap(doc.id, doc.data());
          }).toList();
        });
  }

  Future<void> toggleFavoriteTreasure(
    String treasureId,
    bool currentFavoriteStatus,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection('treasures')
          .doc(treasureId)
          .update({'isFavorite': !currentFavoriteStatus});
    } catch (e) {
      print('Error toggling favorite status: $e');
      throw e; // Re-throw to allow handling in the UI
    }
  }

  Stream<List<Treasure>> getFavoriteTreasures() {
    return FirebaseFirestore.instance
        .collection('treasures')
        .where('isFavorite', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return Treasure.fromMap(doc.id, doc.data());
          }).toList();
        });
  }

  Stream<List<Treasure>> searchTreasures(String query) {
    // Convert query to lowercase for case-insensitive search
    query = query.toLowerCase();

    // If query is empty, return all treasures
    if (query.isEmpty) {
      return getTreasures();
    }

    // Search by title, description, or location
    // Note: This uses basic string contains operators, which is not optimal for large datasets
    // For production, consider implementing a more advanced search solution
    return FirebaseFirestore.instance
        .collection('treasures')
        .orderBy('title')
        .startAt([query])
        .endAt(
          ['$query\uf8ff'],
        ) // \uf8ff is a high code point to match all characters starting with query
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return Treasure.fromMap(doc.id, doc.data());
          }).toList();
        });
  }
}
