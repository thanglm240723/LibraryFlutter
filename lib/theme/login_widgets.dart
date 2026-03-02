import 'package:flutter/material.dart';
import 'package:librarybookshelf/theme/app_theme.dart';

// =====================================================================
//  LOGIN VIEW - toàn bộ UI, nhận data từ LoginPage
// =====================================================================
class LoginView extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final bool isLoading;
  final bool obscureText;
  final Animation<double> fadeAnim;
  final Animation<Offset> slideAnim;
  final VoidCallback onLogin;
  final VoidCallback onToggleObscure;

  const LoginView({
    super.key,
    required this.usernameController,
    required this.passwordController,
    required this.isLoading,
    required this.obscureText,
    required this.fadeAnim,
    required this.slideAnim,
    required this.onLogin,
    required this.onToggleObscure,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                child: FadeTransition(
                  opacity: fadeAnim,
                  child: SlideTransition(
                    position: slideAnim,
                    child: _buildForm(context),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.textDark,
              size: 20,
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: () => Navigator.of(context).pushNamed('/register'),
            child: RichText(
              text: const TextSpan(
                text: "Chưa có tài khoản? ",
                style: TextStyle(color: AppColors.textLight, fontSize: 13),
                children: [
                  TextSpan(
                    text: "Đăng ký",
                    style: TextStyle(
                      color: AppColors.accent,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Icon
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Icon(
            Icons.auto_stories,
            color: AppColors.accent,
            size: 32,
          ),
        ),
        const SizedBox(height: 28),

        // Headline
        const Text("Chào mừng\ntrở lại!", style: AppText.h1),
        const SizedBox(height: 8),
        const Text(
          "Đăng nhập để tiếp tục hành trình đọc sách",
          style: AppText.body,
        ),
        const SizedBox(height: 40),

        // Username
        const Text("Tên đăng nhập", style: AppText.label),
        const SizedBox(height: 8),
        AppInputField(
          controller: usernameController,
          hint: "Nhập username của bạn",
          icon: Icons.person_outline_rounded,
        ),
        const SizedBox(height: 20),

        // Password
        const Text("Mật khẩu", style: AppText.label),
        const SizedBox(height: 8),
        AppInputField(
          controller: passwordController,
          hint: "Nhập mật khẩu",
          icon: Icons.lock_outline_rounded,
          obscure: obscureText,
          suffix: IconButton(
            onPressed: onToggleObscure,
            icon: Icon(
              obscureText
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: AppColors.textLight,
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
                color: AppColors.accent,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 32),

        // Nút đăng nhập
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: isLoading ? null : onLogin,
            style: AppButtons.primaryDisabled,
            child: isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      color: AppColors.accent,
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

        // Divider
        Row(
          children: [
            const Expanded(child: Divider(color: AppColors.border)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                "hoặc",
                style: TextStyle(
                  color: AppColors.textLight.withOpacity(0.8),
                  fontSize: 13,
                ),
              ),
            ),
            const Expanded(child: Divider(color: AppColors.border)),
          ],
        ),
        const SizedBox(height: 24),

        // Nút đăng ký (outline)
        SizedBox(
          width: double.infinity,
          height: 52,
          child: OutlinedButton(
            onPressed: () => Navigator.of(context).pushNamed('/register'),
            style: AppButtons.outlined,
            child: const Text(
              "Tạo tài khoản mới",
              style: TextStyle(
                color: AppColors.textMid,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// =====================================================================
//  SHARED WIDGETS - dùng lại ở nhiều màn
// =====================================================================

/// Input field dùng chung cho login, register
class AppInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool obscure;
  final Widget? suffix;
  final TextInputType? keyboardType;

  const AppInputField({
    super.key,
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscure = false,
    this.suffix,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecorations.inputField,
      child: TextField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboardType,
        style: const TextStyle(color: AppColors.textDark, fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: AppColors.textLight, fontSize: 14),
          prefixIcon: Icon(icon, color: AppColors.textLight, size: 20),
          suffixIcon: suffix,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}
