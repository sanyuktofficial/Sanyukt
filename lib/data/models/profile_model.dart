/// Profile model matching backend user profile (all 6 registration modules).
class ProfileModel {
  /// Minimum profile completion % required to view contact & social details of other users.
  static const int profileCompletionThresholdForContact = 75;

  ProfileModel({
    required this.id,
    required this.name,
    required this.primaryEmail,
    this.primaryPhone,
    this.photoUrl,
    this.profileCompletion = 0,
    this.fullName,
    this.gender,
    this.dateOfBirth,
    this.bloodGroup,
    this.aadhaarOrPassport,
    this.country,
    this.state,
    this.city,
    this.pincode,
    this.fullResidentialAddress,
    this.nativePlaceDistrict,
    this.nativePlaceState,
    this.jainSect,
    this.jainSectOther,
    this.gadhGachhSampradaya,
    this.motherTongue,
    this.motherTongueOther,
    this.localSanghSamitiName,
    this.currentEducationStatus,
    this.currentEducationStatusOther,
    this.highestQualification,
    this.highestQualificationOther,
    this.fieldOfStudy,
    this.fieldOfStudyOther,
    this.institutionName,
    this.yearOfPassing,
    this.academicAchievements,
    this.specialSkills,
    this.employmentType,
    this.employmentTypeOther,
    this.industrySector,
    this.industrySectorOther,
    this.designation,
    this.companyName,
    this.workAddressCity,
    this.workExperience,
    this.businessKeywords,
    this.isEmployer,
    this.maritalStatus,
    this.fatherName,
    this.fatherOccupation,
    this.motherName,
    this.motherOccupation,
    this.spouseName,
    this.spouseOccupation,
    this.numberOfChildren,
    this.familySize,
    this.familyId,
    this.alternateContactNumber,
    this.linkedInProfileLink,
    this.instagramSocialLinks,
    this.facebook,
    this.twitter,
    this.additionalEmail,
  });

  final String id;
  final String name;
  final String primaryEmail;
  final String? primaryPhone;
  final String? photoUrl;
  final double profileCompletion;

  final String? fullName;
  final String? gender;
  final DateTime? dateOfBirth;
  final String? bloodGroup;
  final String? aadhaarOrPassport;
  final String? country;
  final String? state;
  final String? city;
  final String? pincode;
  final String? fullResidentialAddress;
  final String? nativePlaceDistrict;
  final String? nativePlaceState;

  final String? jainSect;
  final String? jainSectOther;
  final String? gadhGachhSampradaya;
  final String? motherTongue;
  final String? motherTongueOther;
  final String? localSanghSamitiName;

  final String? currentEducationStatus;
  final String? currentEducationStatusOther;
  final String? highestQualification;
  final String? highestQualificationOther;
  final String? fieldOfStudy;
  final String? fieldOfStudyOther;
  final String? institutionName;
  final String? yearOfPassing;
  final String? academicAchievements;
  final String? specialSkills;

  final String? employmentType;
  final String? employmentTypeOther;
  final String? industrySector;
  final String? industrySectorOther;
  final String? designation;
  final String? companyName;
  final String? workAddressCity;
  final String? workExperience;
  final String? businessKeywords;
  final bool? isEmployer;

  final String? maritalStatus;
  final String? fatherName;
  final String? fatherOccupation;
  final String? motherName;
  final String? motherOccupation;
  final String? spouseName;
  final String? spouseOccupation;
  final int? numberOfChildren;
  final int? familySize;
  final String? familyId;

  final String? alternateContactNumber;
  final String? linkedInProfileLink;
  final String? instagramSocialLinks;
  final String? facebook;
  final String? twitter;
  final String? additionalEmail;

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    DateTime? dob;
    if (json['dateOfBirth'] != null) {
      if (json['dateOfBirth'] is String) {
        dob = DateTime.tryParse(json['dateOfBirth'] as String);
      } else if (json['dateOfBirth'] is Map && (json['dateOfBirth'] as Map)['\$date'] != null) {
        dob = DateTime.tryParse((json['dateOfBirth'] as Map)['\$date'].toString());
      }
    }
    String? addEmail = json['additionalEmail']?.toString();
    if (addEmail == null && json['additionalEmails'] is List && (json['additionalEmails'] as List).isNotEmpty) {
      addEmail = (json['additionalEmails'] as List).first.toString();
    }
    return ProfileModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      primaryEmail: json['primaryEmail']?.toString() ?? '',
      primaryPhone: json['primaryPhone']?.toString(),
      photoUrl: json['photoUrl']?.toString(),
      profileCompletion: (json['profileCompletion'] as num?)?.toDouble() ?? 0,
      fullName: json['fullName']?.toString(),
      gender: json['gender']?.toString(),
      dateOfBirth: dob,
      bloodGroup: json['bloodGroup']?.toString(),
      aadhaarOrPassport: json['aadhaarOrPassport']?.toString(),
      country: json['country']?.toString(),
      state: json['state']?.toString(),
      city: json['city']?.toString(),
      pincode: json['pincode']?.toString(),
      fullResidentialAddress: json['fullResidentialAddress']?.toString(),
      nativePlaceDistrict: json['nativePlaceDistrict']?.toString(),
      nativePlaceState: json['nativePlaceState']?.toString(),
      jainSect: json['jainSect']?.toString(),
      jainSectOther: json['jainSectOther']?.toString(),
      gadhGachhSampradaya: json['gadhGachhSampradaya']?.toString(),
      motherTongue: json['motherTongue']?.toString(),
      motherTongueOther: json['motherTongueOther']?.toString(),
      localSanghSamitiName: json['localSanghSamitiName']?.toString(),
      currentEducationStatus: json['currentEducationStatus']?.toString(),
      currentEducationStatusOther: json['currentEducationStatusOther']?.toString(),
      highestQualification: json['highestQualification']?.toString(),
      highestQualificationOther: json['highestQualificationOther']?.toString(),
      fieldOfStudy: json['fieldOfStudy']?.toString(),
      fieldOfStudyOther: json['fieldOfStudyOther']?.toString(),
      institutionName: json['institutionName']?.toString(),
      yearOfPassing: json['yearOfPassing']?.toString(),
      academicAchievements: json['academicAchievements']?.toString(),
      specialSkills: json['specialSkills']?.toString(),
      employmentType: json['employmentType']?.toString(),
      employmentTypeOther: json['employmentTypeOther']?.toString(),
      industrySector: json['industrySector']?.toString(),
      industrySectorOther: json['industrySectorOther']?.toString(),
      designation: json['designation']?.toString(),
      companyName: json['companyName']?.toString(),
      workAddressCity: json['workAddressCity']?.toString(),
      workExperience: json['workExperience']?.toString(),
      businessKeywords: json['businessKeywords']?.toString(),
      isEmployer: json['isEmployer'] as bool?,
      maritalStatus: json['maritalStatus']?.toString(),
      fatherName: json['fatherName']?.toString(),
      fatherOccupation: json['fatherOccupation']?.toString(),
      motherName: json['motherName']?.toString(),
      motherOccupation: json['motherOccupation']?.toString(),
      spouseName: json['spouseName']?.toString(),
      spouseOccupation: json['spouseOccupation']?.toString(),
      numberOfChildren: json['numberOfChildren'] as int?,
      familySize: json['familySize'] as int?,
      familyId: json['familyId']?.toString(),
      alternateContactNumber: json['alternateContactNumber']?.toString(),
      linkedInProfileLink: json['linkedInProfileLink']?.toString(),
      instagramSocialLinks: json['instagramSocialLinks']?.toString(),
      facebook: json['facebook']?.toString(),
      twitter: json['twitter']?.toString(),
      additionalEmail: addEmail,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (fullName != null) 'fullName': fullName,
      if (gender != null) 'gender': gender,
      if (dateOfBirth != null) 'dateOfBirth': dateOfBirth!.toIso8601String(),
      if (bloodGroup != null) 'bloodGroup': bloodGroup,
      if (aadhaarOrPassport != null) 'aadhaarOrPassport': aadhaarOrPassport,
      if (country != null) 'country': country,
      if (state != null) 'state': state,
      if (city != null) 'city': city,
      if (pincode != null) 'pincode': pincode,
      if (fullResidentialAddress != null) 'fullResidentialAddress': fullResidentialAddress,
      if (nativePlaceDistrict != null) 'nativePlaceDistrict': nativePlaceDistrict,
      if (nativePlaceState != null) 'nativePlaceState': nativePlaceState,
      if (photoUrl != null) 'photoUrl': photoUrl,
      if (jainSect != null) 'jainSect': jainSect,
      if (jainSectOther != null) 'jainSectOther': jainSectOther,
      if (gadhGachhSampradaya != null) 'gadhGachhSampradaya': gadhGachhSampradaya,
      if (motherTongue != null) 'motherTongue': motherTongue,
      if (motherTongueOther != null) 'motherTongueOther': motherTongueOther,
      if (localSanghSamitiName != null) 'localSanghSamitiName': localSanghSamitiName,
      if (currentEducationStatus != null) 'currentEducationStatus': currentEducationStatus,
      if (currentEducationStatusOther != null) 'currentEducationStatusOther': currentEducationStatusOther,
      if (highestQualification != null) 'highestQualification': highestQualification,
      if (highestQualificationOther != null) 'highestQualificationOther': highestQualificationOther,
      if (fieldOfStudy != null) 'fieldOfStudy': fieldOfStudy,
      if (fieldOfStudyOther != null) 'fieldOfStudyOther': fieldOfStudyOther,
      if (institutionName != null) 'institutionName': institutionName,
      if (yearOfPassing != null) 'yearOfPassing': yearOfPassing,
      if (academicAchievements != null) 'academicAchievements': academicAchievements,
      if (specialSkills != null) 'specialSkills': specialSkills,
      if (employmentType != null) 'employmentType': employmentType,
      if (employmentTypeOther != null) 'employmentTypeOther': employmentTypeOther,
      if (industrySector != null) 'industrySector': industrySector,
      if (industrySectorOther != null) 'industrySectorOther': industrySectorOther,
      if (designation != null) 'designation': designation,
      if (companyName != null) 'companyName': companyName,
      if (workAddressCity != null) 'workAddressCity': workAddressCity,
      if (workExperience != null) 'workExperience': workExperience,
      if (businessKeywords != null) 'businessKeywords': businessKeywords,
      if (isEmployer != null) 'isEmployer': isEmployer,
      if (maritalStatus != null) 'maritalStatus': maritalStatus,
      if (fatherName != null) 'fatherName': fatherName,
      if (fatherOccupation != null) 'fatherOccupation': fatherOccupation,
      if (motherName != null) 'motherName': motherName,
      if (motherOccupation != null) 'motherOccupation': motherOccupation,
      if (spouseName != null) 'spouseName': spouseName,
      if (spouseOccupation != null) 'spouseOccupation': spouseOccupation,
      if (numberOfChildren != null) 'numberOfChildren': numberOfChildren,
      if (familySize != null) 'familySize': familySize,
      if (familyId != null) 'familyId': familyId,
      if (alternateContactNumber != null) 'alternateContactNumber': alternateContactNumber,
      if (linkedInProfileLink != null) 'linkedInProfileLink': linkedInProfileLink,
      if (instagramSocialLinks != null) 'instagramSocialLinks': instagramSocialLinks,
      if (facebook != null) 'facebook': facebook,
      if (twitter != null) 'twitter': twitter,
      if (additionalEmail != null) 'additionalEmail': additionalEmail,
    };
  }

  String get displayName => fullName?.trim().isNotEmpty == true ? fullName! : name;
  String? get displayDesignation => designation ?? companyName;
}
