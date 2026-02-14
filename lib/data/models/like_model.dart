import 'package:cloud_firestore/cloud_firestore.dart';

class LikeModel {
  final String userId;
  final String postId;
  final DateTime timestamp;

  LikeModel({
    required this.userId,
    required this.postId,
    required this.timestamp,
  });

  factory LikeModel.fromMap(Map<String, dynamic> map) {
    return LikeModel(
      userId: map['userId'] ?? '',
      postId: map['postId'] ?? '',
      timestamp: (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'postId': postId,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}
