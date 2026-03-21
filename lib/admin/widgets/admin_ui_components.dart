import 'package:flutter/material.dart';
import 'package:librarybookshelf/admin/models/admin_book_model.dart';
import 'package:librarybookshelf/theme/app_theme.dart';

/// ─────────────────────────────────────────────────────────────────
/// COMPONENT CƠ BẢN (THÀNH PHẦN NHỎ)
/// ─────────────────────────────────────────────────────────────────

/// Thanh gạch ngang (Handle) thường dùng ở đầu các BottomSheet
class AdminSheetHandle extends StatelessWidget {
  const AdminSheetHandle({super.key});

  @override
  Widget build(BuildContext context) => Center(
    child: Container(
      width: 36,
      height: 4,
      decoration: BoxDecoration(
        color: AppColors.border,
        borderRadius: BorderRadius.circular(2),
      ),
    ),
  );
}

/// Tiêu đề phân mục (Section Label) nhỏ dùng trong Menu hoặc Danh sách
class AdminSectionLabel extends StatelessWidget {
  final String text;
  const AdminSectionLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w700,
      color: AppColors.textLight,
      letterSpacing: 1.2,
    ),
  );
}

/// ─────────────────────────────────────────────────────────────────
/// INPUT FIELDS (CÁC LOẠI TRƯỜNG NHẬP LIỆU)
/// ─────────────────────────────────────────────────────────────────

/// Component trường nhập văn bản chuẩn (dùng chung cho Profile, Form sách...)
class AdminInputField extends StatelessWidget {
  final TextEditingController ctrl;
  final String label;
  final IconData icon;
  final TextInputType keyboardType;
  final int maxLines;

  const AdminInputField({
    super.key,
    required this.ctrl,
    required this.label,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: AppColors.bg,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.border),
    ),
    child: TextField(
      controller: ctrl,
      keyboardType: keyboardType,
      maxLines: maxLines,
      minLines: 1,
      style: const TextStyle(color: AppColors.textDark, fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.textLight, fontSize: 13),
        prefixIcon: Icon(icon, color: AppColors.textLight, size: 18),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
      ),
    ),
  );
}

/// Component trường nhập mật khẩu (có nút bật/tắt hiển thị)
class AdminPassField extends StatelessWidget {
  final TextEditingController ctrl;
  final String label;
  final bool obscure;
  final VoidCallback onToggle;
  
  const AdminPassField({
    super.key,
    required this.ctrl,
    required this.label,
    required this.obscure,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: AppColors.bg,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.border),
    ),
    child: TextField(
      controller: ctrl,
      obscureText: obscure,
      style: const TextStyle(color: AppColors.textDark, fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.textLight, fontSize: 13),
        prefixIcon: const Icon(
          Icons.lock_outline_rounded,
          color: AppColors.textLight,
          size: 18,
        ),
        suffixIcon: IconButton(
          onPressed: onToggle,
          icon: Icon(
            obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: AppColors.textLight,
            size: 18,
          ),
        ),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
      ),
    ),
  );
}

/// ─────────────────────────────────────────────────────────────────
/// MENU ITEMS (THÀNH PHẦN DANH MỤC LỰA CHỌN)
/// ─────────────────────────────────────────────────────────────────

/// Nhóm các Menu Items lại với nhau (có viền ngoài, bo góc)
class AdminMenuGroup extends StatelessWidget {
  final List<AdminMenuItem> items;
  const AdminMenuGroup({super.key, required this.items});

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppColors.border),
    ),
    child: Column(
      children: items.asMap().entries.map((e) {
        final isLast = e.key == items.length - 1;
        return Column(
          children: [
            e.value,
            if (!isLast)
              const Divider(
                height: 1,
                color: AppColors.divider,
                indent: 52,
                endIndent: 0,
              ),
          ],
        );
      }).toList(),
    ),
  );
}

/// Từng tùy chọn Menu riêng lẻ (chứa Icon, Label, Subtitle)
class AdminMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? sub;
  final VoidCallback onTap;

  const AdminMenuItem({
    super.key,
    required this.icon,
    required this.label,
    this.sub,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(14),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.chip,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.textMid, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
                if (sub != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    sub!,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textLight,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textLight,
            size: 18,
          ),
        ],
      ),
    ),
  );
}

/// ─────────────────────────────────────────────────────────────────
/// CARDS & PREVIEWS (CÁC THẺ HIỂN THỊ)
/// ─────────────────────────────────────────────────────────────────

/// Card hiển thị thông tin tóm tắt của một cuốn sách
class AdminBookCard extends StatelessWidget {
  final AdminBookModel book;
  final VoidCallback onTap;

  const AdminBookCard({super.key, required this.book, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Cover image or placeholder
              Container(
                width: 60,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.chip,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                ),
                child: book.coverImageUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          book.coverImageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.auto_stories_rounded,
                              color: AppColors.textLight,
                              size: 28,
                            );
                          },
                        ),
                      )
                    : const Icon(
                        Icons.auto_stories_rounded,
                        color: AppColors.textLight,
                        size: 28,
                      ),
              ),
              const SizedBox(width: 12),

              // Book info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      book.author,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textMid,
                      ),
                    ),
                    if (book.genre != null) ...[
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: AppColors.accent.withOpacity(0.25),
                          ),
                        ),
                        child: Text(
                          book.genre ?? '',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppColors.accent,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Arrow icon
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textLight,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Preview hình ảnh của sách có tính năng xem full screen
class AdminImagePreview extends StatelessWidget {
  final String imageUrl;

  const AdminImagePreview({super.key, required this.imageUrl});

  void _showFullScreenImage(BuildContext context) {
    if (imageUrl.isEmpty) return;
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: InteractiveViewer(
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.broken_image, size: 64, color: Colors.white),
                    SizedBox(height: 16),
                    Text(
                      'Không thể tải hình ảnh',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showFullScreenImage(context),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: double.infinity,
          height: 300,
          child: imageUrl.isNotEmpty
              ? Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: AppColors.bg,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.accent,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: AppColors.chip,
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.broken_image,
                            color: AppColors.textLight,
                            size: 48,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'URL hình ảnh không hợp lệ',
                            style: TextStyle(color: AppColors.textLight),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : Container(
                  color: AppColors.chip,
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image_not_supported,
                          color: AppColors.textLight,
                          size: 48,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Chưa nhập URL hình ảnh',
                          style: TextStyle(color: AppColors.textLight),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
