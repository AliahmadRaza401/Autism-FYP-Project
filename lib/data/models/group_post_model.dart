import 'package:cloud_firestore/cloud_firestore.dart';

class GroupPostModel {
  final String postId;
  final String groupId;
  final String userId;
  final String content;
  final String? imageUrl;
  final int likeCount;
  final int commentCount;
  final DateTime timestamp;

  GroupPostModel({
    required this.postId,
    required this.groupId,
    required this.userId,
    required this.content,
    this.imageUrl,
    this.likeCount = 0,
    this.commentCount = 0,
    required this.timestamp,
  });

  factory GroupPostModel.fromMap(Map<String, dynamic> map, String documentId) {
    return GroupPostModel(
      postId: documentId,
      groupId: map['groupId'] ?? '',
      userId: map['userId'] ?? '',
      content: map['content'] ?? '',
      imageUrl: map['imageUrl'],
      likeCount: map['likeCount'] ?? 0,
      commentCount: map['commentCount'] ?? 0,
      timestamp: (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'groupId': groupId,
      'userId': userId,
      'content': content,
      'imageUrl': imageUrl,
      'likeCount': likeCount,
      'commentCount': commentCount,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}
