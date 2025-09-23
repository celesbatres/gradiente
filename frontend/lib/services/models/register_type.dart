class RegisterType {
  final int registerTypeId;
  final String name;

  RegisterType({
    required this.registerTypeId,
    required this.name,
  });

  factory RegisterType.fromJson(Map<String, dynamic> json) {
    return RegisterType(
      registerTypeId: _parseId(json['register_type_id'] ?? json['registerTypeId'] ?? json['register_type']),
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
      'register_type_id': registerTypeId,
      'name': name,
    };
  }

  @override
  String toString() {
    return 'RegisterType{registerTypeId: $registerTypeId, name: $name}';
  }

  // Métodos de conveniencia
  bool get isSumAmount => name.toLowerCase() == 'sum_amount';
  bool get isPutAmount => name.toLowerCase() == 'put_amount';
}
