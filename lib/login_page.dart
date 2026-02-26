import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// =====================================================================
//  COLORS (đồng bộ toàn app)
// =====================================================================
class _C {
  static const bg = Color(0xFFFAF7F2);
  static const card = Color(0xFF1C1712);
  static const accent = Color(0xFFD4A853);
  static const accentL = Color(0xFFF5E6C8);
  static const textD = Color(0xFF1C1712);
  static const textM = Color(0xFF6B5B45);
  static const textL = Color(0xFFA89880);
  static const border = Color(0xFFE0D8CC);
}

// =====================================================================
//  LOGIN PAGE
// =====================================================================
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscureText = true;

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

  // ── Login logic ───────────────────────────────────────────────────
  Future<void> _login() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();
    if (username.isEmpty || password.isEmpty) {
      _showSnack("Vui lòng nhập đầy đủ thông tin", isError: true);
      return;
    }

    setState(() => _isLoading = true);
    try {
      String baseUrl = kIsWeb
          ? "https://localhost:7094/api/Auth/login"
          : Platform.isAndroid
          ? "https://10.0.2.2:7094/api/Auth/login"
          : "https://localhost:7094/api/Auth/login";

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"username": username, "password": password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token'] ?? '');
        await prefs.setString('fullName', data['fullName'] ?? '');
        await prefs.setInt('userId', data['id'] ?? 0);

        _showSnack("Chào mừng trở lại, ${data['fullName']}!", isSuccess: true);
        if (mounted) Navigator.of(context).pushReplacementNamed('/home');
      } else {
        _showSnack("Sai tên đăng nhập hoặc mật khẩu", isError: true);
      }
    } catch (e) {
      _showSnack("Lỗi kết nối: $e", isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnack(String msg, {bool isError = false, bool isSuccess = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError
            ? Colors.red.shade600
            : isSuccess
            ? const Color(0xFF4CAF50)
            : _C.card,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  // =====================================================================
  //  BUILD
  // =====================================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _C.bg,
      body: SafeArea(
        child: Column(
          children: [
            // ── TOP BAR với nút Back ──────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
              child: Row(
                children: [
                  // Nút back
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: _C.textD,
                      size: 20,
                    ),
                  ),
                  const Spacer(),
                  // Nút chuyển sang Đăng ký
                  TextButton(
                    onPressed: () =>
                        Navigator.of(context).pushNamed('/register'),
                    child: RichText(
                      text: const TextSpan(
                        text: "Chưa có tài khoản? ",
                        style: TextStyle(color: _C.textL, fontSize: 13),
                        children: [
                          TextSpan(
                            text: "Đăng ký",
                            style: TextStyle(
                              color: _C.accent,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── BODY ─────────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: SlideTransition(
                    position: _slideAnim,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── ICON ────────────────────────────────
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: _C.card,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: const Icon(
                            Icons.auto_stories,
                            color: _C.accent,
                            size: 32,
                          ),
                        ),
                        const SizedBox(height: 28),

                        // ── HEADLINE ─────────────────────────────
                        const Text(
                          "Chào mừng\ntrở lại!",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            color: _C.textD,
                            height: 1.15,
                            letterSpacing: -1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Đăng nhập để tiếp tục hành trình đọc sách",
                          style: TextStyle(fontSize: 14, color: _C.textL),
                        ),
                        const SizedBox(height: 40),

                        // ── USERNAME ──────────────────────────────
                        _buildLabel("Tên đăng nhập"),
                        const SizedBox(height: 8),
                        _buildTextField(
                          controller: _usernameController,
                          hint: "Nhập username của bạn",
                          icon: Icons.person_outline_rounded,
                        ),
                        const SizedBox(height: 20),

                        // ── PASSWORD ──────────────────────────────
                        _buildLabel("Mật khẩu"),
                        const SizedBox(height: 8),
                        _buildTextField(
                          controller: _passwordController,
                          hint: "Nhập mật khẩu",
                          icon: Icons.lock_outline_rounded,
                          obscure: _obscureText,
                          suffix: IconButton(
                            onPressed: () =>
                                setState(() => _obscureText = !_obscureText),
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: _C.textL,
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Quên mật khẩu
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text(
                              "Quên mật khẩu?",
                              style: TextStyle(
                                color: _C.accent,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // ── NÚT ĐĂNG NHẬP ─────────────────────────
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _C.card,
                              disabledBackgroundColor: _C.card.withOpacity(0.4),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 0,
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      color: _C.accent,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    "Đăng nhập",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // ── DIVIDER ─────────────────────────────────
                        Row(
                          children: [
                            const Expanded(child: Divider(color: _C.border)),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              child: Text(
                                "hoặc",
                                style: TextStyle(
                                  color: _C.textL.withOpacity(0.8),
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            const Expanded(child: Divider(color: _C.border)),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // ── NÚT ĐĂNG KÝ (outline) ──────────────────
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: OutlinedButton(
                            onPressed: () =>
                                Navigator.of(context).pushNamed('/register'),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                color: _C.border,
                                width: 1.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: const Text(
                              "Tạo tài khoản mới",
                              style: TextStyle(
                                color: _C.textM,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Text(
    text,
    style: const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w600,
      color: _C.textD,
    ),
  );

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    Widget? suffix,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _C.border),
        boxShadow: [
          BoxShadow(
            color: _C.textD.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: const TextStyle(color: _C.textD, fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: _C.textL, fontSize: 14),
          prefixIcon: Icon(icon, color: _C.textL, size: 20),
          suffixIcon: suffix,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}
