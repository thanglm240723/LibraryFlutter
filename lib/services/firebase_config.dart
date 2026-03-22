import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'env_loader.dart';

/// Firebase configuration service
/// Handles Firebase initialization with environment-specific settings
/// Loads configuration from .env file via EnvLoader
class FirebaseConfig {
  /// Get Firebase options dựa trên nền tảng hiện tại
  static FirebaseOptions getFirebaseOptions() {
    final projectId = EnvLoader.projectId;
    final storageBucket = EnvLoader.storageBucket;
    final apiKey = EnvLoader.apiKey;
    final appId = EnvLoader.appId;
    final messagingSenderId = EnvLoader.messagingSenderId;

    if (kIsWeb) {
      return FirebaseOptions(
        apiKey: apiKey,
        appId: appId,
        messagingSenderId: messagingSenderId,
        projectId: projectId,
        storageBucket: storageBucket,
      );
    } else {
      // For Android, iOS, etc.
      return FirebaseOptions(
        apiKey: apiKey,
        appId: appId,
        messagingSenderId: messagingSenderId,
        projectId: projectId,
        storageBucket: storageBucket,
      );
    }
  }

  /// Initialize Firebase with environment-specific configuration
  static Future<void> initialize() async {
    try {
      // Load environment variables first
      await EnvLoader.initialize();

      await Firebase.initializeApp(options: getFirebaseOptions());

      print('✅ Firebase initialized successfully');
    } catch (e) {
      print('❌ Firebase initialization error: $e');
      rethrow;
    }
  }

  /// Firebase Storage bucket name
  static String get storageBucket => EnvLoader.storageBucket;

  /// Firebase Project ID
  static String get projectId => EnvLoader.projectId;
}
