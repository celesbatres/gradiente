class Habit {
  final int habit;
  final String? icon;
  final String name;
  final String? description;
  final int habitType;
  final String units;

  Habit({
    required this.habit,
    this.icon,
    required this.name,
    this.description,
    required this.habitType,
    required this.units,
  });

  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      habit: _parseId(json['habit'] ?? json['id']),
      icon: json['icon'] as String?,
      name: json['name'] as String,
      description: json['description'] as String?,
      habitType: _parseId(json['habit_type']),
      units: json['units'] as String,
    );
  }

  static int _parseId(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.parse(value);
    return 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'habit': habit,
      'icon': icon,
      'name': name,
      'description': description,
      'habit_type': habitType,
      'units': units,
    };
  }

  @override
  String toString() {
    return 'Habit{habit: $habit, icon: $icon, name: $name, description: $description, habitType: $habitType, units: $units}';
  }
}