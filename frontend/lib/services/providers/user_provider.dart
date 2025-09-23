import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user.dart' as UserModel;
import '../api/uid_api_service.dart';

class UserProvider extends ChangeNotifier {
  UserModel.User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  UserModel.User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _currentUser != null && _currentUser!.existsUser();

  // Claves para SharedPreferences
  static const String _userKey = 'user_id';
  static const String _userNameKey = 'user_name';

  /// Inicializar el usuario desde SharedPreferences al iniciar la app
  Future<void> initializeUser() async {
    _setLoading(true);
    
    try {
      // Verificar si hay un usuario de Firebase autenticado
      final firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser == null) {
        _setLoading(false);
        return;
      }

      // Intentar cargar usuario desde SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final savedUserId = prefs.getString(_userKey);
      final savedUserName = prefs.getString(_userNameKey);

      if (savedUserId != null && savedUserName != null) {
        // Usuario guardado localmente, crear objeto User
        _currentUser = UserModel.User(
          user: int.parse(savedUserId),
          name: savedUserName,
        );
        _setLoading(false);
        return;
      }

      // Si no hay datos locales, obtener desde la API
      await _loadUserFromApi(firebaseUser.uid);
    } catch (e) {
      _setError('Error al inicializar usuario: $e');
    }
  }

  /// Cargar usuario desde la API
  Future<void> _loadUserFromApi(String firebaseUid) async {
    try {
      final user = await UidApiService.getUserByFirebaseUid(firebaseUid);
      if (user.existsUser()) {
        await _setUser(user);
      } else {
        _setError('Usuario no encontrado en la base de datos');
      }
    } catch (e) {
      _setError('Error al cargar usuario: $e');
    }
  }

  /// Establecer usuario y guardarlo localmente
  Future<void> _setUser(UserModel.User user) async {
    _currentUser = user;
    _errorMessage = null;
    
    // Guardar en SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, user.user.toString());
    await prefs.setString(_userNameKey, user.name);
    
    notifyListeners();
  }

  /// Crear nuevo usuario
  Future<void> createUser(String firebaseUid, String name) async {
    _setLoading(true);
    
    try {
      final userId = await UidApiService.createUser(firebaseUid, name);
      if (userId != null) {
        final newUser = UserModel.User(
          user: int.parse(userId),
          name: name,
        );
        await _setUser(newUser);
      } else {
        _setError('Error al crear usuario');
      }
    } catch (e) {
      _setError('Error al crear usuario: $e');
    }
  }

  /// Actualizar usuario desde la API
  Future<void> refreshUser() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      await _loadUserFromApi(firebaseUser.uid);
    }
  }

  /// Cerrar sesión
  Future<void> signOut() async {
    _setLoading(true);
    
    try {
      // Limpiar SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userKey);
      await prefs.remove(_userNameKey);
      
      // Limpiar estado
      _currentUser = null;
      _errorMessage = null;
      
      notifyListeners();
    } catch (e) {
      _setError('Error al cerrar sesión: $e');
    }
  }

  /// Métodos privados para manejar estado
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    _isLoading = false;
    notifyListeners();
  }

  /// Limpiar errores
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
