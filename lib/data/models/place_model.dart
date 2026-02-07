import 'package:cloud_firestore/cloud_firestore.dart';

class PlaceModel {
  final String id;
  final String name;
  final String description;
  final String category;
  final double latitude;
  final double longitude;
  final double safetyRating;
  final List<String> images;

  PlaceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.latitude,
    required this.longitude,
    required this.safetyRating,
    required this.images,
  });

  factory PlaceModel.fromMap(Map<String, dynamic> map, String documentId) {
    return PlaceModel(
      id: documentId,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? 'General',
      latitude: (map['location'] as GeoPoint).latitude,
      longitude: (map['location'] as GeoPoint).longitude,
      safetyRating: (map['safetyRating'] as num?)?.toDouble() ?? 0.0,
      images: map['images'] != null ? List<String>.from(map['images']) : [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'category': category,
      'location': GeoPoint(latitude, longitude),
      'safetyRating': safetyRating,
      'images': images,
    };
  }
}
