class User {
  final int user;
  final String name;
  final int? age;
  final String? gender;
  final String? wakeUp;
  final String? goToBed;
  final String? addDate;
  final String? firebaseUid;

  User({
    required this.user,
    required this.name,
    this.age,
    this.gender,
    this.wakeUp,
    this.goToBed,
    this.addDate,
    this.firebaseUid,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      user: _parseId(json['user']),
      name: json['name'] ?? '',
      age: json['age'] != null ? int.tryParse(json['age'].toString()) : null,
      gender: json['gender'] as String?,
      wakeUp: json['wake_up'] ?? json['wakeUp'] as String?,
      goToBed: json['go_to_bed'] ?? json['goToBed'] as String?,
      addDate: json['add_date'] ?? json['addDate'] as String?,
      firebaseUid: json['firebase_uid'] ?? json['firebaseUid'] as String?,
    );
  }

  static int _parseId(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.parse(value);
    return 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user,
      'name': name,
      'age': age,
      'gender': gender,
      'wake_up': wakeUp,
      'go_to_bed': goToBed,
      'add_date': addDate,
      'firebase_uid': firebaseUid,
    };
  }

  bool existsUser() {
    return user != 0;
  }

  @override
  String toString() {
    return 'User{user: $user, name: $name, age: $age, gender: $gender, wakeUp: $wakeUp, goToBed: $goToBed, addDate: $addDate, firebaseUid: $firebaseUid}';
  }
}