class User {
  final int id;
  final String username;
  final String fullName;
  final String email;
  final String? avatarUrl;
  final String token;

  User({
    required this.id,
    required this.username,
    required this.fullName,
    required this.email,
    this.avatarUrl,
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      avatarUrl: json['avatarUrl'],
      token: json['token'] ?? '',
    );
  }
}
