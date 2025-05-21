import 'package:cloud_firestore/cloud_firestore.dart';

class Treasure {
  final String id;
  final String title;
  final String location;
  final String hint;
  final int difficultyLevel;
  final List<String> photoUrls;
  final String description;
  final DateTime createdAt;
  final bool isFavorite;
  final double? latitude;
  final double? longitude;
  final String? code;

  Treasure({
    this.id = '',
    required this.title,
    required this.location,
    required this.hint,
    required this.difficultyLevel,
    this.photoUrls = const [],
    required this.description,
    DateTime? createdAt,
    this.isFavorite = false,
    this.latitude,
    this.longitude,
    this.code,
  }) : createdAt = createdAt ?? DateTime.now();

  // Convert Treasure to a Map for storing in Firebase
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'location': location,
      'hint': hint,
      'difficultyLevel': difficultyLevel,
      'photoUrls': photoUrls,
      'description': description,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'isFavorite': isFavorite,
      'latitude': latitude,
      'longitude': longitude,
      'code': code,
    };
  }

  // Create a Treasure from a Map (when getting data from Firebase)
  factory Treasure.fromMap(String id, Map<String, dynamic> map) {
    return Treasure(
      id: id,
      title: map['title'] ?? '',
      location: map['location'] ?? '',
      hint: map['hint'] ?? '',
      difficultyLevel: map['difficultyLevel'] ?? 1,
      photoUrls: List<String>.from(map['photoUrls'] ?? []),
      description: map['description'] ?? '',
      latitude: map['latitude']?.toDouble(),
      longitude: map['longitude']?.toDouble(),
      createdAt:
          map['createdAt'] != null
              ? ((map['createdAt'] is Timestamp)
                  ? (map['createdAt'] as Timestamp).toDate()
                  : DateTime.fromMillisecondsSinceEpoch(map['createdAt']))
              : DateTime.now(),
      isFavorite: map['isFavorite'] ?? false,
      code: map['code'],
    );
  }

  // Create a copy of this Treasure with the given fields replaced with new values
  Treasure copyWith({
    String? id,
    String? title,
    String? location,
    String? hint,
    int? difficultyLevel,
    List<String>? photoUrls,
    String? description,
    DateTime? createdAt,
    bool? isFavorite,
   
  }) {
    return Treasure(
      id: id ?? this.id,
      title: title ?? this.title,
      location: location ?? this.location,
      hint: hint ?? this.hint,
      difficultyLevel: difficultyLevel ?? this.difficultyLevel,
      photoUrls: photoUrls ?? this.photoUrls,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      isFavorite: isFavorite ?? this.isFavorite,
      
    );
  }
}
