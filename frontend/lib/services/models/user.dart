class User {
  final int user;
  final String name;

  User({
    required this.user,
    required this.name
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      user: json['user'],
      name: json['name'],
    );
  }

  existsUser() {
    return user != 0;
  }
}