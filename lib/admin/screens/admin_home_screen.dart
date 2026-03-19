import 'package:flutter/material.dart';
import 'package:librarybookshelf/theme/app_theme.dart';
import 'tabs/admin_overview_tab.dart';
import 'tabs/admin_users_tab.dart';
import 'tabs/admin_booking_tab.dart';
import 'tabs/admin_account_tab.dart';
import '../widgets/admin_app_bar.dart';
import '../widgets/admin_bottom_nav_bar.dart';

/// Màn hình chính Admin: bottom nav với 4 tab (Tổng quan, User, Booking, Tài khoản).
class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int _currentIndex = 0;

  static const List<String> _titles = [
    'Tổng quan',
    'User',
    'Booking',
    'Tài khoản',
  ];

  static const List<Widget> _tabs = [
    AdminOverviewTab(),
    AdminUsersTab(),
    AdminBookingTab(),
    AdminAccountTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AdminAppBar(
        title: _titles[_currentIndex],
        showBackButton: false,
      ),
      body: _tabs[_currentIndex],
      bottomNavigationBar: AdminBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
