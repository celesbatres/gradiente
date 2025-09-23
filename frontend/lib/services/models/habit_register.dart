class HabitRegister {
  final int habitRegisterId;
  final int userHabitId;
  final int? amount;
  final String addDate;

  HabitRegister({
    required this.habitRegisterId,
    required this.userHabitId,
    this.amount,
    required this.addDate,
  });

  factory HabitRegister.fromJson(Map<String, dynamic> json) {
    return HabitRegister(
      habitRegisterId: _parseId(json['habit_register_id'] ?? json['habitRegisterId'] ?? json['habit_register']),
      userHabitId: _parseId(json['user_habit_id'] ?? json['userHabitId'] ?? json['user_habit']),
      amount: json['amount'] != null 
          ? int.tryParse(json['amount'].toString()) 
          : null,
      addDate: json['add_date'] ?? json['addDate'] ?? '',
    );
  }

  static int _parseId(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.parse(value);
    return 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'habit_register_id': habitRegisterId,
      'user_habit_id': userHabitId,
      'amount': amount,
      'add_date': addDate,
    };
  }

  @override
  String toString() {
    return 'HabitRegister{habitRegisterId: $habitRegisterId, userHabitId: $userHabitId, amount: $amount, addDate: $addDate}';
  }
}
