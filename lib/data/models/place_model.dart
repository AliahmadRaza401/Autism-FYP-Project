import 'package:cloud_firestore/cloud_firestore.dart';

class PlaceModel {
  final String id;
  final String name;
  final String description;
  final String category;
  final GeoPoint location;
  final String? address;
  final bool staffFriendly;
  final bool quietAvailable;
  final Map<String, double> sensoryRatings;
  final double overallRating;
  final int reviewCount;
  final List<String> images;

  PlaceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.location,
    this.address,
    this.staffFriendly = false,
    this.quietAvailable = false,
    this.sensoryRatings = const {},
    this.overallRating = 0.0,
    this.reviewCount = 0,
    required this.images,
  });

  factory PlaceModel.fromMap(Map<String, dynamic> map, String documentId) {
    return PlaceModel(
      id: documentId,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? 'General',
      location: map['location'] as GeoPoint? ?? const GeoPoint(0, 0),
      address: map['address'],
      staffFriendly: map['staffFriendly'] ?? false,
      quietAvailable: map['quietAvailable'] ?? false,
      sensoryRatings: Map<String, double>.from(map['sensoryRatings'] ?? {}),
      overallRating: (map['overallRating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: map['reviewCount'] ?? 0,
      images: map['images'] != null ? List<String>.from(map['images']) : [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'category': category,
      'location': location,
      'address': address,
      'staffFriendly': staffFriendly,
      'quietAvailable': quietAvailable,
      'sensoryRatings': sensoryRatings,
      'overallRating': overallRating,
      'reviewCount': reviewCount,
      'images': images,
    };
  }
}
