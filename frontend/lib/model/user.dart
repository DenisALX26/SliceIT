class User {
  final String id, email, fullName;

  User({required this.id, required this.email, required this.fullName});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['fullName'] as String,
    );
  }
}
