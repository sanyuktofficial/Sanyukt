import { UserDocument, UserModel } from './user.model';

const PROFILE_FIELDS: (keyof UserDocument)[] = [
  'name',
  'fullName',
  'gender',
  'dateOfBirth',
  'bloodGroup',
  'aadhaarOrPassport',
  'country',
  'state',
  'city',
  'pincode',
  'fullResidentialAddress',
  'nativePlaceDistrict',
  'nativePlaceState',
  'photoUrl',
  'jainSect',
  'jainSectOther',
  'gadhGachhSampradaya',
  'motherTongue',
  'motherTongueOther',
  'localSanghSamitiName',
  'currentEducationStatus',
  'currentEducationStatusOther',
  'highestQualification',
  'highestQualificationOther',
  'fieldOfStudy',
  'fieldOfStudyOther',
  'institutionName',
  'yearOfPassing',
  'academicAchievements',
  'specialSkills',
  'employmentType',
  'employmentTypeOther',
  'industrySector',
  'industrySectorOther',
  'designation',
  'companyName',
  'workAddressCity',
  'workExperience',
  'businessKeywords',
  'isEmployer',
  'maritalStatus',
  'fatherName',
  'fatherOccupation',
  'motherName',
  'motherOccupation',
  'spouseName',
  'spouseOccupation',
  'numberOfChildren',
  'familySize',
  'familyId',
  'primaryPhone',
  'alternateContactNumber',
  'linkedInProfileLink',
  'instagramSocialLinks',
  'facebook',
  'twitter',
  'additionalEmail',
];

export function calculateProfileCompletion(user: UserDocument): number {
  let filled = 0;
  for (const field of PROFILE_FIELDS) {
    const val = user[field];
    if (val === undefined || val === null) continue;
    if (typeof val === 'string' && val.trim() === '') continue;
    if (Array.isArray(val) && val.length === 0) continue;
    filled += 1;
  }
  const total = PROFILE_FIELDS.length;
  return Math.min(100, Math.round((filled / total) * 100));
}

export async function getUserById(id: string): Promise<UserDocument | null> {
  return UserModel.findById(id).exec();
}

const OTHER_FIELDS: { main: keyof UserDocument; other: keyof UserDocument }[] = [
  { main: 'jainSect', other: 'jainSectOther' },
  { main: 'motherTongue', other: 'motherTongueOther' },
  { main: 'currentEducationStatus', other: 'currentEducationStatusOther' },
  { main: 'highestQualification', other: 'highestQualificationOther' },
  { main: 'fieldOfStudy', other: 'fieldOfStudyOther' },
  { main: 'employmentType', other: 'employmentTypeOther' },
  { main: 'industrySector', other: 'industrySectorOther' },
];

export async function updateUserProfile(
  id: string,
  data: Partial<UserDocument>,
): Promise<UserDocument | null> {
  const user = await UserModel.findById(id).exec();
  if (!user) return null;

  const body = { ...data } as any;
  delete body.firebaseUid;
  delete body.primaryEmail;
  delete body._id;
  delete body.__v;
  delete body.createdAt;
  delete body.updatedAt;
  delete body.roles;
  delete body.profileCompletion;

  // Migrate additionalEmails array to single additionalEmail (backward compat)
  if (Array.isArray(body.additionalEmails) && body.additionalEmails.length > 0) {
    body.additionalEmail = body.additionalEmails[0]?.toString().trim() || undefined;
  }
  delete body.additionalEmails;
  delete body.additionalPhones;

  // Validate: when "Other" is selected, corresponding *Other field is required
  for (const { main, other } of OTHER_FIELDS) {
    const mainVal = (body[main] ?? user[main])?.toString().trim();
    if (mainVal?.toLowerCase() === 'other') {
      const otherVal = (body[other] ?? user[other])?.toString().trim();
      if (!otherVal) {
        throw new Error(`Please specify details for "${main}" when "Other" is selected`);
      }
    }
  }

  Object.assign(user, body);
  user.profileCompletion = calculateProfileCompletion(user);
  await user.save();
  return user;
}
