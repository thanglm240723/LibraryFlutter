import 'package:flutter/material.dart';
import 'package:librarybookshelf/services/auther_service.dart';
import 'package:librarybookshelf/theme/app_theme.dart';
import 'package:librarybookshelf/theme/register_widgets.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  // Controllers
  final _usernameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _fullNameCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  // State
  bool _isLoading = false;
  bool _obscure = true;
  bool _obscureConfirm = true;

  // Animation
  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut));
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _usernameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _fullNameCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  // ── LOGIC: Validate + Đăng ký ────────────────────────────────────
  Future<void> _register() async {
    final username = _usernameCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    final password = _passwordCtrl.text;
    final confirm = _confirmCtrl.text;
    final fullName = _fullNameCtrl.text.trim();

    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      AppSnack.show(
        context,
        "Vui lòng nhập đầy đủ thông tin bắt buộc",
        isError: true,
      );
      return;
    }
    if (password != confirm) {
      AppSnack.show(context, "Mật khẩu xác nhận không khớp", isError: true);
      return;
    }
    if (password.length < 6) {
      AppSnack.show(context, "Mật khẩu phải ít nhất 6 ký tự", isError: true);
      return;
    }

    setState(() => _isLoading = true);

    final success = await AuthService.register(
      username: username,
      email: email,
      password: password,
      fullName: fullName.isEmpty ? null : fullName,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      AppSnack.show(
        context,
        "Đăng ký thành công! Vui lòng đăng nhập.",
        isSuccess: true,
      );
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) Navigator.of(context).pushReplacementNamed('/login');
    } else {
      AppSnack.show(
        context,
        "Tên đăng nhập hoặc email đã tồn tại",
        isError: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return RegisterView(
      usernameCtrl: _usernameCtrl,
      emailCtrl: _emailCtrl,
      passwordCtrl: _passwordCtrl,
      fullNameCtrl: _fullNameCtrl,
      confirmCtrl: _confirmCtrl,
      isLoading: _isLoading,
      obscure: _obscure,
      obscureConfirm: _obscureConfirm,
      fadeAnim: _fadeAnim,
      slideAnim: _slideAnim,
      onRegister: _register,
      onToggleObscure: () => setState(() => _obscure = !_obscure),
      onToggleObscureConfirm: () =>
          setState(() => _obscureConfirm = !_obscureConfirm),
    );
  }
}
