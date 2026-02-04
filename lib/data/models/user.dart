class UserModel {
  UserModel({
    required this.id,
    required this.name,
    required this.primaryEmail,
    this.primaryPhone,
    this.photoUrl,
    this.profession,
    this.profileCompletion,
  });

  final String id;
  final String name;
  final String primaryEmail;
  final String? primaryPhone;
  final String? photoUrl;
  final String? profession;
  final double? profileCompletion;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id']?.toString() ?? json['id'].toString(),
      name: json['name']?.toString() ?? '',
      primaryEmail: json['primaryEmail']?.toString() ?? '',
      primaryPhone: json['primaryPhone']?.toString(),
      photoUrl: json['photoUrl']?.toString(),
      profession: json['profession']?.toString(),
      profileCompletion: (json['profileCompletion'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'primaryEmail': primaryEmail,
      'primaryPhone': primaryPhone,
      'photoUrl': photoUrl,
      'profession': profession,
      'profileCompletion': profileCompletion,
    };
  }
}

