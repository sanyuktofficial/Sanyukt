# Google Sign-In Setup Checklist

Use this checklist to avoid "sign-in was canceled" and related errors.

## 1. SHA certificate fingerprints (Android)

**Required:** Register SHA-1 and SHA-256 for both **debug** and **release** in Firebase.

- Get fingerprints: in project root run  
  `cd android && ./gradlew signingReport`  
  (or Android Studio: Gradle → app → Tasks → android → signingReport)
- Firebase Console → **Project settings** → **General** → **Your apps** → Android app
- Click **Add fingerprint**, paste **SHA-1** (debug), Save. Repeat for **SHA-256** (debug).
- Add **release** SHA-1 and SHA-256 the same way if you use release builds.
- **Download** the new `google-services.json` and replace `android/app/google-services.json`.

## 2. Google Sign-In enabled in Firebase

- Firebase Console → **Authentication** → **Sign-in method**
- Enable **Google** and save.

## 3. OAuth 2.0 Web client ID

**Use the Web client ID** (not the Android client ID) for `serverClientId`.

- Firebase Console → **Project settings** → **Your apps** → **Web app** (or Google Cloud Console → APIs & Services → Credentials)
- Copy the **Web application** OAuth 2.0 client ID (`xxxxx-xxxx.apps.googleusercontent.com`)
- In this project it is set in `lib/firebase_options.dart` as `googleSignInWebClientId`.

## 4. User cancels sign-in

Handled in code: cancel is detected and a friendly message is shown; the app does not crash.

## 5. Account exists with different credential

Handled in code: if the user signs in with Google using an email already linked to another method (e.g. email/password), a clear message is shown asking them to sign in with the original method or link accounts.

## 6. Android manifest (launch mode)

The main activity uses `android:launchMode="singleTop"` in `android/app/src/main/AndroidManifest.xml`, which is correct for the sign-in callback.
