import 'package:flutter/material.dart';
import 'login_page.dart';
import 'home_screen.dart';
import 'register_page.dart';
import 'admin_home_screen.dart';
import 'create_book_screen.dart';
import 'manage_users_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Library App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const HomeScreen(),
        '/admin': (context) => const AdminHomeScreen(),
        '/admin/users': (context) => const ManageUsersScreen(),
        '/admin/create-book': (context) => const CreateBookScreen(),
      },
    );
  }
}
