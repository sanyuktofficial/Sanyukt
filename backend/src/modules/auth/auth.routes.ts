import { Router } from 'express';
import { googleLogin } from './auth.controller';

export const authRouter = Router();

authRouter.post('/google-login', googleLogin);

