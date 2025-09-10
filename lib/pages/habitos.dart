import 'package:flutter/material.dart';

import 'add_habito.dart';

class HabitosPage extends StatefulWidget {
  const HabitosPage({super.key});

  @override
  State<HabitosPage> createState() => _HabitosPageState();
}

class _HabitosPageState extends State<HabitosPage> {
  final List<bool> _habitosCheckboxStates = [false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mis Hábitos")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Card(
              child: ListTile(
                leading: const Icon(Icons.book),
                title: const Text('Leer'),
                subtitle: const Text(
                    'Objetivo Diario: 10 minutos\nDuración: 1h\nGénero: Acción'),
                trailing: Checkbox(
                  value: _habitosCheckboxStates[0],
                  onChanged: (bool? value) {
                    setState(() {
                      _habitosCheckboxStates[0] = value!;
                    });
                  },
                ),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.water_drop),
                title: const Text('Hidratarme'),
                subtitle: const Text(
                    'Objetivo Diario: 2 lts\nCantidad: 2 vasos'),
                trailing: Checkbox(
                  value: _habitosCheckboxStates[1],
                  onChanged: (bool? value) {
                    setState(() {
                      _habitosCheckboxStates[1] = value!;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
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