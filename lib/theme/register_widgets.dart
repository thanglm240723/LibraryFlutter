import 'package:flutter/material.dart';
import 'package:librarybookshelf/theme/app_theme.dart';
import 'package:librarybookshelf/theme/login_widgets.dart';

// =====================================================================
//  REGISTER VIEW - toàn bộ UI
// =====================================================================
class RegisterView extends StatelessWidget {
  final TextEditingController usernameCtrl;
  final TextEditingController emailCtrl;
  final TextEditingController passwordCtrl;
  final TextEditingController fullNameCtrl;
  final TextEditingController confirmCtrl;
  final bool isLoading;
  final bool obscure;
  final bool obscureConfirm;
  final Animation<double> fadeAnim;
  final Animation<Offset> slideAnim;
  final VoidCallback onRegister;
  final VoidCallback onToggleObscure;
  final VoidCallback onToggleObscureConfirm;

  const RegisterView({
    super.key,
    required this.usernameCtrl,
    required this.emailCtrl,
    required this.passwordCtrl,
    required this.fullNameCtrl,
    required this.confirmCtrl,
    required this.isLoading,
    required this.obscure,
    required this.obscureConfirm,
    required this.fadeAnim,
    required this.slideAnim,
    required this.onRegister,
    required this.onToggleObscure,
    required this.onToggleObscureConfirm,
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
            onPressed: () =>
                Navigator.of(context).pushReplacementNamed('/login'),
            child: RichText(
              text: const TextSpan(
                text: "Đã có tài khoản? ",
                style: TextStyle(color: AppColors.textLight, fontSize: 13),
                children: [
                  TextSpan(
                    text: "Đăng nhập",
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
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Icon(
            Icons.person_add_rounded,
            color: AppColors.accent,
            size: 32,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          "Tạo tài khoản",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
            height: 1.2,
            letterSpacing: -0.8,
          ),
        ),
        const SizedBox(height: 6),
        const Text("Tham gia cộng đồng đọc sách hôm nay", style: AppText.body),
        const SizedBox(height: 32),

        // Họ tên
        const Text("Họ và tên", style: AppText.label),
        const SizedBox(height: 8),
        AppInputField(
          controller: fullNameCtrl,
          hint: "Nhập họ tên (không bắt buộc)",
          icon: Icons.badge_outlined,
        ),
        const SizedBox(height: 16),

        // Username
        const Text("Tên đăng nhập *", style: AppText.label),
        const SizedBox(height: 8),
        AppInputField(
          controller: usernameCtrl,
          hint: "Nhập username",
          icon: Icons.person_outline_rounded,
        ),
        const SizedBox(height: 16),

        // Email
        const Text("Email *", style: AppText.label),
        const SizedBox(height: 8),
        AppInputField(
          controller: emailCtrl,
          hint: "Nhập địa chỉ email",
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),

        // Password
        const Text("Mật khẩu *", style: AppText.label),
        const SizedBox(height: 8),
        AppInputField(
          controller: passwordCtrl,
          hint: "Ít nhất 6 ký tự",
          icon: Icons.lock_outline_rounded,
          obscure: obscure,
          suffix: IconButton(
            onPressed: onToggleObscure,
            icon: Icon(
              obscure
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: AppColors.textLight,
              size: 20,
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Confirm
        const Text("Xác nhận mật khẩu *", style: AppText.label),
        const SizedBox(height: 8),
        AppInputField(
          controller: confirmCtrl,
          hint: "Nhập lại mật khẩu",
          icon: Icons.lock_outline_rounded,
          obscure: obscureConfirm,
          suffix: IconButton(
            onPressed: onToggleObscureConfirm,
            icon: Icon(
              obscureConfirm
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: AppColors.textLight,
              size: 20,
            ),
          ),
        ),
        const SizedBox(height: 32),

        // Nút đăng ký
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: isLoading ? null : onRegister,
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
                    "Đăng ký",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
