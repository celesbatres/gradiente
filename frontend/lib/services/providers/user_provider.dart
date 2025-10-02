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
  static const String _firebaseUidKey = 'firebase_uid';

  /// Inicializar el usuario desde SharedPreferences al iniciar la app
  Future<void> initializeUser() async {
    _setLoading(true);
    clearError();
    
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
      final savedFirebaseUid = prefs.getString(_firebaseUidKey);

      if (savedUserId != null && savedUserName != null && savedFirebaseUid != null) {
        // Usuario guardado localmente, crear objeto User
        _currentUser = UserModel.User(
          user: int.parse(savedUserId),
          name: savedUserName,
          firebaseUid: savedFirebaseUid,
        );
        _setLoading(false);
        notifyListeners();
        return;
      }

      // Si no hay datos locales, obtener desde la API
      await _loadUserFromApi(firebaseUser.uid);
    } catch (e) {
      _setError('Error al inicializar usuario: $e');
    }
  }

  /// Cargar usuario desde la API - busca o crea usuario
  Future<void> _loadUserFromApi(String firebaseUid) async {
    try {
      // Obtener el nombre del usuario de Firebase
      final firebaseUser = FirebaseAuth.instance.currentUser;
      final userName = firebaseUser?.displayName ?? 'Usuario';
      
      // Buscar o crear usuario en la base de datos
      final user = await UidApiService.getOrCreateUser(firebaseUid, userName);
      await _setUser(user);
    } catch (e) {
      _setError('Error al cargar usuario: $e');
    } finally {
      _setLoading(false);
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
    if (user.firebaseUid != null) {
      await prefs.setString(_firebaseUidKey, user.firebaseUid!);
    }
    
    notifyListeners();
  }

  /// Crear nuevo usuario - ahora usa getOrCreateUser
  Future<void> createUser(String firebaseUid, String name) async {
    _setLoading(true);
    clearError();
    
    try {
      final user = await UidApiService.getOrCreateUser(firebaseUid, name);
      await _setUser(user);
    } catch (e) {
      _setError('Error al crear usuario: $e');
    } finally {
      _setLoading(false);
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
      await prefs.remove(_firebaseUidKey);
      
      // Limpiar estado
      _currentUser = null;
      _errorMessage = null;
      
      notifyListeners();
    } catch (e) {
      _setError('Error al cerrar sesión: $e');
    } finally {
      _setLoading(false);
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
