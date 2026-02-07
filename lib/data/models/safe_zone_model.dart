import 'package:cloud_firestore/cloud_firestore.dart';

class SafeZoneModel {
  final String id;
  final String name;
  final String? address;
  final double latitude;
  final double longitude;
  final double radius;
  final DateTime createdAt;

  SafeZoneModel({
    required this.id,
    required this.name,
    this.address,
    required this.latitude,
    required this.longitude,
    required this.radius,
    required this.createdAt,
  });

  factory SafeZoneModel.fromMap(Map<String, dynamic> map, String documentId) {
    return SafeZoneModel(
      id: documentId,
      name: map['name'] ?? '',
      address: map['address'],
      latitude: (map['location'] as GeoPoint).latitude,
      longitude: (map['location'] as GeoPoint).longitude,
      radius: (map['radius'] as num?)?.toDouble() ?? 500.0,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
      'location': GeoPoint(latitude, longitude),
      'radius': radius,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  SafeZoneModel copyWith({
    String? id,
    String? name,
    String? address,
    double? latitude,
    double? longitude,
    double? radius,
    DateTime? createdAt,
  }) {
    return SafeZoneModel(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      radius: radius ?? this.radius,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
