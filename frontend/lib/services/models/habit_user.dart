class HabitUser {
  final int userHabitId;
  final int userId;
  final int habitId;
  final int registerTypeId;
  final int? quantityRegister;
  final String addDate;
  final String name;
  final int tipoHabitoId;
  final String? icon;
  final String? description;
  final String units;

  HabitUser({
    required this.userHabitId,
    required this.userId,
    required this.habitId,
    required this.registerTypeId,
    this.quantityRegister,
    required this.addDate,
    required this.name,
    required this.tipoHabitoId,
    this.icon,
    this.description,
    required this.units,
  });

  factory HabitUser.fromJson(Map<String, dynamic> json) {
    return HabitUser(
      userHabitId: _parseId(json['user_habit_id'] ?? json['userHabitId']),
      userId: _parseId(json['user_id'] ?? json['userId']),
      habitId: _parseId(json['habit_id'] ?? json['habitId']),
      registerTypeId: _parseId(json['register_type_id'] ?? json['registerTypeId']),
      quantityRegister: json['quantity_register'] != null 
          ? int.tryParse(json['quantity_register'].toString()) 
          : null,
      addDate: json['add_date'] ?? json['addDate'] ?? '',
      name: json['name'] ?? json['nombre'] ?? '',
      tipoHabitoId: _parseId(json['tipo_habito_id'] ?? json['tipoHabitoId']),
      icon: json['icon'] as String?,
      description: json['description'] as String?,
      units: json['units'] ?? '',
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
      'user_id': userId,
      'habit_id': habitId,
      'register_type_id': registerTypeId,
      'quantity_register': quantityRegister,
      'add_date': addDate,
      'name': name,
      'tipo_habito_id': tipoHabitoId,
      'icon': icon,
      'description': description,
      'units': units,
    };
  }

  @override
  String toString() {
    return 'HabitUser{userHabitId: $userHabitId, userId: $userId, habitId: $habitId, registerTypeId: $registerTypeId, quantityRegister: $quantityRegister, addDate: $addDate, name: $name, tipoHabitoId: $tipoHabitoId, icon: $icon, description: $description, units: $units}';
  }
}
