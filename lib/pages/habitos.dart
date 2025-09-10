// lib/pages/habitos_page.dart
import 'package:flutter/material.dart';

class HabitosPage extends StatefulWidget { // Changed to StatefulWidget for checkbox state
  const HabitosPage({super.key});

  @override
  State<HabitosPage> createState() => _HabitosPageState();
}

class _HabitosPageState extends State<HabitosPage> {
  // Local state for checkboxes on this page
  final List<bool> _habitosCheckboxStates = [false, false];

  @override
  Widget build(BuildContext context) {
    // final ThemeData theme = Theme.of(context); // Not strictly needed if not using theme specific elements here
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Card(
            child: ListTile(
              leading: const Icon(Icons.book),
              title: const Text('Leer'),
              subtitle: const Text('Objetivo Diario: 10 minutos\nDuración: 1h\nGénero: Acción'),
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
              subtitle: const Text('Objetivo Diario: 2 lts\nCantidad: 2 vasos'),
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
    );
  }
}
