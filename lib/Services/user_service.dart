import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:torva/models/user.dart';
import 'package:uuid/uuid.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final String _collectionName = 'users';
  final Uuid _uuid = Uuid();

  // Add a new treasure to Firestore
  Future<String> addUser(UserModel user) async {
    try {
      final docRef = await _firestore
          .collection(_collectionName)
          .add(user.toMap());
      return docRef.id;
    } catch (e) {
      print('Error adding treasure: $e');
      rethrow;
    }
  }

  Stream<List<UserModel>> getUser() {
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
}
