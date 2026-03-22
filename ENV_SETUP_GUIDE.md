# Environment Configuration Guide

## Overview
This Flutter application uses environment variables to manage sensitive Firebase credentials. Environment variables are loaded from a `.env` file using the `flutter_dotenv` package.

## Quick Setup

### 1. Copy Environment Template
```bash
cp .env.example .env
```

### 2. Edit `.env` File
Open the `.env` file and replace the placeholder values with your actual Firebase credentials:

```env
FIREBASE_PROJECT_ID=your-actual-project-id
FIREBASE_STORAGE_BUCKET=your-project-id.appspot.com
FIREBASE_API_KEY=your-actual-api-key
FIREBASE_APP_ID=your-actual-app-id
FIREBASE_MESSAGING_SENDER_ID=your-actual-messaging-id
ENVIRONMENT=development
```

### 3. Get Firebase Credentials
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project
3. Click **⚙️ Project Settings** (gear icon)
4. Go to the **General** tab
5. Scroll down to find your credentials:
   - **Project ID**: Your project identifier
   - **Storage Bucket**: Format is `your-project-id.appspot.com`
   - **API Key**: Web API key
   - **App ID**: Firebase app identifier
   - **Messaging Sender ID**: Cloud Messaging sender ID

## Environment Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `FIREBASE_PROJECT_ID` | Your Firebase project ID | `my-app-firebase` |
| `FIREBASE_STORAGE_BUCKET` | Firebase storage bucket | `my-app-firebase.appspot.com` |
| `FIREBASE_API_KEY` | Firebase web API key | `AIzaSyDx...` |
| `FIREBASE_APP_ID` | Firebase app ID | `1:123456789:web:abc123...` |
| `FIREBASE_MESSAGING_SENDER_ID` | Cloud messaging ID | `123456789` |
| `ENVIRONMENT` | App environment | `development`, `staging`, or `production` |

## Important Notes

⚠️ **Security**
- ❌ **DO NOT** commit `.env` file to version control
- ✅ **DO** commit `.env.example` file (without real credentials)
- ✅ Keep `.env` in `.gitignore` (already configured)

## How It Works

### Loading Environment Variables
The environment variables are loaded in `main.dart`:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize environment variables from .env file
  await EnvLoader.initialize();
  
  // Initialize Firebase
  await FirebaseConfig.initialize();
  
  runApp(const MyApp());
}
```

### Accessing Environment Variables
Environment variables are accessed through the `EnvLoader` class:

```dart
import 'services/env_loader.dart';

String projectId = EnvLoader.projectId;
String bucket = EnvLoader.storageBucket;
String environment = EnvLoader.environment;

if (EnvLoader.isDevelopment) {
  // Do something in development
}
```

## Troubleshooting

### `.env` file not loading?
- Make sure `.env` file exists in project root
- Check that `flutter_dotenv` is added to `pubspec.yaml`:
  ```yaml
  dependencies:
    flutter_dotenv: ^5.1.0
  ```
- Verify `.env` is listed in `pubspec.yaml` assets:
  ```yaml
  flutter:
    assets:
      - .env
  ```

### Firebase initialization fails?
- Verify all Firebase credentials are correct in `.env`
- Check internet connection
- Ensure Firebase project is active and has Storage enabled
- Restart the app after updating `.env`

### Default values are being used?
- `.env` file might not be loaded correctly
- Check console output for "⚠️  Error loading .env file" message
- Verify file path and permissions

## For New Team Members

1. Clone the repository
2. Run `cp .env.example .env`
3. Ask project lead for `.env` credentials
4. Paste credentials into `.env`
5. Run `flutter pub get`
6. Run the app

## Production Deployment

For production:
1. Create a separate `.env.production` file
2. Update the `ENVIRONMENT` variable to `production`
3. Use your production Firebase project credentials
4. Follow your deployment process to securely pass these variables to the build

---

**Questions?** Contact the development team for Firebase credentials or clarification on setup.
