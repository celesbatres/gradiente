import 'package:flutter/material.dart';
import 'package:gradiente/services/models/habit_user.dart';
import 'package:gradiente/services/providers/auth_provider.dart' as AuthProvider;
import 'package:provider/provider.dart';
import '../services/api/habit_api_service.dart';
import 'add_habito.dart';

class HabitosPage extends StatefulWidget {
  const HabitosPage({super.key});

  @override
  State<HabitosPage> createState() => _HabitosPageState();
}

class _HabitosPageState extends State<HabitosPage> {
  List<HabitUser> _habitos = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadHabits();
  }

  Future<void> _loadHabits() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authProvider = Provider.of<AuthProvider.AuthProvider>(context, listen: false);
      print('Current User: ${authProvider.userProvider.currentUser}');
      print('User object: ${authProvider.userProvider.currentUser?.user}');
      print('Firebase UID: ${authProvider.userProvider.currentUser?.firebaseUid}');
      final userId = authProvider.userProvider.currentUser?.user.toString() ?? '';
      print('User ID (BD): $userId');
      final habits = await HabitApiService.getUserHabits(userId);
      setState(() {
        _habitos = habits;
        print('habitos: '+_habitos.first.toString());
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Error: $_errorMessage',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadHabits,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (_habitos.isEmpty) {
      return const Center(
        child: Text(
          'No tienes hábitos registrados',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: _habitos.length,
      itemBuilder: (context, index) {
        final habitUser = _habitos[index];
        return _buildHabitCard(habitUser, index);
      },
    );
  }

  Widget _buildHabitCard(HabitUser habitUser, int index) {
    // Determinar el color según el tipo de hábito
    Color backgroundColor;
    Color borderColor;
    IconData iconData;
    
    if (habitUser.habitType == 1) {
      // Tipo 1: Verde
      backgroundColor = Colors.green.shade50;
      borderColor = Colors.green.shade200;
      iconData = Icons.check_circle_outline;
    } else {
      // Otros tipos: Rojo
      backgroundColor = Colors.red.shade50;
      borderColor = Colors.red.shade200;
      iconData = Icons.cancel_outlined;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: borderColor),
      ),
      child: ListTile(
        leading: Icon(
          iconData,
          color: habitUser.habitType == 1 
              ? Colors.green.shade700 
              : Colors.red.shade700,
        ),
        title: Text(
          habitUser.name ?? '',
          style: TextStyle(
            color: habitUser.habitType == 1 
                ? Colors.green.shade800 
                : Colors.red.shade800,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          habitUser.habitType == 1 ? 'Hábito positivo' : 'Hábito a evitar',
          style: TextStyle(
            color: habitUser.habitType == 1 
                ? Colors.green.shade600 
                : Colors.red.shade600,
            fontSize: 12,
          ),
        ),
        trailing: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: habitUser.habitType == 1 
                ? Colors.green.shade100 
                : Colors.red.shade100,
            border: Border.all(
              color: habitUser.habitType == 1 
                  ? Colors.green.shade300 
                  : Colors.red.shade300,
              width: 1,
            ),
          ),
          child: IconButton(
            onPressed: () {
              // Aquí puedes agregar la lógica para incrementar el hábito
              _incrementHabit(habitUser, index);
            },
            icon: Icon(
              Icons.add,
              color: habitUser.habitType == 1 
                  ? Colors.green.shade700 
                  : Colors.red.shade700,
              size: 20,
            ),
            padding: EdgeInsets.all(8),
            constraints: BoxConstraints(
              minWidth: 32,
              minHeight: 32,
            ),
          ),
        ),
      ),
    );
  }

  void _incrementHabit(HabitUser habitUser, int index) {
    // Aquí puedes implementar la lógica para incrementar el hábito
    // Por ejemplo, mostrar un diálogo, hacer una llamada a la API, etc.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${habitUser.name} incrementado!'),
        backgroundColor: habitUser.habitType == 1 
            ? Colors.green 
            : Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
    
    // Aquí podrías agregar la lógica para actualizar el hábito en la base de datos
    // Por ejemplo: await HabitApiService.incrementHabit(habitUser.userHabitId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mis Hábitos"),
        actions: [
          IconButton(
            onPressed: _loadHabits,
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualizar hábitos',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _buildBody(),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            // Aquí lo que quieras que haga el botón
            Navigator.pushNamed(context, AddHabitScreen.routeName);
          },
          child: const Text("Agregar Hábito"),
        ),
      ),
    );
  }
}