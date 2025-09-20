class User {
  final int user;
  final String name;

  User({
    required this.user,
    required this.name
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      user: int.parse(json['user']),
      name: json['name'] ?? '',
    );
  }

  existsUser() {
    return user != 0;
  }

  @override
  String toString() {
    return 'User{user: $user, name: $name}';
  }
}