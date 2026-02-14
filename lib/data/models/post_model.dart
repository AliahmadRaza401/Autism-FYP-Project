import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String id;
  final String createdBy; // userId
  final String title;
  final String description;
  final String categoryId; // NEW: Category reference
  final String? authorName;
  final String? authorImage;
  final String? imageUrl;
  final GeoPoint? location;
  final String? address;
  final Map<String, double> sensoryRatings;
  final double overallRating;
  final List<String> categoryTags;
  final int likesCount;
  final int reviewCount;
  final int commentCount;
  final DateTime createdAt;

  PostModel({
    required this.id,
    required this.createdBy,
    required this.title,
    required this.description,
    required this.categoryId,
    this.authorName,
    this.authorImage,
    this.imageUrl,
    this.location,
    this.address,
    this.sensoryRatings = const {},
    this.overallRating = 0.0,
    this.categoryTags = const [],
    this.likesCount = 0,
    this.reviewCount = 0,
    this.commentCount = 0,
    required this.createdAt,
  });

  factory PostModel.fromMap(Map<String, dynamic> map, String documentId) {
    return PostModel(
      id: documentId,
      createdBy: map['createdBy'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      categoryId: map['categoryId'] ?? 'general',
      authorName: map['authorName'],
      authorImage: map['authorImage'],
      imageUrl: map['imageUrl'],
      location: map['location'] as GeoPoint?,
      address: map['address'],
      sensoryRatings: Map<String, double>.from(map['sensoryRatings'] ?? {}),
      overallRating: (map['overallRating'] as num?)?.toDouble() ?? 0.0,
      categoryTags: List<String>.from(map['categoryTags'] ?? []),
      likesCount: map['likesCount'] ?? 0,
      reviewCount: map['reviewCount'] ?? 0,
      commentCount: map['commentCount'] ?? 0,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'createdBy': createdBy,
      'title': title,
      'description': description,
      'categoryId': categoryId,
      'authorName': authorName,
      'authorImage': authorImage,
      'imageUrl': imageUrl,
      'location': location,
      'address': address,
      'sensoryRatings': sensoryRatings,
      'overallRating': overallRating,
      'categoryTags': categoryTags,
      'likesCount': likesCount,
      'reviewCount': reviewCount,
      'commentCount': commentCount,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
