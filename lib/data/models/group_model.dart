import 'package:cloud_firestore/cloud_firestore.dart';

class GroupModel {
  final String groupId;
  final String groupName;
  final String description;
  final int totalMembers;
  final String category;
  final DateTime createdAt;

  GroupModel({
    required this.groupId,
    required this.groupName,
    required this.description,
    this.totalMembers = 0,
    required this.category,
    required this.createdAt,
  });

  factory GroupModel.fromMap(Map<String, dynamic> map, String documentId) {
    return GroupModel(
      groupId: documentId,
      groupName: map['groupName'] ?? '',
      description: map['description'] ?? '',
      totalMembers: map['totalMembers'] ?? 0,
      category: map['category'] ?? 'General',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'groupName': groupName,
      'description': description,
      'totalMembers': totalMembers,
      'category': category,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
