import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter_login/flutter_login.dart';
import 'package:gradiente/constants.dart';
import 'package:gradiente/custom_route.dart';
// Asegúrate de que DashboardScreen sea la pantalla a la que quieres ir después del login.
import 'package:gradiente/dashboard_screen.dart';
import 'package:gradiente/widgets/habit_quiz_app.dart';
// Importa tu AuthService
import '../services/auth/auth_service.dart'; // Verifica que esta ruta sea correcta
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// Firebase Core es necesario si AuthService usa Firebase.
// Si ya lo inicializas en tu main.dart, puede que no sea necesario aquí.
// import 'package:firebase_core/firebase_core.dart'; // Descomenta si es necesario
import 'package:firebase_auth/firebase_auth.dart'; // Para FirebaseAuthException

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  static const routeName = '/auth';

  // Ya no necesitas mockUsers ni loginTime para el login con email/pass si usas AuthService
  // Duration get loginTime => Duration(milliseconds: timeDilation.ceil() * 2250);

  // Modifica _loginUser para usar AuthService
  Future<String?> _loginUserWithAuthService(LoginData data, BuildContext context) async {
    final authService = AuthService();
    try {
      // Intenta iniciar sesión con el email y contraseña proporcionados
      UserCredential? userCredential = await authService.signIn(
        email: data.name, // flutter_login usa 'name' para el campo de email/usuario
        password: data.password,
      );

      if (userCredential?.user != null) {
        // Inicio de sesión exitoso
        // Puedes navegar a la siguiente pantalla aquí si lo deseas,
        // o dejar que onSubmitAnimationCompleted lo maneje.
        // Por ejemplo:
        // Navigator.of(context).pushReplacement(
        //   MaterialPageRoute(builder: (context) => const DashboardScreen()),
        // );
        return null; // Retorna null para indicar éxito
      } else {
        // Esto no debería ocurrir si signIn no lanza una excepción y retorna null UserCredential
        return 'Login failed. Please try again.';
      }
    } on FirebaseAuthException catch (e) {
      // Maneja errores específicos de Firebase Auth
      debugPrint('FirebaseAuthException: ${e.code} - ${e.message}');
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      } else if (e.code == 'invalid-email') {
        return 'The email address is not valid.';
      }
      return 'An error occurred: ${e.message}'; // Mensaje de error genérico
    } catch (e) {
      // Maneja cualquier otro error
      debugPrint('Login error: $e');
      return 'An unexpected error occurred. Please try again.';
    }
  }

  // _signupUser también debería usar AuthService si quieres registrar nuevos usuarios
  Future<String?> _signupUserWithAuthService(SignupData data, BuildContext context) async {
    final authService = AuthService();
    if (data.name == null || data.password == null) {
      return 'Email and password cannot be empty.';
    }
    try {
      UserCredential? userCredential = await authService.signUp(
        email: data.name!,
        password: data.password!,
      );

      if (userCredential?.user != null) {
        // Opcional: actualizar el nombre de usuario si lo recoges en campos adicionales
        if (data.additionalSignupData?['Username'] != null) {
          await userCredential?.user!.updateDisplayName(data.additionalSignupData!['Username']);
        }
        // Registro exitoso
        return null; // Retorna null para indicar éxito
      } else {
        return 'Signup failed. Please try again.';
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException during signup: ${e.code} - ${e.message}');
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      } else if (e.code == 'invalid-email') {
        return 'The email address is not valid.';
      }
      return 'An error occurred during sign up: ${e.message}';
    } catch (e) {
      debugPrint('Signup error: $e');
      return 'An unexpected error occurred during sign up.';
    }
  }


  Future<String?> _recoverPassword(String name) async {
    final authService = AuthService();
    try {
      // Llama a tu método de recuperación de contraseña de AuthService
      // Asumo que tienes un método como `resetPassword` en tu AuthService
      await authService.resetPassword(email: name);
      return null; // Indica éxito (flutter_login mostrará un mensaje de éxito)
    } on FirebaseAuthException catch (e) {
      debugPrint('Recover password error: ${e.code} - ${e.message}');
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'invalid-email') {
        return 'The email address is not valid.';
      }
      return 'Failed to send password reset email: ${e.message}';
    } catch (e) {
      debugPrint('Recover password error: $e');
      return 'An unexpected error occurred.';
    }
  }

  // Este método parece ser para confirmar algo después de la recuperación o el registro.
  // Decide si aún es necesario o cómo debe funcionar con AuthService.
  Future<String?> _signupConfirm(String? error, LoginData data) {
    // return Future<void>.delayed(loginTime).then((_) {
    //   return null;
    // });
    // Si no hay nada que confirmar o si el flujo de AuthService lo maneja,
    // puedes simplemente retornar null o un mensaje.
    if (error != null) {
      return Future.value(error);
    }
    return Future.value(null); // O un mensaje de éxito si es apropiado
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: Constants.appName,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      logo: const AssetImage('assets/images/ecorp.png'),
      logoTag: Constants.logoTag,
      titleTag: Constants.titleTag,
      navigateBackAfterRecovery: true,
      onConfirmRecover: (error, data) => _signupConfirm(error, data as LoginData), // Ajusta según la firma de _signupConfirm
      onConfirmSignup: (error, data) => _signupConfirm(error, data as LoginData), // Ajusta según la firma de _signupConfirm
      loginAfterSignUp: true, // Si es true, intentará hacer login después de un signup exitoso
      autofocus: true,
      loginProviders: [
        LoginProvider(
          button: Buttons.google,
          label: 'Sign in with Google',
          callback: () async {
            try {
              final userCredential = await AuthService().signInWithGoogle();
              if (userCredential?.user != null) {
                // Navegación después de Google Sign-In (si no se maneja en onSubmitAnimationCompleted o dentro de signInWithGoogle)
                // Navigator.of(context).pushReplacement(
                //   FadePageRoute(builder: (context) => const HabitQuizApp()),
                // );
                return null; // Indica éxito
              }
              return 'Failed to sign in with Google.';
            } catch (e) {
              debugPrint('Google sign-in error: $e');
              return 'Failed to sign in with Google: $e';
            }
          },
        )
      ],
      termsOfService: [
        TermOfService(
          id: 'newsletter',
          mandatory: false,
          text: 'Newsletter subscription',
        ),
        TermOfService(
          id: 'general-term',
          mandatory: true,
          text: 'Term of services',
          linkUrl: 'https://github.com/NearHuscarl/flutter_login',
        ),
      ],
      additionalSignupFields: [
        const UserFormField(
          keyName: 'Username', // Usado para displayName en Firebase
          displayName: 'Username',
          icon: Icon(FontAwesomeIcons.userLarge),
        ),
        // Puedes añadir más campos si los necesitas y manejarlos en _signupUserWithAuthService
        // const UserFormField(keyName: 'Name'),
        // const UserFormField(keyName: 'Surname'),
      ],
      userValidator: (value) {
        if (value == null || value.isEmpty) {
          return 'Email cannot be empty.';
        }
        if (!value.contains('@') || !value.endsWith('.com')) { // O una validación de email más robusta
          return "Please enter a valid email address.";
        }
        return null;
      },
      passwordValidator: (value) {
        if (value == null || value.isEmpty) {
          return 'Password is empty';
        }
        if (value.length < 6) { // Ejemplo: Firebase requiere al menos 6 caracteres
          return 'Password must be at least 6 characters.';
        }
        return null;
      },
      onLogin: (loginData) {
        debugPrint('Login info');
        debugPrint('Name (Email): ${loginData.name}');
        debugPrint('Password: ${loginData.password}');
        // Llama al nuevo método que usa AuthService
        return _loginUserWithAuthService(loginData, context);
      },
      onSignup: (signupData) {
        debugPrint('Signup info');
        debugPrint('Name (Email): ${signupData.name}');
        debugPrint('Password: ${signupData.password}');
        signupData.additionalSignupData?.forEach((key, value) {
          debugPrint('$key: $value');
        });
        // Llama al nuevo método que usa AuthService
        return _signupUserWithAuthService(signupData, context);
      },
      onSubmitAnimationCompleted: () {
        // Esta función se llama después de que la animación de login/signup ha terminado
        // y el callback onLogin/onSignup ha retornado null (éxito).
        // Navega a la pantalla principal de tu aplicación.
        // Podrías querer ir a DashboardScreen o HabitQuizApp dependiendo del flujo.
        // Si el usuario acaba de registrarse, quizás HabitQuizApp es más apropiado.
        // Si ya existe y solo hizo login, DashboardScreen.
        // Aquí tendrás que decidir la lógica o pasar un parámetro para diferenciar.
        // Por simplicidad, vamos a DashboardScreen.
        Navigator.of(context).pushReplacement(
          FadePageRoute<void>(
            builder: (context) => const DashboardScreen(), // O HabitQuizApp()
          ),
        );
      },
      onRecoverPassword: (name) {
        debugPrint('Recover password info');
        debugPrint('Name (Email): $name');
        return _recoverPassword(name);
      },
      headerWidget: const IntroWidget(),
    );
  }
}

class IntroWidget extends StatelessWidget {
  const IntroWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        const Row(
          children: <Widget>[
            Expanded(child: Divider()),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text('Authenticate'),
            ),
            Expanded(child: Divider()),
          ],
        ),
      ],
    );
  }
}
