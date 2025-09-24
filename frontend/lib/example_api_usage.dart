import 'package:flutter/material.dart';
import 'package:gradiente/services/models/habit_user.dart';
import 'services/api/habit_api_service.dart';

/// Example demonstrating how to use the HabitApiService
/// to get user habits from the API endpoint
class ExampleApiUsage {
  
  /// Example function showing how to fetch user habits
  static Future<void> fetchUserHabitsExample() async {
    try {
      print('Fetching habits (no parameters)');
      
      // Call the API service to get user habits
      List<HabitUser> habits = await HabitApiService.getUserHabits(1.toString());
      
      print('Successfully fetched ${habits.length} habits:');
      
      // Print each habit
      for (int i = 0; i < habits.length; i++) {
        HabitUser habit = habits[i];
        print('Habit ${i + 1}:');
        print('  Name: ${habit.name}');
        print('  Type: ${habit.habitType} (${habit.habitType == 1 ? 'Verde' : 'Rojo'})');
        print('---');
      }
      
    } catch (e) {
      print('Error fetching habits: $e');
    }
  }
  
  /// Example function showing how to use the API in a Flutter widget
  static Widget buildHabitsList() {
    return FutureBuilder<List<HabitUser>>(
      future: HabitApiService.getUserHabits(1.toString()),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text('Error: ${snapshot.error}'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Trigger rebuild to retry
                    (context as Element).markNeedsBuild();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }
        
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('No habits found for this user.'),
          );
        }
        
        return ListView.builder(
          itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
            HabitUser habit = snapshot.data![index];
            
            // Determinar el color según el tipo de hábito
            Color backgroundColor = habit.habitType == 1 
                ? Colors.green.shade50 
                : Colors.red.shade50;
            Color textColor = habit.habitType == 1 
                ? Colors.green.shade800 
                : Colors.red.shade800;
            
            return Container(
              margin: const EdgeInsets.only(bottom: 4),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: habit.habitType == 1 
                      ? Colors.green.shade200 
                      : Colors.red.shade200,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    habit.habitType == 1 
                        ? Icons.check_circle_outline 
                        : Icons.cancel_outlined,
                    color: textColor,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      habit.name ?? '',
                      style: TextStyle(
                        fontSize: 14,
                        color: textColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

/// Example screen widget demonstrating API usage
class ExampleApiUsageScreen extends StatelessWidget {
  static const String routeName = '/example-api-usage';
  
  const ExampleApiUsageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Example API Usage'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'API Usage Examples',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'This screen demonstrates different ways to use the HabitApiService:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () async {
                await ExampleApiUsage.fetchUserHabitsExample();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Check console for API call results'),
                      duration: Duration(seconds: 3),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.code),
              label: const Text('Run Console Example'),
            ),
            const SizedBox(height: 16),
            const Text(
              'Widget Example (FutureBuilder):',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ExampleApiUsage.buildHabitsList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Example of how to use the API service in your app
void main() async {
  // Example 1: Simple function call
  await ExampleApiUsage.fetchUserHabitsExample();
  
  // Example 2: Using in a Flutter app
  // You can navigate to TestHabitsApiScreen to see the full implementation
  // Navigator.pushNamed(context, TestHabitsApiScreen.routeName);
}
