import mongoose, { Schema, Document } from 'mongoose';

export interface UserDocument extends Document {
  firebaseUid: string;
  name: string;
  primaryEmail: string;
  primaryPhone?: string;
  photoUrl?: string;
  profileCompletion: number;
  roles: string[];
  createdAt: Date;
  updatedAt: Date;

  // Module 1: Core Identity & Census
  fullName?: string;
  gender?: string;
  dateOfBirth?: Date;
  bloodGroup?: string;
  aadhaarOrPassport?: string;
  country?: string;
  state?: string;
  city?: string;
  pincode?: string;
  fullResidentialAddress?: string;
  nativePlaceDistrict?: string;
  nativePlaceState?: string;

  // Module 2: Community & Lineage
  jainSect?: string;
  jainSectOther?: string;
  gadhGachhSampradaya?: string;
  motherTongue?: string;
  motherTongueOther?: string;
  localSanghSamitiName?: string;

  // Module 3: Educational Background
  currentEducationStatus?: string;
  currentEducationStatusOther?: string;
  highestQualification?: string;
  highestQualificationOther?: string;
  fieldOfStudy?: string;
  fieldOfStudyOther?: string;
  institutionName?: string;
  yearOfPassing?: string;
  academicAchievements?: string;
  specialSkills?: string;

  // Module 4: Professional & Business
  employmentType?: string;
  employmentTypeOther?: string;
  industrySector?: string;
  industrySectorOther?: string;
  designation?: string;
  companyName?: string;
  workAddressCity?: string;
  workExperience?: string;
  businessKeywords?: string;
  isEmployer?: boolean;

  // Module 5: Family Structure
  maritalStatus?: string;
  fatherName?: string;
  fatherOccupation?: string;
  motherName?: string;
  motherOccupation?: string;
  spouseName?: string;
  spouseOccupation?: string;
  numberOfChildren?: number;
  familySize?: number;
  familyId?: string;

  // Module 6: Communication & Social (primary from auth; single additional email; no additional phones)
  alternateContactNumber?: string;
  linkedInProfileLink?: string;
  instagramSocialLinks?: string;
  facebook?: string;
  twitter?: string;
  additionalEmail?: string;
  /** @deprecated Use additionalEmail. Kept for backward compat when reading old docs */
  additionalEmails?: string[];
}

const UserSchema = new Schema<UserDocument>(
  {
    firebaseUid: { type: String, required: true, unique: true },
    name: { type: String, required: true },
    primaryEmail: { type: String, required: true },
    primaryPhone: { type: String },
    photoUrl: { type: String },
    profileCompletion: { type: Number, default: 0 },
    roles: { type: [String], default: ['user'] },

    fullName: { type: String },
    gender: { type: String },
    dateOfBirth: { type: Date },
    bloodGroup: { type: String },
    aadhaarOrPassport: { type: String },
    country: { type: String },
    state: { type: String },
    city: { type: String },
    pincode: { type: String },
    fullResidentialAddress: { type: String },
    nativePlaceDistrict: { type: String },
    nativePlaceState: { type: String },

    jainSect: { type: String },
    jainSectOther: { type: String },
    gadhGachhSampradaya: { type: String },
    motherTongue: { type: String },
    motherTongueOther: { type: String },
    localSanghSamitiName: { type: String },

    currentEducationStatus: { type: String },
    currentEducationStatusOther: { type: String },
    highestQualification: { type: String },
    highestQualificationOther: { type: String },
    fieldOfStudy: { type: String },
    fieldOfStudyOther: { type: String },
    institutionName: { type: String },
    yearOfPassing: { type: String },
    academicAchievements: { type: String },
    specialSkills: { type: String },

    employmentType: { type: String },
    employmentTypeOther: { type: String },
    industrySector: { type: String },
    industrySectorOther: { type: String },
    designation: { type: String },
    companyName: { type: String },
    workAddressCity: { type: String },
    workExperience: { type: String },
    businessKeywords: { type: String },
    isEmployer: { type: Boolean },

    maritalStatus: { type: String },
    fatherName: { type: String },
    fatherOccupation: { type: String },
    motherName: { type: String },
    motherOccupation: { type: String },
    spouseName: { type: String },
    spouseOccupation: { type: String },
    numberOfChildren: { type: Number },
    familySize: { type: Number },
    familyId: { type: String },

    alternateContactNumber: { type: String },
    linkedInProfileLink: { type: String },
    instagramSocialLinks: { type: String },
    facebook: { type: String },
    twitter: { type: String },
    additionalEmail: { type: String },
    additionalEmails: { type: [String] }, // deprecated, backward compat for old docs
  },
  { timestamps: true },
);

export const UserModel = mongoose.model<UserDocument>('User', UserSchema);
