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
  'photoUrl',
  'jainSect',
  'jainSectOther',
  'motherTongue',
  'motherTongueOther',
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

  // Validation: Aadhaar must be exactly 12 digits, no alphabets
  if (body.aadhaarOrPassport != null) {
    const aadhaar = body.aadhaarOrPassport.toString().trim();
    if (aadhaar && !/^\d{12}$/.test(aadhaar)) {
      throw new Error('Aadhaar Card Number must be exactly 12 digits, no alphabets');
    }
  }

  // Validation: Pincode must be exactly 6 digits
  if (body.pincode != null) {
    const pincode = body.pincode.toString().trim();
    if (pincode && !/^\d{6}$/.test(pincode)) {
      throw new Error('Pincode must be exactly 6 digits, no alphabets');
    }
  }

  // Validation: City names - alphabets only
  if (body.city != null) {
    const city = body.city.toString().trim();
    if (city && !/^[a-zA-Z\s]+$/.test(city)) {
      throw new Error('City must contain only alphabets');
    }
  }

  // Validation: Names - alphabets only (fullName, fatherName, motherName, spouseName)
  for (const key of ['fullName', 'fatherName', 'motherName', 'spouseName'] as const) {
    if (body[key] != null) {
      const val = body[key].toString().trim();
      if (val && !/^[a-zA-Z\s]+$/.test(val)) {
        throw new Error(`${key.replace(/([A-Z])/g, ' $1').trim()} must contain only alphabets`);
      }
    }
  }

  // Validation: numberOfChildren - single digit 0-9
  if (body.numberOfChildren != null) {
    const nc = body.numberOfChildren;
    if (typeof nc === 'number' && (nc < 0 || nc > 9 || nc !== Math.floor(nc))) {
      throw new Error('Number of children must be a single digit (0-9)');
    }
  }

  // Validation: familySize - two digits max (0-99)
  if (body.familySize != null) {
    const fs = body.familySize;
    if (typeof fs === 'number' && (fs < 0 || fs > 99 || fs !== Math.floor(fs))) {
      throw new Error('Total Family Members must be 0–99');
    }
  }

  // Validation: additionalEmail - valid email format
  if (body.additionalEmail != null) {
    const email = body.additionalEmail.toString().trim();
    if (email && !/^[\w\-.]+@[\w\-]+(\.[\w\-]+)*$/.test(email)) {
      throw new Error('Please enter a valid email address');
    }
  }

  // Validation: alternateContactNumber - valid phone format
  if (body.alternateContactNumber != null) {
    const phone = body.alternateContactNumber.toString().trim();
    if (phone && !/^[0-9+\-\s]{10,15}$/.test(phone)) {
      throw new Error('Please enter a valid phone number');
    }
  }

  // Validation: Social links - URLs only (http or https)
  for (const key of ['linkedInProfileLink', 'instagramSocialLinks', 'facebook', 'twitter'] as const) {
    if (body[key] != null) {
      const val = body[key].toString().trim();
      if (val && !val.startsWith('http://') && !val.startsWith('https://')) {
        throw new Error(`${key}: Only valid links (paste http or https URL) allowed`);
      }
    }
  }

  Object.assign(user, body);
  user.profileCompletion = calculateProfileCompletion(user);
  await user.save();
  return user;
}
