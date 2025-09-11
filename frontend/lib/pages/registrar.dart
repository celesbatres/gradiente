// lib/pages/registrar_page.dart
import 'package:flutter/material.dart';

class RegistrarPage extends StatefulWidget { // Changed to StatefulWidget for checkbox state
  const RegistrarPage({super.key});

  @override
  State<RegistrarPage> createState() => _RegistrarPageState();
}

class _RegistrarPageState extends State<RegistrarPage> {
  // Local state for checkboxes on this page
  final List<bool> _registrarCheckboxStates = [false, false];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Card(
            child: ListTile(
              leading: const Icon(Icons.edit_note),
              title: const Text('Registrar Actividad 1'),
              subtitle: const Text('Detalles de la actividad...'),
              trailing: Checkbox(
                value: _registrarCheckboxStates[0],
                onChanged: (bool? value) {
                  setState(() {
                    _registrarCheckboxStates[0] = value!;
                  });
                },
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.run_circle_outlined),
              title: const Text('Registrar Ejercicio'),
              subtitle: const Text('Tiempo, distancia...'),
              trailing: Checkbox(
                value: _registrarCheckboxStates[1],
                onChanged: (bool? value) {
                  setState(() {
                    _registrarCheckboxStates[1] = value!;
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
