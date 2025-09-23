import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gradiente/services/api/habit_api_service.dart';
import 'package:gradiente/services/api/register_type_api_service.dart';
import 'package:gradiente/services/api/user_habit_api_service.dart';
import 'package:gradiente/services/api/goal_api_service.dart';
import 'package:gradiente/services/api/user.dart';
import 'package:gradiente/services/models/habit.dart';
import 'package:gradiente/services/models/register_type.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddHabitScreen extends StatefulWidget {
  static const String routeName = '/add_habit';
  @override
  _AddHabitScreenState createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Variables para el formulario
  Habit? _selectedHabit;
  RegisterType? _selectedRegisterType;
  int? _quantityRegister;
  
  // Variables para el objetivo inicial
  int? _goalQuantity;
  int? _goalDays;
  
  // Listas de datos
  List<Habit> _habits = [];
  List<RegisterType> _registerTypes = [];
  
  // Estado de carga
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final habits = await HabitApiService.getHabits();
      final registerTypes = await RegisterTypeApiService.getRegisterTypes();
      
      setState(() {
        _habits = habits;
        _registerTypes = registerTypes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text("Nuevo Hábito")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: Text("Nuevo Hábito")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Error: $_errorMessage"),
              ElevatedButton(
                onPressed: _loadData,
                child: Text("Reintentar"),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text("Nuevo Hábito")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Selector de hábito existente
              DropdownButtonFormField<Habit>(
                value: _selectedHabit,
                items: _habits
                    .map((habit) => DropdownMenuItem(
                          value: habit,
                          child: Row(
                            children: [
                              if (habit.icon != null) Text(habit.icon!),
                              SizedBox(width: 8),
                              Expanded(child: Text(habit.name)),
                            ],
                          ),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _selectedHabit = value),
                decoration: InputDecoration(labelText: "Seleccionar Hábito"),
                validator: (value) => value == null ? "Selecciona un hábito" : null,
              ),
              SizedBox(height: 16),

              // Selector de tipo de registro
              DropdownButtonFormField<RegisterType>(
                value: _selectedRegisterType,
                items: _registerTypes
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(_getRegisterTypeDisplayName(type.name)),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _selectedRegisterType = value),
                decoration: InputDecoration(labelText: "Tipo de Registro"),
                validator: (value) => value == null ? "Selecciona un tipo de registro" : null,
              ),
              SizedBox(height: 16),

              // Input condicional para cantidad cuando es suma
              if (_selectedRegisterType?.isSumAmount == true) ...[
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Cantidad a sumar",
                    hintText: "Ej: 1, 5, 10",
                  ),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => _quantityRegister = int.tryParse(value ?? ''),
                  validator: (value) {
                    if (_selectedRegisterType?.isSumAmount == true) {
                      if (value == null || value.isEmpty) {
                        return "Ingresa la cantidad a sumar";
                      }
                      if (int.tryParse(value) == null) {
                        return "Ingresa un número válido";
                      }
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
              ],

              // Sección de Objetivo Inicial
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Objetivo Inicial",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      SizedBox(height: 16),
                      
                      // Cantidad objetivo
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Cantidad Objetivo",
                          hintText: "Ej: 30, 5, 100",
                        ),
                        keyboardType: TextInputType.number,
                        onSaved: (value) => _goalQuantity = int.tryParse(value ?? ''),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Ingresa la cantidad objetivo";
                          }
                          if (int.tryParse(value) == null) {
                            return "Ingresa un número válido";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      
                      // Días objetivo
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Días para alcanzar el objetivo",
                          hintText: "Ej: 30, 60, 90",
                        ),
                        keyboardType: TextInputType.number,
                        onSaved: (value) => _goalDays = int.tryParse(value ?? ''),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Ingresa los días objetivo";
                          }
                          if (int.tryParse(value) == null) {
                            return "Ingresa un número válido";
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Botón guardar
              ElevatedButton(
                onPressed: _saveHabit,
                child: Text("Guardar Hábito"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getRegisterTypeDisplayName(String typeName) {
    switch (typeName.toLowerCase()) {
      case 'sum_amount':
        return 'Botón de suma de cantidades';
      case 'put_amount':
        return 'Botón de colocar cantidad';
      default:
        return typeName;
    }
  }

  Future<void> _saveHabit() async {
    if (!_formKey.currentState!.validate()) return;
    
    _formKey.currentState!.save();

    try {
      // Obtener el usuario actual
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        _showError("No hay usuario autenticado");
        return;
      }

      // Obtener el ID del usuario desde la base de datos
      final users = await UserApiService.getUser(user.uid);
      if (users.isEmpty) {
        _showError("Usuario no encontrado en la base de datos");
        return;
      }

      final userId = users.first.user;

      // Crear el user_habit
      final userHabitId = await UserHabitApiService.createUserHabit(
        userId: userId,
        habitId: _selectedHabit!.habit,
        registerTypeId: _selectedRegisterType!.registerTypeId,
        quantityRegister: _quantityRegister,
      );

      if (userHabitId == null) {
        _showError("Error al crear el hábito del usuario");
        return;
      }
      
      // Crear el objetivo inicial
      final goalSuccess = await GoalApiService.createGoal(
        userHabitId: userHabitId,
        quantity: _goalQuantity,
        days: _goalDays,
      );

      if (goalSuccess) {
        _showSuccess("Hábito creado exitosamente");
        Navigator.pop(context);
      } else {
        _showError("Error al crear el objetivo inicial");
      }
    } catch (e) {
      _showError("Error: ${e.toString()}");
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }
}