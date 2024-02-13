class UserData {
  // final int id;
  final String username;
  final String password;
  final String role;

  UserData({
    // required this.id,
    required this.username,
    required this.password,
    required this.role,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      // id: json['id'],
      username: json['username'],
      password: json['password'],
      role: json['role'],
    );
  }
}
