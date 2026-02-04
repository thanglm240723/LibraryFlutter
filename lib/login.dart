import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart'; // Để check kIsWeb
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// --- CẤU HÌNH BỎ QUA LỖI SSL (CHỈ DÙNG CHO DEV/LOCALHOST) ---
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
// -----------------------------------------------------------

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controllers quản lý text input
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Trạng thái loading
  bool _isLoading = false;
  // Trạng thái ẩn/hiện mật khẩu
  bool _obscureText = true;

  // Hàm xử lý Login
  Future<void> _login() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      _showSnackBar("Vui lòng nhập đầy đủ thông tin", isError: true);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Xử lý URL cho Android Emulator vs iOS/Web
      String baseUrl = "https://localhost:7094/api/Auth/login";
      if (!kIsWeb && Platform.isAndroid) {
        // Android Emulator dùng 10.0.2.2 thay cho localhost
        baseUrl = "https://10.0.2.2:7094/api/Auth/login";
      }

      print("Connecting to: $baseUrl");

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          "Content-Type": "application/json",
          // "Accept": "application/json",
        },
        body: jsonEncode({
          "username":
              username, // Key này phải khớp với API yêu cầu (hoặc là email)
          "password": password,
        }),
      );

      print("Response Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        // 1. Parse dữ liệu
        final data = jsonDecode(response.body);

        // 2. Lưu Token vào bộ nhớ máy
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);
        await prefs.setString('fullName', data['fullName']);
        await prefs.setInt('userId', data['id']);

        _showSnackBar("Đăng nhập thành công! Xin chào ${data['fullName']}");

        // 3. Chuyển màn hình (Ví dụ sang Home)
        if (mounted) {
          Navigator.of(context).pushReplacementNamed('/home');
          // Hoặc: Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
        }
      } else {
        _showSnackBar("Đăng nhập thất bại: ${response.body}", isError: true);
      }
    } catch (e) {
      print("Error: $e");
      _showSnackBar("Lỗi kết nối: $e", isError: true);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo hoặc Hình ảnh
              Container(
                height: 120,
                width: 120,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blueAccent, // Thay bằng Image.asset nếu có
                ),
                child: const Icon(
                  Icons.library_books,
                  size: 60,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),

              const Text(
                "Welcome Back!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Sign in to continue to Library",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 40),

              // Username Field
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: "Username",
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),
              const SizedBox(height: 20),

              // Password Field
              TextField(
                controller: _passwordController,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),

              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {}, // Thêm chức năng quên mật khẩu nếu cần
                  child: const Text("Forgot Password?"),
                ),
              ),
              const SizedBox(height: 20),

              // Login Button
              SizedBox(
                height: 55,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "LOGIN",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
