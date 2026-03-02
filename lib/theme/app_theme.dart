import 'package:flutter/material.dart';

// =====================================================================
//  MÀU SẮC - dùng chung toàn app
// =====================================================================
class AppColors {
  // Backgrounds
  static const bg = Color(0xFFFAF7F2);
  static const surface = Color(0xFFFFFFFF);
  static const card = Color(0xFF1C1712);

  // Accent / Gold
  static const accent = Color(0xFFD4A853);
  static const accentL = Color(0xFFF5E6C8);

  // Text
  static const textDark = Color(0xFF1C1712);
  static const textMid = Color(0xFF6B5B45);
  static const textLight = Color(0xFFA89880);

  // Border / Chip
  static const border = Color(0xFFE0D8CC);
  static const chip = Color(0xFFEDE8DF);
  static const divider = Color(0xFFEAE4D8);

  // Status
  static const success = Color(0xFF4CAF50);

  // Dark mode
  static const darkBg = Color(0xFF181410);
  static const darkSurface = Color(0xFF242018);
  static const darkBorder = Color(0xFF3A3028);
  static const darkTextSub = Color(0xFF8A7A6A);
}

// =====================================================================
//  TEXT STYLES
// =====================================================================
class AppText {
  // Headings
  static const h1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    color: AppColors.textDark,
    height: 1.15,
    letterSpacing: -1,
  );
  static const h2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w800,
    color: AppColors.textDark,
    height: 1.2,
    letterSpacing: -0.5,
  );
  static const h3 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
    letterSpacing: 0.3,
  );
  static const h4 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
  );

  // Body
  static const body = TextStyle(
    fontSize: 14,
    color: AppColors.textMid,
    height: 1.7,
  );
  static const bodySmall = TextStyle(fontSize: 13, color: AppColors.textMid);
  static const caption = TextStyle(fontSize: 11, color: AppColors.textLight);
  static const label = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
  );

  // Accent
  static const accentLabel = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: Color(0xFF8B6914),
  );
  static const accentCaption = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w800,
    color: AppColors.accent,
    letterSpacing: 2,
  );
}

// =====================================================================
//  DECORATIONS - BoxDecoration tái sử dụng
// =====================================================================
class AppDecorations {
  // Card trắng với shadow nhẹ
  static BoxDecoration get whiteCard => BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(14),
    boxShadow: [
      BoxShadow(
        color: AppColors.textDark.withOpacity(0.05),
        blurRadius: 12,
        offset: const Offset(0, 4),
      ),
    ],
  );

  // Card dark (nút chính)
  static BoxDecoration get darkCard => BoxDecoration(
    color: AppColors.card,
    borderRadius: BorderRadius.circular(12),
  );

  // Input field
  static BoxDecoration get inputField => BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: AppColors.border),
    boxShadow: [
      BoxShadow(
        color: AppColors.textDark.withOpacity(0.04),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  );

  // Genre tag
  static BoxDecoration get genreTag => BoxDecoration(
    color: AppColors.accentL,
    borderRadius: BorderRadius.circular(8),
  );

  // Chip đã chọn
  static BoxDecoration get chipSelected => BoxDecoration(
    color: AppColors.card,
    borderRadius: BorderRadius.circular(20),
  );

  // Chip chưa chọn
  static BoxDecoration get chipUnselected => BoxDecoration(
    color: AppColors.chip,
    borderRadius: BorderRadius.circular(20),
  );

  // Bottom bar
  static BoxDecoration get bottomBar => BoxDecoration(
    color: AppColors.surface,
    border: const Border(top: BorderSide(color: AppColors.border, width: 1)),
  );

  // Top bar reading
  static BoxDecoration topBarReading(bool isDark) => BoxDecoration(
    color: (isDark ? AppColors.darkSurface : AppColors.surface).withOpacity(
      0.97,
    ),
    border: Border(
      bottom: BorderSide(
        color: isDark ? AppColors.darkBorder : AppColors.border,
        width: 1,
      ),
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  );

  // Settings panel reading
  static BoxDecoration settingsPanel(bool isDark) => BoxDecoration(
    color: isDark ? AppColors.darkBg : AppColors.bg,
    borderRadius: BorderRadius.circular(14),
    border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
  );
}

// =====================================================================
//  BUTTON STYLES
// =====================================================================
class AppButtons {
  static ButtonStyle get primary => ElevatedButton.styleFrom(
    backgroundColor: AppColors.card,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    elevation: 0,
  );

  static ButtonStyle get primaryDisabled => ElevatedButton.styleFrom(
    backgroundColor: AppColors.card,
    disabledBackgroundColor: AppColors.card.withOpacity(0.4),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    elevation: 0,
  );

  static ButtonStyle get outlined => OutlinedButton.styleFrom(
    side: const BorderSide(color: AppColors.border, width: 1.5),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
  );

  static ButtonStyle get accentOutlined => OutlinedButton.styleFrom(
    side: const BorderSide(color: AppColors.accent),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  );

  static ButtonStyle get dialogAction => ElevatedButton.styleFrom(
    backgroundColor: AppColors.card,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    elevation: 0,
  );
}

// =====================================================================
//  SNACKBAR HELPER
// =====================================================================
class AppSnack {
  static void show(
    BuildContext context,
    String msg, {
    bool isError = false,
    bool isSuccess = false,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError
            ? Colors.red.shade600
            : isSuccess
            ? AppColors.success
            : AppColors.card,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}
