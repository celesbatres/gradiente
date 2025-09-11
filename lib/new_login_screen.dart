// new_login_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Para FirebaseAuthException
import '../services/auth/auth_service.dart'; // Ajusta la ruta si es necesario
import 'dashboard_screen.dart'; // Asegúrate que esta ruta es correcta
import '../services/auth/auth_service2.dart';
import 'navigation_example.dart';

class NewLoginScreen extends StatefulWidget {
  const NewLoginScreen({super.key});

  static const routeName = '/new_login'; // Opcional: para rutas nombradas

  @override
  State<NewLoginScreen> createState() => _NewLoginScreenState();
}

class _NewLoginScreenState extends State<NewLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService(); // Instancia de tu servicio
  final GoogleSignInService _googleAuthService = GoogleSignInService();

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        UserCredential? userCredential = await _authService.signIn(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        if (userCredential?.user != null) {
          // Navegación exitosa al Dashboard
          if (mounted) { // Verifica si el widget sigue montado
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const NavigationExample()),
            );
          }
        } else {
          // Esto no debería ocurrir si signIn no lanza excepción y devuelve null UserCredential
          // pero es bueno tener un fallback.
          setState(() {
            _errorMessage = 'Login failed. Please try again.';
          });
        }
      } on FirebaseAuthException catch (e) {
        String message;
        switch (e.code) {
          case 'user-not-found':
            message = 'No user found for that email.';
            break;
          case 'wrong-password':
            message = 'Wrong password provided for that user.';
            break;
          case 'invalid-email':
            message = 'The email address is not valid.';
            break;
          case 'user-disabled':
            message = 'This user account has been disabled.';
            break;
        // Agrega más casos según necesites
          default:
            message = 'An error occurred: ${e.message}';
        }
        setState(() {
          _errorMessage = message;
        });
        debugPrint('FirebaseAuthException: ${e.code} - ${e.message}');
      } catch (e) {
        setState(() {
          _errorMessage = 'An unexpected error occurred. Please try again.';
        });
        debugPrint('Login error: $e');
      } finally {
        if (mounted) { // Verifica si el widget sigue montado
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Login'),
      // ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // Aquí podrías añadir un logo o título
                const Text(
                  '¡Bienvenido a Gradiente!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),

                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Correo',
                    hintText: 'Ingrese su correo',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingrese su correo por favor';
                    }
                    if (!value.contains('@') || !value.contains('.')) {
                      return 'Ingrese un correo electrónico válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Contraseña',
                    hintText: 'Ingrese su contraseña',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingrese su contraseña por favor';
                    }
                    if (value.length < 6) {
                      // Ajusta según los requerimientos de Firebase/AuthService
                      return 'La contraseña debe tener al menos 6 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),

                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),

                const SizedBox(height: 15),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  onPressed: _login,
                  child: const Text('Iniciar sesión'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  onPressed: () async {
                    // Navegar a la pantalla de registro
                    final userCredential = await _authService.signInWithGoogle();
                    if (userCredential != null) {
                      if (mounted) { // Verifica si el widget sigue montado
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => const NavigationExample()),
                        );
                      }
                    } else {
                      // ❌ El usuario canceló o algo falló
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Inicio de sesión cancelado')),
                      );
                    }
                  },
                  child: const Text('Iniciar sesión con Google'),
                ),

                // Opcional: Añadir un botón para ir a la pantalla de registro
                TextButton(
                  onPressed: () {
                    // Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignUpScreen()));
                  },
                  child: const Text('¿No tienes una cuenta? Registrate'),
                ),

                // Opcional: Añadir un botón para "Olvidé mi contraseña"
                TextButton(
                  onPressed: () {
                    // Implementar recuperación de contraseña
                  },
                  child: const Text('¿Olvidaste tu contraseña?'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
