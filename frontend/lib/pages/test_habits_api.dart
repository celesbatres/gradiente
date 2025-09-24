import 'package:flutter/material.dart';
import 'package:gradiente/services/models/habit.dart';
import 'package:gradiente/services/providers/user_provider.dart';
import 'package:provider/provider.dart';
import '../services/api/habit_api_service.dart';
import '../services/models/habit_user.dart';

class TestHabitsApiScreen extends StatefulWidget {
  static const String routeName = '/test-habits-api';
  
  const TestHabitsApiScreen({super.key});

  @override
  State<TestHabitsApiScreen> createState() => _TestHabitsApiScreenState();
}

class _TestHabitsApiScreenState extends State<TestHabitsApiScreen> {
  List<HabitUser> habits = [];
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadHabits();
  }

  Future<void> _loadHabits() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final userId = userProvider.currentUser?.user.toString() ?? '';
      final userHabits = await HabitApiService.getUserHabits(userId);
      setState(() {
        habits = userHabits;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Habits API'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hábitos',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            if (isLoading)
              const Center(
                child: CircularProgressIndicator(),
              )
            else if (errorMessage != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Error:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(errorMessage!),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadHabits,
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              )
            else if (habits.isEmpty)
              const Center(
                child: Text(
                  'No hay hábitos',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: habits.length,
                  itemBuilder: (context, index) {
                    final habit = habits[index];
                    // Determinar el color según el tipo de hábito
                    Color backgroundColor;
                    Color borderColor;
                    
                    if (habit.habitType == 1) {
                      // Tipo 1: Verde claro
                      backgroundColor = Colors.green.shade50;
                      borderColor = Colors.green.shade200;
                    } else {
                      // Otros tipos: Rojo claro
                      backgroundColor = Colors.red.shade50;
                      borderColor = Colors.red.shade200;
                    }
                    
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: borderColor),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            habit.habitType == 1 
                                ? Icons.check_circle_outline 
                                : Icons.cancel_outlined,
                            color: habit.habitType == 1 
                                ? Colors.green.shade700 
                                : Colors.red.shade700,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              habit.name ?? '',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: habit.habitType == 1 
                                    ? Colors.green.shade800 
                                    : Colors.red.shade800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 12),
            Center(
              child: TextButton.icon(
                onPressed: _loadHabits,
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text('Actualizar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
