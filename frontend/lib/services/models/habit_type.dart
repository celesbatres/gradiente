class HabitType {
  final int habitTypeId;
  final String name;

  HabitType({
    required this.habitTypeId,
    required this.name,
  });

  factory HabitType.fromJson(Map<String, dynamic> json) {
    return HabitType(
      habitTypeId: _parseId(json['habit_type_id'] ?? json['habitTypeId'] ?? json['habit_type']),
      name: json['name'] ?? '',
    );
  }

  static int _parseId(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.parse(value);
    return 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'habit_type_id': habitTypeId,
      'name': name,
    };
  }

  @override
  String toString() {
    return 'HabitType{habitTypeId: $habitTypeId, name: $name}';
  }

  // Métodos de conveniencia
  bool get isBuildHabit => name.toLowerCase() == 'build';
  bool get isQuitHabit => name.toLowerCase() == 'quit';
}
