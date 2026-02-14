import 'package:cloud_firestore/cloud_firestore.dart';

class ChildModel {
  final String childId;
  final String parentId;
  final String childName;
  final int age;
  final Map<String, int> sensoryPreferences;
  final List<String> savedPlaces;
  final String? notes;
  final DateTime createdAt;

  ChildModel({
    required this.childId,
    required this.parentId,
    required this.childName,
    required this.age,
    required this.sensoryPreferences,
    this.savedPlaces = const [],
    this.notes,
    required this.createdAt,
  });

  factory ChildModel.fromMap(Map<String, dynamic> map, String documentId) {
    return ChildModel(
      childId: documentId,
      parentId: map['parentId'] ?? '',
      childName: map['childName'] ?? '',
      age: map['age'] ?? 0,
      sensoryPreferences: Map<String, int>.from(map['sensoryPreferences'] ?? {}),
      savedPlaces: List<String>.from(map['savedPlaces'] ?? []),
      notes: map['notes'],
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'parentId': parentId,
      'childName': childName,
      'age': age,
      'sensoryPreferences': sensoryPreferences,
      'savedPlaces': savedPlaces,
      'notes': notes,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
