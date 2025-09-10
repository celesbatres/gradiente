// lib/pages/home_page.dart
import 'package:flutter/material.dart';

class HomePage extends StatelssWidget {
  const HomePage({super.key});

  Future<void> _openNumberModal(int index) async {}
  void _changeDay(int delta) {
    // setState(() {
    //   selectedDate = selectedDate.add(Duration(days: delta));
    // });
  }
  static const List<Map<String, String>> habitos = [
    {
      'nombre': 'Leer',
      'objetivo': '10 minutos',
      'duracion': '1h',
      'genero': 'Acción'
    },
    {
      'nombre': 'Correr',
      'objetivo': '5 km',
      'duracion': '30 min',
      'genero': 'Cardio'
    },
    {
      'nombre': 'Meditación',
      'objetivo': '15 minutos',
      'duracion': '15 min',
      'genero': 'Mindfulness'
    },
    {
      'nombre': 'Escribir diario',
      'objetivo': '1 página',
      'duracion': '20 min',
      'genero': 'Reflexión'
    },
  ];

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text('Hábitos diarios')),
      body: Column(
        children: [
          // Sección de días
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => _changeDay(-1),
                ),
                Text(
                  'Hoy',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: () => _changeDay(1),
                ),
              ],
            ),
          ),
          // Lista de hábitos
          Expanded(
            child: ListView.builder(
              itemCount: habitos.length,
              itemBuilder: (context, index) {
                final habito = habitos[index];
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.book),
                    title: Text(habito['nombre']!),
                    subtitle: Text(
                        'Objetivo Diario: ${habito['objetivo']}\nDuración: ${habito['duracion']}\nGénero: ${habito['genero']}'),
                    trailing: GestureDetector(
                      onTap: () => _openNumberModal(index),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue,
                        ),
                        child: const Icon(Icons.add, color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}