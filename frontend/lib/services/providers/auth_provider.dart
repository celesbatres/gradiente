import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth/auth_service.dart';
import 'user_provider.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final UserProvider _userProvider = UserProvider();
  
  bool _isLoading = false;
  String? _errorMessage;
  User? _firebaseUser;

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get firebaseUser => _firebaseUser;
  bool get isAuthenticated => _firebaseUser != null;
  UserProvider get userProvider => _userProvider;

  /// Inicializar autenticación
  Future<void> initializeAuth() async {
    _setLoading(true);
    
    try {
      _firebaseUser = _authService.getCurrentUser();
      
      if (_firebaseUser != null) {
        // Inicializar el usuario si está autenticado
        await _userProvider.initializeUser();
      }
    } catch (e) {
      _setError('Error al inicializar autenticación: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Iniciar sesión con email y contraseña
  Future<bool> signInWithEmail(String email, String password) async {
    _setLoading(true);
    _clearError();
    
    try {
      final userCredential = await _authService.signIn(
        email: email,
        password: password,
      );

      if (userCredential?.user != null) {
        _firebaseUser = userCredential!.user;
        
        // Cargar datos del usuario desde la API
        await _userProvider.initializeUser();
        
        notifyListeners();
        return true;
      }
      
      _setError('Error al iniciar sesión');
      return false;
    } catch (e) {
      _setError('Error al iniciar sesión: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Registrarse con email y contraseña
  Future<bool> signUpWithEmail(String email, String password, String name) async {
    _setLoading(true);
    _clearError();
    
    try {
      final userCredential = await _authService.signUp(
        email: email,
        password: password,
      );

      if (userCredential?.user != null) {
        _firebaseUser = userCredential!.user;
        
        // Crear usuario en la base de datos
        await _userProvider.createUser(_firebaseUser!.uid, name);
        
        notifyListeners();
        return true;
      }
      
      _setError('Error al registrarse');
      return false;
    } catch (e) {
      _setError('Error al registrarse: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Iniciar sesión con Google
  Future<bool> signInWithGoogle() async {
    _setLoading(true);
    _clearError();
    
    try {
      final userCredential = await _authService.signInWithGoogle();
      
      if (userCredential != null) {
        _firebaseUser = userCredential.user;
        
        // Detectar si es un nuevo usuario
        bool isNewUser = userCredential.additionalUserInfo?.isNewUser == true;
        
        if (isNewUser) {
          // Nuevo usuario - crear en la base de datos
          final displayName = _firebaseUser!.displayName ?? 'Usuario';
          await _userProvider.createUser(_firebaseUser!.uid, displayName);
        } else {
          // Usuario existente - cargar datos
          await _userProvider.initializeUser();
        }
        
        notifyListeners();
        return true;
      }
      
      _setError('Inicio de sesión cancelado');
      return false;
    } catch (e) {
      _setError('Error al iniciar sesión con Google: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Cerrar sesión
  Future<void> signOut() async {
    _setLoading(true);
    
    try {
      await _authService.signOut();
      await _userProvider.signOut();
      
      _firebaseUser = null;
      notifyListeners();
    } catch (e) {
      _setError('Error al cerrar sesión: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Métodos privados
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    _isLoading = false;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }
}
