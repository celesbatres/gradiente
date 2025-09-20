// new_login_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Para FirebaseAuthException
import 'package:gradiente/services/api/uid_api_service.dart';
import 'package:gradiente/services/models/user.dart' as UserModel;
import '../services/auth/auth_service.dart'; // Ajusta la ruta si es necesario
import 'navigation_example.dart';
import 'widgets/habit_quiz_app.dart';

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
  final _nameController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final AuthService _authService = AuthService(); // Instancia de tu servicio

  bool _isLoading = false;
  bool _isSignUpMode = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _confirmPasswordController.dispose();
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
          print("userCredential: ${userCredential?.user}");

          
          UserModel.User user = await UidApiService.getUserByFirebaseUid(userCredential?.user?.uid ?? "");
          if (user.existsUser()) {
            print("user: $user");
          } else {
            print("user no existe, crear uno nuevo");
          }
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

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        UserCredential? userCredential = await _authService.signUp(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        if (userCredential?.user != null) {
          print("userCredential: ${userCredential?.user}");
          
          // Aquí podrías crear el usuario en tu API con el nombre
          // UserModel.User newUser = UserModel.User(
          //   name: _nameController.text.trim(),
          //   email: _emailController.text.trim(),
          //   firebaseUid: userCredential?.user?.uid ?? "",
          // );
          // await UidApiService.createUser(newUser);
          
          // Navegación exitosa al Dashboard
          if (mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HabitQuizApp()),
            );
          }
        } else {
          setState(() {
            _errorMessage = 'Registro fallido. Por favor intenta de nuevo.';
          });
        }
      } on FirebaseAuthException catch (e) {
        String message;
        switch (e.code) {
          case 'email-already-in-use':
            message = 'Ya existe una cuenta con este correo electrónico.';
            break;
          case 'invalid-email':
            message = 'La dirección de correo electrónico no es válida.';
            break;
          case 'weak-password':
            message = 'La contraseña es muy débil.';
            break;
          default:
            message = 'Ocurrió un error: ${e.message}';
        }
        setState(() {
          _errorMessage = message;
        });
        debugPrint('FirebaseAuthException: ${e.code} - ${e.message}');
      } catch (e) {
        setState(() {
          _errorMessage = 'Ocurrió un error inesperado. Por favor intenta de nuevo.';
        });
        debugPrint('SignUp error: $e');
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  void _toggleMode() {
    setState(() {
      _isSignUpMode = !_isSignUpMode;
      _errorMessage = null;
      // Limpiar los campos al cambiar de modo
      _emailController.clear();
      _passwordController.clear();
      _nameController.clear();
      _confirmPasswordController.clear();
    });
  }

  void _showUserNotFoundDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Usuario no encontrado'),
          content: const Text(
            'No tienes una cuenta registrada con este correo de Google. '
            '¿Te gustaría registrarte?'
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar diálogo
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar diálogo
                _toggleMode(); // Cambiar a modo registro
              },
              child: const Text('Registrarme'),
            ),
          ],
        );
      },
    );
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
                Text(
                  _isSignUpMode ? '¡Regístrate en Gradiente!' : '¡Bienvenido a Gradiente!',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),

                // Campo de nombre (solo en modo registro)
                if (_isSignUpMode) ...[
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre',
                      hintText: 'Ingrese su nombre completo',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingrese su nombre por favor';
                      }
                      if (value.length < 2) {
                        return 'El nombre debe tener al menos 2 caracteres';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                ],

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

                // Campo de confirmación de contraseña (solo en modo registro)
                if (_isSignUpMode) ...[
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration: const InputDecoration(
                      labelText: 'Confirmar Contraseña',
                      hintText: 'Confirme su contraseña',
                      prefixIcon: Icon(Icons.lock_outline),
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Confirme su contraseña por favor';
                      }
                      if (value != _passwordController.text) {
                        return 'Las contraseñas no coinciden';
                      }
                      return null;
                    },
                  ),
                ],
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
                  onPressed: _isSignUpMode ? _signUp : _login,
                  child: Text(_isSignUpMode ? 'Registrarse' : 'Iniciar sesión'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  onPressed: () async {
                    final userCredential = await _authService.signInWithGoogle();
                    if (userCredential != null) {
                      print("userCredential: $userCredential");
                      
                      // Detectar si es un nuevo usuario
                      bool isNewUser = userCredential.additionalUserInfo?.isNewUser == true;
                      print("Es nuevo usuario: $isNewUser");
                      
                      if (isNewUser) {
                        // Nuevo usuario - redirigir directamente a HabitQuizApp
                        print("Nuevo usuario, redirigiendo a HabitQuizApp");
                        if (mounted) {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => const HabitQuizApp()),
                          );
                        }
                      } else {
                        // Usuario existente - verificar en la API
                        UserModel.User user = await UidApiService.getUserByFirebaseUid(userCredential.user?.uid ?? "");
                        if (user.existsUser()) {
                          print("user: $user");
                          if (mounted) {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) => const HabitQuizApp()),
                            );
                          }
                        } else {
                          // Usuario no existe en la API, mostrar diálogo
                          if (mounted) {
                            _showUserNotFoundDialog();
                          }
                        }
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Inicio de sesión cancelado')),
                      );
                    }
                  },
                  child: Text(_isSignUpMode ? 'Registrarse con Google' : 'Iniciar sesión con Google'),
                ),

                // Botón para cambiar entre login y registro
                TextButton(
                  onPressed: _toggleMode,
                  child: Text(_isSignUpMode ? '¿Ya tienes una cuenta? Inicia sesión' : '¿No tienes una cuenta? Regístrate'),
                ),

                // Opcional: Añadir un botón para "Olvidé mi contraseña" (solo en modo login)
                if (!_isSignUpMode)
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
