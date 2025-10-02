import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gradiente/services/api/habit_api_service.dart';
import 'package:gradiente/services/api/register_type_api_service.dart';
import 'package:gradiente/services/api/user_habit_api_service.dart';
import 'package:gradiente/services/api/goal_api_service.dart';
import 'package:gradiente/services/models/habit.dart';
import 'package:gradiente/services/models/register_type.dart';
import 'package:gradiente/services/providers/user_provider.dart';

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
  final TextEditingController _quantityController = TextEditingController();

  // Variables para el objetivo inicial
  int? _goalQuantity;

  // Listas de datos
  List<Habit> _habits = [];

  List<RegisterType> _registerTypes = [];

  // Estado de carga
  bool _isLoading = false;
  bool _isSaving = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    // Evitar múltiples llamadas simultáneas
    if (_isLoading) return;
    
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final habits = await HabitApiService.getHabits();
      final registerTypes = await RegisterTypeApiService.getRegisterTypes();

      print('registerTypes: '+registerTypes.first.name);

      setState(() {
        _habits = habits;
        _registerTypes = registerTypes;
        _isLoading = false;
        _errorMessage = null;
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
    /* if (_isLoading) {
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
                initialValue: _selectedHabit,
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
              // DropdownButtonFormField<RegisterType>(
              //   initialValue: _selectedRegisterType,
              //   items: _registerTypes
              //       .map((type) => DropdownMenuItem(
              //             value: type,
              //             child: Text(_getRegisterTypeDisplayName(type.name)),
              //           ))
              //       .toList(),
              //   onChanged: (value) => setState(() => _selectedRegisterType = value),
              //   decoration: InputDecoration(labelText: "Tipo de Registro"),
              //   validator: (value) => value == null ? "Selecciona un tipo de registro" : null,
              // ),
              SizedBox(height: 16),

              // Input condicional para cantidad cuando es suma
              // if (_selectedRegisterType?.isSumAmount == true) ...[
              //   TextFormField(
              //     decoration: InputDecoration(
              //       labelText: "Cantidad a sumar",
              //       hintText: "Ej: 1, 5, 10",
              //     ),
              //     keyboardType: TextInputType.number,
              //     onSaved: (value) => _quantityRegister = int.tryParse(value ?? ''),
              //     validator: (value) {
              //       if (_selectedRegisterType?.isSumAmount == true) {
              //         if (value == null || value.isEmpty) {
              //           return "Ingresa la cantidad a sumar";
              //         }
              //         if (int.tryParse(value) == null) {
              //           return "Ingresa un número válido";
              //         }
              //       }
              //       return null;
              //     },
              //   ),
              //   SizedBox(height: 16),
              // ],

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
                      
                      // Mostrar unidades del hábito seleccionado
                      if (_selectedHabit != null) ...[
                        SizedBox(height: 8),
                        Text(
                          "Unidades: ${_selectedHabit!.units}",
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                      
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
                      
                      // Mostrar unidades del hábito seleccionado
                      if (_selectedHabit != null) ...[
                        SizedBox(height: 8),
                        Text(
                          "Unidades: ${_selectedHabit!.units}",
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                      
                      SizedBox(height: 16),
                      
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
    );*/
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 16.0), // Ajusta la altura para el padding
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0), // Margen deseado
          child: AppBar(title: Text("Nuevo Hábito")),
        ),
      ),
      // appBar: AppBar(title: Text("Nuevo Hábito")),
      
      body: _isLoading 
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Cargando datos...'),
              ],
            ),
          )
        : _errorMessage != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, size: 64, color: Colors.red),
                  SizedBox(height: 16),
                  Text('Error: $_errorMessage'),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadData,
                    child: Text('Reintentar'),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey, // Assign the GlobalKey to the Form
                child: Column(
                  children: <Widget>[
              // Selector de hábito
              DropdownButtonFormField<Habit>(
                initialValue: _selectedHabit,
                items: _habits.map<DropdownMenuItem<Habit>>((Habit value) {
                      return DropdownMenuItem<Habit>(
                        value: value,
                        child: Text(value.name),
                      );
                    }).toList(),
                onChanged: (Habit? newValue) {
                  setState(() {
                    _selectedHabit = newValue;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Seleccionar Hábito',
                  border: OutlineInputBorder(),
                ),
              ),
              
              SizedBox(height: 20), // Separación entre campos
              
              // Selector de tipo de registro
              DropdownButtonFormField<RegisterType>(
                initialValue: _selectedRegisterType,
                items: _registerTypes.map<DropdownMenuItem<RegisterType>>((RegisterType value) {
                      return DropdownMenuItem<RegisterType>(
                        value: value,
                        child: Text(value.name),
                      );
                    }).toList(),
                onChanged: (RegisterType? newValue) {
                  setState(() {
                    _selectedRegisterType = newValue;
                    // Limpiar el campo de cantidad cuando cambie el tipo de registro
                    if (newValue?.register_type != 1) {
                      _quantityController.clear();
                    }
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Tipo de Registro',
                  border: OutlineInputBorder(),
                ),
              ),

              // Campo de entrada para cantidad cuando se selecciona sum_amount
              if (_selectedRegisterType?.register_type == 1) ...[
                SizedBox(height: 20), // Separación antes del campo condicional
                TextFormField(
                  controller: _quantityController,
                  decoration: InputDecoration(
                    labelText: 'Cantidad a agregar',
                    hintText: 'Ej: 1, 5, 10',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (_selectedRegisterType?.register_type == 1) {
                      if (value == null || value.isEmpty) {
                        return "Ingresa la cantidad a agregar";
                      }
                      if (int.tryParse(value) == null) {
                        return "Ingresa un número válido";
                      }
                    }
                    return null;
                  },
                  onSaved: (value) {
                    if (_selectedRegisterType?.register_type == 1) {
                      _quantityRegister = int.tryParse(value ?? '');
                    }
                  },
                ),
              ],
              
              SizedBox(height: 30), // Separación más grande antes del botón
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
                      
                      // Mostrar unidades del hábito seleccionado
                      
                      
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
                      
                      // Mostrar unidades del hábito seleccionado
                      if (_selectedHabit != null) ...[
                        SizedBox(height: 8),
                        Text(
                          "Unidades: ${_selectedHabit!.units}",
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                      
                      SizedBox(height: 16),
                      
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              
              // Botón de envío
              SizedBox(
                width: double.infinity, // Botón de ancho completo
                child: ElevatedButton(
                  onPressed: _isSaving ? null : () {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      _saveHabit();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: _isSaving 
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                          SizedBox(width: 12),
                          Text('Guardando...'),
                        ],
                      )
                    : Text('Guardar Hábito'),
                ),
              ),
                  ],
                ),
              ),
            ),
    );
  }


  Future<void> _saveHabit() async {
    // Evitar múltiples envíos simultáneos
    if (_isSaving) return;
    
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    setState(() {
      _isSaving = true;
    });

    try {
      // Obtener el usuario actual desde el provider
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final currentUser = userProvider.currentUser;
      
      if (currentUser == null) {
        _showError("No hay usuario autenticado");
        return;
      }

      final userId = currentUser.user;

      // Validar que se haya seleccionado un tipo de registro
      if (_selectedRegisterType == null) {
        _showError("Debes seleccionar un tipo de registro");
        return;
      }

      // Validar que se haya ingresado una cantidad objetivo
      if (_goalQuantity == null) {
        _showError("Debes ingresar una cantidad objetivo");
        return;
      }
      
      // Crear el user_habit
      final userHabitId = await UserHabitApiService.createUserHabit(
        userId: userId,
        habitId: _selectedHabit!.habit,
        registerTypeId: _selectedRegisterType!.register_type,
        quantityRegister: _quantityRegister,
      );
      print('userHabitId: '+userHabitId.toString());
      if (userHabitId == null) {
        _showError("Error al crear el hábito del usuario");
        return;
      }

      // Crear el objetivo inicial (siempre de 1 día como se especifica)
      final goalSuccess = await GoalApiService.createGoal(
        userHabitId: userHabitId,
        quantity: _goalQuantity,
        days: 1, // Siempre 1 día como se especifica
      );

      if (goalSuccess) {
        _showSuccess("Hábito creado exitosamente");
        Navigator.pop(context);
      } else {
        _showError("Error al crear el objetivo inicial");
      }
    } catch (e) {
      _showError("Error: ${e.toString()}");
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }
}
