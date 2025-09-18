class Habit {
  final int id;
  final String name;
  final int tipoHabitoId;
  final String? descripcion;
  final String? goal;

  Habit({
    required this.id,
    required this.name,
    required this.tipoHabitoId,
    this.descripcion,
    this.goal,
  });

  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      id: _parseId(json['id_habito'] ?? json['id']),
      name: json['nombre'] as String,
      tipoHabitoId: _parseTipoHabitoId(json['tipo_habito_id']),
      descripcion: json['descripcion'] as String?,
      goal: json['goal'] as String?,
    );
  }

  static int _parseId(dynamic value) {
    if (value is int) {
      return value;
    } else if (value is String) {
      return int.parse(value);
    } else {
      return 0;
    }
  }

  static int _parseTipoHabitoId(dynamic value) {
    if (value is int) {
      return value;
    } else if (value is String) {
      return int.parse(value);
    } else {
      return 0;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id_habito': id,
      'nombre': name,
      'tipo_habito_id': tipoHabitoId,
      'descripcion': descripcion,
      'goal': goal,
    };
  }

  @override
  String toString() {
    return 'Habit{id: $id, name: $name, tipoHabitoId: $tipoHabitoId, descripcion: $descripcion, goal: $goal}';
  }
}