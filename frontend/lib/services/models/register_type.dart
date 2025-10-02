class RegisterType {
  final int register_type;
  final String name;

  RegisterType({
    required this.register_type,
    required this.name,
  });

  factory RegisterType.fromJson(Map<String, dynamic> json) {
    return RegisterType(
      register_type: _parseId(json['register_type']),
      name: json['name'],
    );
  }

  static int _parseId(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.parse(value);
    return 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'register_type': register_type,
      'name': name,
    };
  }

  @override
  String toString() {
    return 'RegisterType{register_tipe: $register_type, name: $name}';
  }

  // Métodos de conveniencia
  bool get isSumAmount => name.toLowerCase() == 'sum_amount';
  bool get isPutAmount => name.toLowerCase() == 'put_amount';
}
