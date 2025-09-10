import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddHabitScreen extends StatefulWidget {
  static const String routeName = '/add_habit';
  @override
  _AddHabitScreenState createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  final _formKey = GlobalKey<FormState>();
  String _nombre = "";
  String _descripcion = "";
  String _categoria = "Salud";
  String _meta = "";

  final List<String> categorias = [
    "Salud",
    "Estudio",
    "Trabajo",
    "Finanzas",
    "Bienestar",
    "Otro"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Nuevo Hábito")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Nombre del hábito
              TextFormField(
                decoration: InputDecoration(labelText: "Nombre del hábito"),
                validator: (value) =>
                value!.isEmpty ? "Ingresa un nombre" : null,
                onSaved: (value) => _nombre = value!,
              ),
              SizedBox(height: 10),
              // Descripción
              TextFormField(
                decoration: InputDecoration(labelText: "Descripción (opcional)"),
                onSaved: (value) => _descripcion = value ?? "",
              ),
              SizedBox(height: 10),
              // Meta
              TextFormField(
                decoration: InputDecoration(labelText: "Meta diaria (ej: 30 min, 5 km)"),
                onSaved: (value) => _meta = value ?? "",
              ),
              SizedBox(height: 10),
              // Categoría
              DropdownButtonFormField<String>(
                value: _categoria,
                items: categorias
                    .map((cat) =>
                    DropdownMenuItem(value: cat, child: Text(cat)))
                    .toList(),
                onChanged: (value) => setState(() => _categoria = value!),
                decoration: InputDecoration(labelText: "Categoría"),
              ),
              SizedBox(height: 20),
              // Botón guardar
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    Navigator.pop(context, _nombre);
                  }
                },
                child: Text("Guardar hábito"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}