import jwt from 'jsonwebtoken';
import { env } from './env';

export interface JwtPayload {
  sub: string;
  role: 'user' | 'admin' | 'moderator';
}

export function signJwt(payload: JwtPayload): string {
  return jwt.sign(payload, env.jwtSecret, { expiresIn: '7d' });
}

export function verifyJwt(token: string): JwtPayload {
  return jwt.verify(token, env.jwtSecret) as JwtPayload;
}

