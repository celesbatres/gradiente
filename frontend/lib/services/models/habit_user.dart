class HabitUser {
  final String name;
  final int tipoHabitoId;
  HabitUser({
    required this.name,
    required this.tipoHabitoId,
  });

  factory HabitUser.fromJson(Map<String, dynamic> json) {
    return HabitUser(
      name: json['nombre'] as String,
      tipoHabitoId: _parseTipoHabitoId(json['tipo_habito_id']),
    );
  }

  static int _parseTipoHabitoId(dynamic value) {
    if (value is int) {
      return value;
    } else if (value is String) {
      return int.parse(value);
    } else {
      // Si no se puede convertir, usar 0 como valor por defecto
      return 0;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': name,
      'tipo_habito_id': tipoHabitoId,
    };
  }

  @override
  String toString() {
    return 'HabitUser{name: $name, tipoHabitoId: $tipoHabitoId}';
  }
}
