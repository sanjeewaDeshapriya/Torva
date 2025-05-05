import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String email;
  final String username;
  final int? points;
  final List<String>? finds;
  final List<String>? hides;
  final String? photoURL;
  final DateTime? createdAt;

  UserModel({
    required this.email,
    required this.username,
    this.points = 0,
    this.finds,
    this.hides,
    this.photoURL,
    this.createdAt,
  });

  // Factory constructor to create a UserModel from a Firestore document
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // Handle possible null or missing fields
    final List<dynamic> findsData = data['finds'] ?? [];
    final List<dynamic> hidesData = data['hides'] ?? [];

    return UserModel(
      email: data['email'] ?? '',
      username: data['username'] ?? '',
      points: data['points'] ?? 0,
      finds: findsData.map((item) => item.toString()).toList(),
      hides: hidesData.map((item) => item.toString()).toList(),
      photoURL: data['photoURL'],
      createdAt:
          data['createdAt'] != null
              ? (data['createdAt'] as Timestamp).toDate()
              : null,
    );
  }

  // Convert UserModel to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'username': username,
      'points': points,
      'finds': finds,
      'hides': hides,
      'photoURL': photoURL,
      'createdAt':
          createdAt != null
              ? Timestamp.fromDate(createdAt!)
              : FieldValue.serverTimestamp(),
    };
  }

  // Create a copy of the current user with updated fields
  UserModel copyWith({
    String? uid,
    String? email,
    String? username,
    int? points,
    List<String>? finds,
    List<String>? hides,
    String? photoURL,
    DateTime? createdAt,
  }) {
    return UserModel(
      email: email ?? this.email,
      username: username ?? this.username,
      points: points ?? this.points,
      finds: finds ?? this.finds,
      hides: hides ?? this.hides,
      photoURL: photoURL ?? this.photoURL,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
