import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:torva/models/user.dart';
import 'package:uuid/uuid.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final String _collectionName = 'users';
  final Uuid _uuid = Uuid();

  // Add a new user to Firestore
  Future<String> addUser(UserModel user) async {
    try {
      final docRef = await _firestore
          .collection(_collectionName)
          .add(user.toMap());
      return docRef.id;
    } catch (e) {
      print('Error adding user: $e');
      rethrow;
    }
  }

  // Get current logged in user
  Future<UserModel?> getCurrentUser() async {
    try {
      // Get current Firebase Auth user
      auth.User? currentUser = auth.FirebaseAuth.instance.currentUser;
      
      if (currentUser == null) {
        return null;
      }
      
      // Get user details from Firestore by email
      return await getUserByEmail(currentUser.email!);
    } catch (e) {
      print('Error getting current user: $e');
      return null;
    }
  }

  // Get user by email
  Future<UserModel?> getUserByEmail(String email) async {
    try {
      // Query Firestore for the user with matching email
      final querySnapshot = await _firestore
          .collection(_collectionName)
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return null;
      }

      // Convert the document to a UserModel
      final doc = querySnapshot.docs.first;
      return UserModel.fromFirestore(doc);
    } catch (e) {
      print('Error getting user by email: $e');
      return null;
    }
  }

  // Update user data
  Future<void> updateUser(UserModel user) async {
    try {
      // Get current user document ID from Firestore
      final querySnapshot = await _firestore
          .collection(_collectionName)
          .where('email', isEqualTo: user.email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception('User not found');
      }

      String docId = querySnapshot.docs.first.id;

      // Update user data in Firestore
      await _firestore
          .collection(_collectionName)
          .doc(docId)
          .update(user.toMap());

    } catch (e) {
      print('Error updating user: $e');
      rethrow;
    }
  }

  // Upload user profile image
  Future<String> uploadProfileImage(String filePath) async {
    try {
      final String fileName = '${_uuid.v4()}.jpg';
      final Reference storageRef = _storage.ref().child('profile_images/$fileName');
      
      // Upload file to Firebase Storage
      await storageRef.putFile(File(filePath));
      
      // Get download URL
      final String downloadUrl = await storageRef.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading profile image: $e');
      rethrow;
    }
  }

  // Get all users
  Stream<List<UserModel>> getUsers() {
    return _firestore
        .collection(_collectionName)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return UserModel.fromFirestore(doc);
          }).toList();
        });
  }
}