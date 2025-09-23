class Goal {
  final int goalId;
  final int userHabitId;
  final int? quantity;
  final int? days;
  final bool actual;
  final String addDate;

  Goal({
    required this.goalId,
    required this.userHabitId,
    this.quantity,
    this.days,
    required this.actual,
    required this.addDate,
  });

  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      goalId: _parseId(json['goal_id'] ?? json['goalId'] ?? json['goal']),
      userHabitId: _parseId(json['user_habit_id'] ?? json['userHabitId'] ?? json['user_habit']),
      quantity: json['quantity'] != null 
          ? int.tryParse(json['quantity'].toString()) 
          : null,
      days: json['days'] != null 
          ? int.tryParse(json['days'].toString()) 
          : null,
      actual: _parseBool(json['actual']),
      addDate: json['add_date'] ?? json['addDate'] ?? '',
    );
  }

  static int _parseId(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.parse(value);
    return 0;
  }

  static bool _parseBool(dynamic value) {
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) return value.toLowerCase() == 'true' || value == '1';
    return false;
  }

  Map<String, dynamic> toJson() {
    return {
      'goal_id': goalId,
      'user_habit_id': userHabitId,
      'quantity': quantity,
      'days': days,
      'actual': actual,
      'add_date': addDate,
    };
  }

  @override
  String toString() {
    return 'Goal{goalId: $goalId, userHabitId: $userHabitId, quantity: $quantity, days: $days, actual: $actual, addDate: $addDate}';
  }
}
