import { Request, Response } from 'express';
import { Types } from 'mongoose';
import { AuthenticatedRequest } from '../common/types';
import { UserModel } from '../user/user.model';

/** Employment type matches for Job */
const JOB_TYPES = ['Job', 'Job & Business'];
/** Employment type matches for Business */
const BUSINESS_TYPES = ['Business', 'Job & Business'];
/** Employment type for Student */
const STUDENT_TYPE = 'Student';

function normalizeEmploymentType(v?: string): string {
  return (v ?? '').trim();
}

function isJob(emp: string): boolean {
  return JOB_TYPES.some((t) => emp.toLowerCase().includes(t.toLowerCase()));
}

function isBusiness(emp: string): boolean {
  return BUSINESS_TYPES.some((t) => emp.toLowerCase().includes(t.toLowerCase()));
}

function isStudent(emp: string): boolean {
  return emp.toLowerCase() === STUDENT_TYPE.toLowerCase();
}

/** Resolve industry: industrySector or industrySectorOther when "Other" */
function resolveIndustry(doc: any): string | null {
  const sector = doc.industrySector?.toString().trim();
  const other = doc.industrySectorOther?.toString().trim();
  if (sector && sector.toLowerCase() !== 'other') return sector;
  if (other) return other;
  return sector || null;
}

/** Resolve field of study: fieldOfStudy or fieldOfStudyOther */
function resolveFieldOfStudy(doc: any): string | null {
  const field = doc.fieldOfStudy?.toString().trim();
  const other = doc.fieldOfStudyOther?.toString().trim();
  if (field && field.toLowerCase() !== 'other') return field;
  if (other) return other;
  return field || null;
}

/** Resolve main value or "Other" fallback */
function resolveOther(doc: any, main: string, other: string): string | null {
  const mainVal = doc[main]?.toString().trim();
  const otherVal = doc[other]?.toString().trim();
  if (mainVal && mainVal.toLowerCase() !== 'other') return mainVal;
  if (otherVal) return otherVal;
  return mainVal || null;
}

/**
 * GET /audience/categories?type=job|business|student
 * Returns distinct categories (industries for job/business, field of study for student)
 * from users who have filled that data in their profile.
 */
export async function listCategories(req: Request, res: Response) {
  const type = (req.query.type as string)?.toLowerCase();
  if (!['job', 'business', 'student'].includes(type)) {
    return res.status(400).json({
      success: false,
      message: 'Query param "type" must be job, business, or student',
    });
  }

  let matchFilter: any;
  if (type === 'job') {
    matchFilter = {
      $or: [
        { employmentType: { $regex: /^Job$/i } },
        { employmentType: { $regex: /Job\s*&\s*Business/i } },
      ],
    };
  } else if (type === 'business') {
    matchFilter = {
      $or: [
        { employmentType: { $regex: /^Business$/i } },
        { employmentType: { $regex: /Job\s*&\s*Business/i } },
      ],
    };
  } else {
    matchFilter = { employmentType: { $regex: /^Student$/i } };
  }

  const users = await UserModel.find(matchFilter)
    .select(
      type === 'student'
        ? 'fieldOfStudy fieldOfStudyOther'
        : 'industrySector industrySectorOther',
    )
    .lean()
    .exec();

  const categorySet = new Set<string>();
  for (const u of users) {
    const val =
      type === 'student'
        ? resolveFieldOfStudy(u)
        : resolveIndustry(u);
    if (val) categorySet.add(val);
  }

  const categories = Array.from(categorySet)
    .sort((a, b) => a.localeCompare(b))
    .map((name) => ({ id: name, name }));

  return res.json({
    success: true,
    type,
    categories,
  });
}

/**
 * GET /audience/users?type=job|business|student&category=CategoryName
 * Returns users in that category.
 */
export async function listUsersByCategory(req: AuthenticatedRequest, res: Response) {
  const type = (req.query.type as string)?.toLowerCase();
  const category = (req.query.category as string)?.trim();

  if (!['job', 'business', 'student'].includes(type)) {
    return res.status(400).json({
      success: false,
      message: 'Query param "type" must be job, business, or student',
    });
  }
  let employmentFilter: any;
  if (type === 'job') {
    employmentFilter = {
      $or: [
        { employmentType: { $regex: /^Job$/i } },
        { employmentType: { $regex: /Job\s*&\s*Business/i } },
      ],
    };
  } else if (type === 'business') {
    employmentFilter = {
      $or: [
        { employmentType: { $regex: /^Business$/i } },
        { employmentType: { $regex: /Job\s*&\s*Business/i } },
      ],
    };
  } else {
    employmentFilter = { employmentType: { $regex: /^Student$/i } };
  }

  let categoryFilter: any = {};
  if (category && category.trim()) {
    const cat = category.trim();
    if (type === 'student') {
      categoryFilter = {
        $or: [
          { fieldOfStudy: { $regex: new RegExp(`^${escapeRegex(cat)}$`, 'i') } },
          { fieldOfStudyOther: { $regex: new RegExp(`^${escapeRegex(cat)}$`, 'i') } },
        ],
      };
    } else {
      categoryFilter = {
        $or: [
          { industrySector: { $regex: new RegExp(`^${escapeRegex(cat)}$`, 'i') } },
          { industrySectorOther: { $regex: new RegExp(`^${escapeRegex(cat)}$`, 'i') } },
        ],
      };
    }
  }

  const filter = categoryFilter.$or
    ? { ...employmentFilter, ...categoryFilter }
    : employmentFilter;

  const users = await UserModel.find(filter)
    .select(
      'name fullName photoUrl designation companyName industrySector industrySectorOther ' +
        'fieldOfStudy fieldOfStudyOther city state country pincode profileCompletion ' +
        'employmentType employmentTypeOther workExperience businessKeywords workAddressCity ' +
        'highestQualification highestQualificationOther institutionName yearOfPassing ' +
        'maritalStatus gender dateOfBirth nativePlaceDistrict nativePlaceState ' +
        'jainSect jainSectOther motherTongue motherTongueOther localSanghSamitiName ' +
        'linkedInProfileLink facebook twitter instagramSocialLinks ' +
        'fatherName motherName spouseName isEmployer specialSkills academicAchievements ' +
        'currentEducationStatus currentEducationStatusOther',
    )
    .lean()
    .exec();

  const list = users.map((u: any) => ({
    id: u._id?.toString(),
    name: u.fullName || u.name,
    designation: u.designation,
    companyName: u.companyName,
    industry: resolveIndustry(u),
    fieldOfStudy: resolveFieldOfStudy(u),
    city: u.city,
    state: u.state,
    country: u.country,
    pincode: u.pincode,
    profileCompletion: u.profileCompletion ?? 0,
    photoUrl: u.photoUrl,
    employmentType: u.employmentType || u.employmentTypeOther,
    workExperience: u.workExperience,
    businessKeywords: u.businessKeywords,
    workAddressCity: u.workAddressCity,
    highestQualification: u.highestQualification || u.highestQualificationOther,
    institutionName: u.institutionName,
    yearOfPassing: u.yearOfPassing,
    maritalStatus: u.maritalStatus,
    gender: u.gender,
    dateOfBirth: u.dateOfBirth,
    nativePlaceDistrict: u.nativePlaceDistrict,
    nativePlaceState: u.nativePlaceState,
    jainSect: u.jainSect || u.jainSectOther,
    motherTongue: u.motherTongue || u.motherTongueOther,
    localSanghSamitiName: u.localSanghSamitiName,
    linkedInProfileLink: u.linkedInProfileLink,
    facebook: u.facebook,
    twitter: u.twitter,
    instagramSocialLinks: u.instagramSocialLinks,
    fatherName: u.fatherName,
    motherName: u.motherName,
    spouseName: u.spouseName,
    isEmployer: u.isEmployer,
    specialSkills: u.specialSkills,
    academicAchievements: u.academicAchievements,
    currentEducationStatus: u.currentEducationStatus || u.currentEducationStatusOther,
  }));

  return res.json({
    success: true,
    type,
    category,
    users: list,
  });
}

function escapeRegex(s: string): string {
  return s.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}

/** Legacy: GET /audience/users/:categoryId - maps categoryId to type for old audience flow */
export async function listUsersByCategoryLegacy(req: AuthenticatedRequest, res: Response) {
  const categoryId = (req.params.categoryId as string)?.toLowerCase();
  const typeMap: Record<string, string> = {
    business: 'business',
    jobs: 'job',
    job: 'job',
    student: 'student',
  };
  const type = typeMap[categoryId];
  if (!type) {
    return res.json({
      success: true,
      type: categoryId,
      category: '',
      users: [],
    });
  }
  (req as any).query = { type, category: '' };
  return listUsersByCategory(req, res);
}

/**
 * GET /audience/user/:userId
 * Returns user detail. Sensitive fields visible only if both viewer and target have 75%+ completion.
 */
export async function getUserDetail(req: AuthenticatedRequest, res: Response) {
  const { userId } = req.params;
  const viewerId = req.user?.sub;

  if (!viewerId) {
    return res.status(401).json({ success: false, message: 'Unauthorized' });
  }

  if (!Types.ObjectId.isValid(userId)) {
    return res.status(400).json({ success: false, message: 'Invalid user id' });
  }

  const viewer = await UserModel.findById(viewerId).lean().exec();
  const target = await UserModel.findById(userId).lean().exec();

  if (!target || !viewer) {
    return res.status(404).json({ success: false, message: 'User not found' });
  }

  const viewerComplete = (viewer.profileCompletion ?? 0) >= 75;
  const canSeeSensitive = viewerComplete;

  const responseUser: any = {
    ...target,
    id: (target as any)._id?.toString(),
    industry: resolveIndustry(target),
    fieldOfStudy: resolveFieldOfStudy(target),
    jainSect: resolveOther(target, 'jainSect', 'jainSectOther'),
    motherTongue: resolveOther(target, 'motherTongue', 'motherTongueOther'),
    highestQualification: resolveOther(target, 'highestQualification', 'highestQualificationOther'),
    employmentType: resolveOther(target, 'employmentType', 'employmentTypeOther'),
    currentEducationStatus: resolveOther(target, 'currentEducationStatus', 'currentEducationStatusOther'),
    industrySector: resolveIndustry(target),
  };
  delete responseUser._id;
  delete responseUser.__v;
  delete responseUser.firebaseUid;

  if (!canSeeSensitive) {
    responseUser.primaryPhone = null;
    responseUser.primaryEmail = null;
    responseUser.alternateContactNumber = null;
    responseUser.additionalEmail = null;
    responseUser.fullResidentialAddress = null;
    responseUser.city = null;
    responseUser.state = null;
    responseUser.country = null;
    responseUser.pincode = null;
  }

  return res.json({
    success: true,
    user: responseUser,
    canSeeSensitive,
  });
}

export async function getStats(_req: AuthenticatedRequest, res: Response) {
  const totalUsers = await UserModel.countDocuments().exec();
  const completeProfiles = await UserModel.countDocuments({
    profileCompletion: { $gte: 75 },
  }).exec();

  return res.json({
    success: true,
    totalUsers,
    completeProfiles,
  });
}
