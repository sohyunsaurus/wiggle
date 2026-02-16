# Firebase Configuration Removed

This project does NOT use Firebase.

All Firebase-related files have been removed:

- `firebase.json`
- `.firebaserc`
- `lib/firebase_options.dart`
- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist`
- `macos/Runner/GoogleService-Info.plist`

These files are now in `.gitignore` to prevent accidental re-addition.

## If Firebase CLI tries to regenerate files:

1. Make sure you're logged out of Firebase CLI:

   ```bash
   firebase logout
   ```

2. If files are regenerated, delete them:

   ```bash
   rm -f firebase.json .firebaserc lib/firebase_options.dart
   rm -f android/app/google-services.json
   rm -f ios/Runner/GoogleService-Info.plist
   rm -f macos/Runner/GoogleService-Info.plist
   ```

3. The app works perfectly without Firebase - it uses local SQLite database for all data storage.
