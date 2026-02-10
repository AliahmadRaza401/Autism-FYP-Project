class UserModel {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? emergencyContact;
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
  final List<String>? favorites;
  final Map<String, dynamic>? childSafetySettings;
  final DateTime createdAt;
  final DateTime? deletedAt;
   final String? password;


  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.emergencyContact,
    this.profileImage,
    this.password,
    this.childName,
    this.childDob,
    this.diagnosis,
    this.noiseSensitivity,
    this.crowdSensitivity,
    this.lightSensitivity,
    this.preferredTextSize,
    this.primaryChallenge,
    this.safeZones,
    this.favorites,
    this.childSafetySettings,
    required this.createdAt,
    this.deletedAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String documentId) {
    return UserModel(
      id: documentId,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'],
      emergencyContact: map['emergencyContact'],
      profileImage: map['profileImage'],
      childName: map['childName'],
      childDob: map['childDob'] != null ? DateTime.fromMillisecondsSinceEpoch(map['childDob']) : null,
      diagnosis: map['diagnosis'],
      noiseSensitivity: (map['noiseSensitivity'] as num?)?.toDouble(),
      crowdSensitivity: (map['crowdSensitivity'] as num?)?.toDouble(),
      lightSensitivity: (map['lightSensitivity'] as num?)?.toDouble(),
      preferredTextSize: map['preferredTextSize'],
      primaryChallenge: map['primaryChallenge'],
      password: map['password'],
      safeZones: map['safeZones'] != null ? List<String>.from(map['safeZones']) : null,
      childSafetySettings: map['childSafetySettings'],
      favorites: map['favorites'] != null ? List<String>.from(map['favorites']) : null,
      createdAt: map['createdAt'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt']) 
          : DateTime.now(),
      deletedAt: map['deletedAt'] != null ? DateTime.fromMillisecondsSinceEpoch(map['deletedAt']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'emergencyContact': emergencyContact,
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
      'favorites': favorites,
      'childSafetySettings': childSafetySettings,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'deletedAt': deletedAt?.millisecondsSinceEpoch,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? emergencyContact,
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
    DateTime? deletedAt,
    String? password
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      emergencyContact: emergencyContact ?? this.emergencyContact,
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
      favorites: favorites ?? this.favorites,
      childSafetySettings: childSafetySettings ?? this.childSafetySettings,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
       password: password ?? this.password,
    );
  }
}
