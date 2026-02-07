import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String id;
  final String authorId;
  final String authorName;
  final String? authorImage;
  final String content;
  final List<String> images;
  final DateTime createdAt;
  final List<String> likes;
  final int commentCount;

  PostModel({
    required this.id,
    required this.authorId,
    required this.authorName,
    this.authorImage,
    required this.content,
    required this.images,
    required this.createdAt,
    required this.likes,
    this.commentCount = 0,
  });

  factory PostModel.fromMap(Map<String, dynamic> map, String documentId) {
    return PostModel(
      id: documentId,
      authorId: map['authorId'] ?? '',
      authorName: map['authorName'] ?? 'Anonymous',
      authorImage: map['authorImage'],
      content: map['content'] ?? '',
      images: map['images'] != null ? List<String>.from(map['images']) : [],
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      likes: map['likes'] != null ? List<String>.from(map['likes']) : [],
      commentCount: map['commentCount'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'authorId': authorId,
      'authorName': authorName,
      'authorImage': authorImage,
      'content': content,
      'images': images,
      'createdAt': Timestamp.fromDate(createdAt),
      'likes': likes,
      'commentCount': commentCount,
    };
  }
}
