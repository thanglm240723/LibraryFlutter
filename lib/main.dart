import 'package:flutter/material.dart';
import 'login_page.dart';
import 'home_screen.dart';
import 'register_page.dart';
import 'profile_screen.dart';
import 'admin/screens/admin_profile_screen.dart';
import 'admin/screens/admin_book_list_screen.dart';
import 'admin/screens/admin_home_screen.dart';
import 'services/auther_service.dart';
import 'services/env_loader.dart';
import 'services/firebase_config.dart';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize environment variables from .env file
  await EnvLoader.initialize();

  // Initialize Firebase
  await FirebaseConfig.initialize();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _initialRoute = '/home';
  bool _isCheckingRoute = true;

  @override
  void initState() {
    super.initState();
    _checkInitialRoute();
  }

  Future<void> _checkInitialRoute() async {
    final isLoggedIn = await AuthService.isLoggedIn();
    if (isLoggedIn) {
      final role = await AuthService.getRole();
      setState(() {
        _initialRoute = role == 'admin' ? '/admin-profile' : '/home';
        _isCheckingRoute = false;
      });
    } else {
      setState(() {
        _initialRoute = '/login';
        _isCheckingRoute = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isCheckingRoute) {
      return MaterialApp(
        title: 'Library App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }
    return MaterialApp(
      title: 'Library App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: _buildInitialScreen(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const HomeScreen(),
        '/admin': (context) => const AdminHomeScreen(),
        '/admin-profile': (context) => const AdminProfileScreen(),
      },
    );
  }

  Widget _buildInitialScreen() {
    if (_initialRoute == '/admin-profile') {
      return const AdminProfileScreen();
    } else if (_initialRoute == '/home') {
      return const HomeScreen();
    } else {
      return const LoginPage();
    }
  }
}
