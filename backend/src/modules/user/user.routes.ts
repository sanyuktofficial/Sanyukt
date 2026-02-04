import { Router } from 'express';
import { authMiddleware } from '../common/authMiddleware';
import { getProfile, getProfileOptions, updateProfile } from './user.controller';

export const userRouter = Router();

userRouter.get('/profile', authMiddleware, getProfile);
userRouter.get('/profile/options', authMiddleware, getProfileOptions);
userRouter.put('/profile/update', authMiddleware, updateProfile);

