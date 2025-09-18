import 'package:flutter/material.dart';
import 'package:gradiente/services/models/habit_user.dart';
import '../services/api/habit_api_service.dart';
import 'add_habito.dart';

class HabitosPage extends StatefulWidget {
  const HabitosPage({super.key});

  @override
  State<HabitosPage> createState() => _HabitosPageState();
}

class _HabitosPageState extends State<HabitosPage> {
  List<HabitUser> _habitos = [];
  List<bool> _habitosCheckboxStates = [];
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
      final habits = await HabitApiService.getUserHabits();
      setState(() {
        _habitos = habits;
        _habitosCheckboxStates = List.filled(habits.length, false);
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
    
    if (habitUser.tipoHabitoId == 1) {
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
          color: habitUser.tipoHabitoId == 1 
              ? Colors.green.shade700 
              : Colors.red.shade700,
        ),
        title: Text(
          habitUser.name,
          style: TextStyle(
            color: habitUser.tipoHabitoId == 1 
                ? Colors.green.shade800 
                : Colors.red.shade800,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          habitUser.tipoHabitoId == 1 ? 'Hábito positivo' : 'Hábito a evitar',
          style: TextStyle(
            color: habitUser.tipoHabitoId == 1 
                ? Colors.green.shade600 
                : Colors.red.shade600,
            fontSize: 12,
          ),
        ),
        trailing: Checkbox(
          value: _habitosCheckboxStates[index],
          onChanged: (bool? value) {
            setState(() {
              _habitosCheckboxStates[index] = value!;
            });
          },
          activeColor: habitUser.tipoHabitoId == 1 
              ? Colors.green 
              : Colors.red,
        ),
      ),
    );
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