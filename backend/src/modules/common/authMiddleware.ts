import { NextFunction, Response } from 'express';
import { verifyJwt } from '../../config/jwt';
import { AuthenticatedRequest } from './types';

export function authMiddleware(
  req: AuthenticatedRequest,
  res: Response,
  next: NextFunction,
) {
  const authHeader = req.headers.authorization;
  if (!authHeader?.startsWith('Bearer ')) {
    return res.status(401).json({ success: false, message: 'Unauthorized' });
  }

  const token = authHeader.slice('Bearer '.length);

  try {
    const payload = verifyJwt(token);
    req.user = payload;
    next();
  } catch {
    return res.status(401).json({ success: false, message: 'Invalid token' });
  }
}

