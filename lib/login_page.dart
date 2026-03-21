import 'package:flutter/material.dart';
import 'package:librarybookshelf/services/auther_service.dart';
import 'package:librarybookshelf/theme/app_theme.dart';
import 'package:librarybookshelf/theme/login_widgets.dart';

// =====================================================================
//  LOGIN PAGE - chỉ chứa STATE LOGIC
// =====================================================================
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  // Controllers
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  // State
  bool _isLoading = false;
  bool _obscureText = true;

  // Animation
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ── LOGIC: Đăng nhập ─────────────────────────────────────────────
  Future<void> _login() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      AppSnack.show(context, "Vui lòng nhập đầy đủ thông tin", isError: true);
      return;
    }

    setState(() => _isLoading = true);

    final data = await AuthService.login(username, password);

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (data != null) {
      AppSnack.show(
        context,
        "Chào mừng trở lại, ${data['fullName']}!",
        isSuccess: true,
      );
      // Kiểm tra nếu là admin
      final isAdmin = data['role'] == 'admin';
      final route = isAdmin ? '/admin-profile' : '/home';
      Navigator.of(context).pushReplacementNamed(route);
    } else {
      AppSnack.show(context, "Sai tên đăng nhập hoặc mật khẩu", isError: true);
    }
  }


  void _toggleObscure() => setState(() => _obscureText = !_obscureText);

  @override
  Widget build(BuildContext context) {
    // Delegate toàn bộ UI sang LoginView widget
    return LoginView(
      usernameController: _usernameController,
      passwordController: _passwordController,
      isLoading: _isLoading,
      obscureText: _obscureText,
      fadeAnim: _fadeAnim,
      slideAnim: _slideAnim,
      onLogin: _login,
      onToggleObscure: _toggleObscure,
    );
  }
}
