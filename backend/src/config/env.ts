import dotenv from 'dotenv';

dotenv.config();

export const env = {
  port: process.env.PORT ? Number(process.env.PORT) : 3000,
  mongoUri: process.env.MONGO_URI ?? 'mongodb://127.0.0.1:27017/sanyukt',
  jwtSecret: process.env.JWT_SECRET ?? 'change-me-in-production',
  firebaseServiceAccountPath:
    process.env.FIREBASE_SERVICE_ACCOUNT_PATH ?? './firebase-service-account.json',
};

