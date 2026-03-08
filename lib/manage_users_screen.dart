import 'package:flutter/material.dart';
import 'package:librarybookshelf/models/user_model.dart';
import 'package:librarybookshelf/services/user_service.dart';
import 'package:librarybookshelf/theme/app_theme.dart';

class ManageUsersScreen extends StatefulWidget {
  const ManageUsersScreen({super.key});

  @override
  State<ManageUsersScreen> createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
  late Future<List<User>> _futureUsers;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _futureUsers = UserService.fetchUsers();
  }

  void _refreshUsers() {
    setState(() {
      _futureUsers = UserService.fetchUsers();
    });
  }

  void _onSearch(String query) {
    // Filter locally or call API with search param
    // For simplicity, we'll just refresh all
    _refreshUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('Quản lý người dùng'),
        backgroundColor: AppColors.card,
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _refreshUsers),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onSubmitted: _onSearch,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<User>>(
              future: _futureUsers,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error, color: Colors.red[300], size: 60),
                        const SizedBox(height: 16),
                        Text(
                          'Lỗi tải dữ liệu',
                          style: TextStyle(color: AppColors.textDark),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          snapshot.error.toString(),
                          style: const TextStyle(color: AppColors.textLight),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _refreshUsers,
                          child: const Text('Thử lại'),
                        ),
                      ],
                    ),
                  );
                }
                final users = snapshot.data ?? [];
                if (users.isEmpty) {
                  return const Center(child: Text('Chưa có người dùng nào.'));
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return _UserCard(
                      user: user,
                      onEdit: () => _showUserDialog(user: user),
                      onDelete: () => _confirmDelete(user),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showUserDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showUserDialog({User? user}) {
    final isEditing = user != null;
    final formKey = GlobalKey<FormState>();

    final usernameCtrl = TextEditingController(text: user?.username ?? '');
    final emailCtrl = TextEditingController(text: user?.email ?? '');
    final fullNameCtrl = TextEditingController(text: user?.fullName ?? '');
    final passwordCtrl = TextEditingController();
    String selectedRole = user?.role ?? 'user';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isEditing ? 'Sửa người dùng' : 'Thêm người dùng'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: usernameCtrl,
                  decoration: const InputDecoration(labelText: 'Tên đăng nhập'),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Vui lòng nhập' : null,
                ),
                TextFormField(
                  controller: emailCtrl,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Vui lòng nhập' : null,
                ),
                TextFormField(
                  controller: fullNameCtrl,
                  decoration: const InputDecoration(labelText: 'Họ tên'),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Vui lòng nhập' : null,
                ),
                if (!isEditing)
                  TextFormField(
                    controller: passwordCtrl,
                    decoration: const InputDecoration(labelText: 'Mật khẩu'),
                    obscureText: true,
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Vui lòng nhập' : null,
                  ),
                if (isEditing)
                  TextFormField(
                    controller: passwordCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Mật khẩu mới (để trống nếu không đổi)',
                    ),
                    obscureText: true,
                  ),
                DropdownButtonFormField<String>(
                  value: selectedRole,
                  decoration: const InputDecoration(labelText: 'Vai trò'),
                  items: const [
                    DropdownMenuItem(value: 'user', child: Text('User')),
                    DropdownMenuItem(value: 'admin', child: Text('Admin')),
                  ],
                  onChanged: (v) => selectedRole = v!,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;
              try {
                if (isEditing) {
                  await UserService.updateUser(
                    id: user!.id,
                    username: usernameCtrl.text,
                    email: emailCtrl.text,
                    fullName: fullNameCtrl.text,
                    role: selectedRole,
                    password: passwordCtrl.text.isNotEmpty
                        ? passwordCtrl.text
                        : null,
                  );
                } else {
                  await UserService.createUser(
                    username: usernameCtrl.text,
                    email: emailCtrl.text,
                    fullName: fullNameCtrl.text,
                    password: passwordCtrl.text,
                    role: selectedRole,
                  );
                }
                if (mounted) {
                  Navigator.pop(ctx);
                  _refreshUsers();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isEditing ? 'Cập nhật thành công' : 'Thêm thành công',
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Lỗi: ${e.toString()}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: Text(isEditing ? 'Cập nhật' : 'Thêm'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(User user) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc muốn xóa người dùng "${user.username}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              try {
                await UserService.deleteUser(user.id);
                if (mounted) {
                  Navigator.pop(ctx);
                  _refreshUsers();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Xóa thành công'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Lỗi: ${e.toString()}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }
}

// Widget hiển thị một user trong danh sách
class _UserCard extends StatelessWidget {
  final User user;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _UserCard({
    required this.user,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: user.role == 'admin'
                  ? Colors.amber
                  : Colors.blue,
              child: Text(
                user.fullName[0].toUpperCase(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.fullName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '@${user.username}',
                    style: const TextStyle(color: AppColors.textLight),
                  ),
                  const SizedBox(height: 2),
                  Text(user.email, style: const TextStyle(fontSize: 12)),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: user.role == 'admin'
                          ? Colors.amber.shade100
                          : Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      user.role == 'admin' ? 'Admin' : 'User',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: user.role == 'admin'
                            ? Colors.amber.shade900
                            : Colors.blue.shade900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: AppColors.accent),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
