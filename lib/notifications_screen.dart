import 'package:flutter/material.dart';
import 'package:librarybookshelf/theme/app_theme.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<Map<String, dynamic>> _items = List.generate(
    8,
    (i) => {
      'title': 'Thông báo #' + (i + 1).toString(),
      'body': 'Nội dung thông báo mẫu cho mục ${i + 1}',
      'read': i % 3 == 0,
    },
  );

  void _markAllRead() =>
      setState(() => _items.forEach((m) => m['read'] = true));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông báo'),
        actions: [
          TextButton(
            onPressed: _markAllRead,
            child: const Text(
              'Đánh dấu đã đọc',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemBuilder: (_, i) {
          final item = _items[i];
          return ListTile(
            tileColor: item['read'] ? AppColors.bg : AppColors.accentL,
            leading: Icon(
              item['read']
                  ? Icons.notifications_none
                  : Icons.notifications_active,
              color: AppColors.accent,
            ),
            title: Text(
              item['title'],
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            subtitle: Text(item['body']),
            trailing: IconButton(
              icon: Icon(
                item['read'] ? Icons.mark_email_read : Icons.mark_email_unread,
              ),
              onPressed: () => setState(() => item['read'] = !item['read']),
            ),
            onTap: () => setState(() => item['read'] = true),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemCount: _items.length,
      ),
    );
  }
}
