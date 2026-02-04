import { Request, Response } from 'express';
import { signJwt } from '../../config/jwt';
import { UserModel } from '../user/user.model';
import { calculateProfileCompletion } from '../user/user.service';

interface GoogleUserInfoBody {
  firebaseUid?: string;
  name?: string;
  email?: string;
  photoUrl?: string;
  phoneNumber?: string;
  emailVerified?: boolean;
  googleId?: string;
}

export async function googleLogin(req: Request, res: Response) {
  const body = req.body as GoogleUserInfoBody;
  const firebaseUid = body.firebaseUid;
  const name = body.name ?? 'Member';
  const email = body.email;
  const photoUrl = body.photoUrl;
  const phoneNumber = body.phoneNumber;

  if (!firebaseUid || !email) {
    return res.status(400).json({
      success: false,
      message: 'firebaseUid and email are required',
    });
  }

  try {
    let user = await UserModel.findOne({ firebaseUid }).exec();
    if (!user) {
      user = new UserModel({
        firebaseUid,
        name,
        primaryEmail: email,
        primaryPhone: phoneNumber,
        photoUrl,
      });
      user.profileCompletion = calculateProfileCompletion(user);
      await user.save();
    } else {
      user.name = name;
      user.primaryEmail = email;
      if (phoneNumber != null) user.primaryPhone = phoneNumber;
      if (photoUrl != null) user.photoUrl = photoUrl;
      user.profileCompletion = calculateProfileCompletion(user);
      await user.save();
    }

    const token = signJwt({
      sub: user.id,
      role: user.roles.includes('admin') ? 'admin' : 'user',
    });

    const userJson = user.toObject();
    const userResponse = { ...userJson, id: (userJson as any)._id?.toString() };

    return res.json({
      success: true,
      token,
      user: userResponse,
    });
  } catch (err) {
    // eslint-disable-next-line no-console
    console.error('Error in google login', err);
    return res.status(500).json({
      success: false,
      message: 'Failed to create or update user',
    });
  }
}

