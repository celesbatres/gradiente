import 'package:flutter/material.dart';
import 'package:gradiente/services/auth/auth_service2.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  String _nombre = "";
  String _email = "";
  String _password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registro")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Nombre completo",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                value!.isEmpty ? "Ingresa tu nombre" : null,
                onSaved: (value) => _nombre = value!,
              ),
              const SizedBox(height: 15),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Correo electrónico",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                value!.isEmpty ? "Ingresa tu correo" : null,
                onSaved: (value) => _email = value!,
              ),
              const SizedBox(height: 15),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Contraseña",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                value!.length < 6 ? "Mínimo 6 caracteres" : null,
                onSaved: (value) => _password = value!,
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _authService.signUp(email: _email, password: _password);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Registro exitoso para $_nombre")),
                    );
                  }
                },
                child: const Text("Registrarse"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
