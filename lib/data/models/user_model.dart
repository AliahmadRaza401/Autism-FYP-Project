class UserModel {
  final String id;
  final String name;
  final String email;
  final String? profileImage;
  final String? childName;
  final DateTime? childDob;
  final String? diagnosis;
  final double? noiseSensitivity;
  final double? crowdSensitivity;
  final double? lightSensitivity;
  final String? preferredTextSize;
  final String? primaryChallenge;
  final List<String>? safeZones;
  final Map<String, dynamic>? childSafetySettings;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.profileImage,
    this.childName,
    this.childDob,
    this.diagnosis,
    this.noiseSensitivity,
    this.crowdSensitivity,
    this.lightSensitivity,
    this.preferredTextSize,
    this.primaryChallenge,
    this.safeZones,
    this.childSafetySettings,
    required this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String documentId) {
    return UserModel(
      id: documentId,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      profileImage: map['profileImage'],
      childName: map['childName'],
      childDob: map['childDob'] != null ? DateTime.fromMillisecondsSinceEpoch(map['childDob']) : null,
      diagnosis: map['diagnosis'],
      noiseSensitivity: (map['noiseSensitivity'] as num?)?.toDouble(),
      crowdSensitivity: (map['crowdSensitivity'] as num?)?.toDouble(),
      lightSensitivity: (map['lightSensitivity'] as num?)?.toDouble(),
      preferredTextSize: map['preferredTextSize'],
      primaryChallenge: map['primaryChallenge'],
      safeZones: map['safeZones'] != null ? List<String>.from(map['safeZones']) : null,
      childSafetySettings: map['childSafetySettings'],
      createdAt: map['createdAt'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'profileImage': profileImage,
      'childName': childName,
      'childDob': childDob?.millisecondsSinceEpoch,
      'diagnosis': diagnosis,
      'noiseSensitivity': noiseSensitivity,
      'crowdSensitivity': crowdSensitivity,
      'lightSensitivity': lightSensitivity,
      'preferredTextSize': preferredTextSize,
      'primaryChallenge': primaryChallenge,
      'safeZones': safeZones,
      'childSafetySettings': childSafetySettings,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? profileImage,
    String? childName,
    DateTime? childDob,
    String? diagnosis,
    double? noiseSensitivity,
    double? crowdSensitivity,
    double? lightSensitivity,
    String? preferredTextSize,
    String? primaryChallenge,
    List<String>? safeZones,
    Map<String, dynamic>? childSafetySettings,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      childName: childName ?? this.childName,
      childDob: childDob ?? this.childDob,
      diagnosis: diagnosis ?? this.diagnosis,
      noiseSensitivity: noiseSensitivity ?? this.noiseSensitivity,
      crowdSensitivity: crowdSensitivity ?? this.crowdSensitivity,
      lightSensitivity: lightSensitivity ?? this.lightSensitivity,
      preferredTextSize: preferredTextSize ?? this.preferredTextSize,
      primaryChallenge: primaryChallenge ?? this.primaryChallenge,
      safeZones: safeZones ?? this.safeZones,
      childSafetySettings: childSafetySettings ?? this.childSafetySettings,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
