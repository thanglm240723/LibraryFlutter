## Firebase Configuration Guide

### ✅ UPDATED: Now Using .env File

Firebase configuration is now managed through a `.env` file for better security and flexibility. See [ENV_SETUP_GUIDE.md](ENV_SETUP_GUIDE.md) for detailed setup instructions.

### Quick Setup

1. Copy template: `cp .env.example .env`
2. Add Firebase credentials to `.env`
3. Restart the app

### Environment Files

- **`.env`** - Your actual credentials ⚠️ Keep secret!
- **`.env.example`** - Template for team members ✅ Safe to commit
- **`lib/services/env_loader.dart`** - Loads environment variables
- **`lib/services/firebase_config.dart`** - Uses loaded credentials

### Get Firebase Credentials

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project → ⚙️ Project Settings
3. Find these values in **General** tab:
   - **Project ID** → Copy to `FIREBASE_PROJECT_ID`
   - **Storage Bucket** → Copy to `FIREBASE_STORAGE_BUCKET`
   - **API Key** → Copy to `FIREBASE_API_KEY`
   - **App ID** → Copy to `FIREBASE_APP_ID`
   - **Sender ID** → Copy to `FIREBASE_MESSAGING_SENDER_ID`

### Features

- ✅ **Centralized Configuration** - All settings in one `.env` file
- ✅ **Secure** - Credentials not in version control
- ✅ **Environment Support** - Different configs for dev/staging/prod
- ✅ **Image Upload** - Firebase Storage upload to backend
- ✅ **Image Preview** - Instant preview of uploads
- ✅ **Easy to Update** - Just edit `.env` file

### File Structure

```
lib/services/
├── firebase_config.dart      # Firebase initialization
├── firebase_storage_service.dart # Storage operations  
├── env_loader.dart          # Environment loader
└── ...
```

For full documentation, see [ENV_SETUP_GUIDE.md](ENV_SETUP_GUIDE.md)
