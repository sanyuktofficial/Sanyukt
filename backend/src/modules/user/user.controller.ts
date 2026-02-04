import { Response } from 'express';
import { AuthenticatedRequest } from '../common/types';
import { profileOptions } from './profile.options';
import { getUserById, updateUserProfile } from './user.service';

export async function getProfile(req: AuthenticatedRequest, res: Response) {
  const userId = req.user?.sub;
  if (!userId) {
    return res.status(401).json({ success: false, message: 'Unauthorized' });
  }

  const user = await getUserById(userId);
  if (!user) {
    return res.status(404).json({ success: false, message: 'User not found' });
  }

  const userObj = user.toObject() as Record<string, unknown>;
  const userResponse = {
    ...userObj,
    id: (userObj as any)._id?.toString(),
    additionalEmail: userObj.additionalEmail ?? (userObj.additionalEmails as string[])?.[0],
  };
  delete (userResponse as any).additionalEmails;
  return res.json({
    success: true,
    user: userResponse,
  });
}

export async function updateProfile(req: AuthenticatedRequest, res: Response) {
  const userId = req.user?.sub;
  if (!userId) {
    return res.status(401).json({ success: false, message: 'Unauthorized' });
  }

  try {
    const updated = await updateUserProfile(userId, req.body ?? {});
    if (!updated) {
      return res.status(404).json({ success: false, message: 'User not found' });
    }
    const userObj = updated.toObject() as Record<string, unknown>;
    const userResponse = {
      ...userObj,
      id: (userObj as any)._id?.toString(),
      additionalEmail: userObj.additionalEmail ?? (userObj.additionalEmails as string[])?.[0],
    };
    delete (userResponse as any).additionalEmails;
    return res.json({
      success: true,
      user: userResponse,
    });
  } catch (err: any) {
    return res.status(400).json({
      success: false,
      message: err?.message ?? 'Validation failed',
    });
  }
}

/** Single API for all profile form dropdown options */
export function getProfileOptions(_req: AuthenticatedRequest, res: Response) {
  const options: Record<string, string[]> = {};
  for (const [key, value] of Object.entries(profileOptions)) {
    options[key] = [...(value as readonly string[])];
  }
  return res.json({ success: true, options });
}

