class HabitUser {
  final int? userHabitId;
  final String? name;
  final int? habitType;

  HabitUser({
    required this.userHabitId,
    this.name,
    this.habitType,
  });

  factory HabitUser.fromJson(Map<String, dynamic> json) {
    return HabitUser(
      userHabitId: _parseId(json['user_habit_id'] ?? json['userHabitId']),
      name: json['name'] ?? json['nombre'],
      habitType: _parseId(json['habit_type_id'] ?? json['habitTypeId']),
    );
  }

  static int _parseId(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.parse(value);
    return 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'user_habit_id': userHabitId,
      'name': name,
      'habit_type_id': habitType,
    };
  }

  @override
  String toString() {
    return 'HabitUser{userHabitId: $userHabitId, name: $name, habitType: $habitType}';
  }
}
