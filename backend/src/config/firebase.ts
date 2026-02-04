import admin from 'firebase-admin';
import { env } from './env';

let initialized = false;

export function initFirebaseAdmin() {
  if (initialized) return;

  try {
    const serviceAccount = require(env.firebaseServiceAccountPath);
    admin.initializeApp({
      credential: admin.credential.cert(serviceAccount as admin.ServiceAccount),
    });
    initialized = true;
    // eslint-disable-next-line no-console
    console.log('Firebase admin initialized');
  } catch (err) {
    // eslint-disable-next-line no-console
    console.error(
      'Failed to initialize Firebase admin. Check FIREBASE_SERVICE_ACCOUNT_PATH.',
      err,
    );
    throw err;
  }
}

export { admin };

