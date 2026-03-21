import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Environment loader service
/// Handles loading and managing environment variables
class EnvLoader {
  static late String _projectId;
  static late String _storageBucket;
  static late String _apiKey;
  static late String _appId;
  static late String _messagingSenderId;
  static late String _environment;

  /// Initialize environment variables from .env file
  static Future<void> initialize() async {
    try {
      await dotenv.load(fileName: '.env');

      _projectId = dotenv.env['FIREBASE_PROJECT_ID'] ?? 'your-project-id';
      _storageBucket =
          dotenv.env['FIREBASE_STORAGE_BUCKET'] ??
          'your-project-id.appspot.com';
      _apiKey = dotenv.env['FIREBASE_API_KEY'] ?? 'your-api-key';
      _appId = dotenv.env['FIREBASE_APP_ID'] ?? 'your-app-id';
      _messagingSenderId =
          dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ??
          'your-messaging-sender-id';
      _environment = dotenv.env['ENVIRONMENT'] ?? 'development';

      print('✅ Environment loaded successfully');
      print('📱 Environment: $_environment');
      print('🔥 Firebase Project: $_projectId');
    } catch (e) {
      print('⚠️  Error loading .env file: $e');
      print('⚠️  Using default values');

      // Set default values if .env file is not found
      _projectId = 'your-project-id';
      _storageBucket = 'your-project-id.appspot.com';
      _apiKey = 'your-api-key';
      _appId = 'your-app-id';
      _messagingSenderId = 'your-messaging-sender-id';
      _environment = 'development';
    }
  }

  /// Get Firebase Project ID
  static String get projectId => _projectId;

  /// Get Firebase Storage Bucket
  static String get storageBucket => _storageBucket;

  /// Get Firebase API Key
  static String get apiKey => _apiKey;

  /// Get Firebase App ID
  static String get appId => _appId;

  /// Get Firebase Messaging Sender ID
  static String get messagingSenderId => _messagingSenderId;

  /// Get current environment (development, staging, production)
  static String get environment => _environment;

  /// Check if in production environment
  static bool get isProduction => _environment == 'production';

  /// Check if in development environment
  static bool get isDevelopment => _environment == 'development';
}
