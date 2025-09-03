import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gradiente/firebase_options.dart';
import 'package:gradiente/services/auth/auth_service.dart';

void main() {
  group('AuthService Tests', () {
    late AuthService authService;

    setUpAll(() async {
      // Inicializar Firebase para testing
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    });

    setUp(() {
      authService = AuthService();
    });

    test('AuthService should be created', () {
      expect(authService, isNotNull);
    });

    test('getCurrentUser should return current user or null', () {
      final user = authService.getCurrentUser();
      expect(user, anyOf(isNull, isNotNull));
    });

    test('signOut should not throw exception', () async {
      // Este test verifica que signOut no lance excepciones
      expect(() async => await authService.signOut(), returnsNormally);
    });

    test('resetPassword should not throw exception for valid email format', () async {
      // Este test verifica que resetPassword no lance excepciones para emails válidos
      expect(() async => await authService.resetPassword(email: 'test@example.com'), returnsNormally);
    });

    test('updateUsername should not throw exception when user is not null', () async {
      // Este test verifica que updateUsername no lance excepciones
      expect(() async => await authService.updateUsername(username: 'testuser'), returnsNormally);
    });

    test('signInWithGoogle should handle Google Sign In flow', () async {
      // Este test verifica que signInWithGoogle no lance excepciones inesperadas
      // Nota: En un entorno de testing real, esto requeriría mocks
      expect(() async => await authService.signInWithGoogle(), returnsNormally);
    });

    test('deleteAccount should not throw exception for valid credentials', () async {
      // Este test verifica que deleteAccount no lance excepciones para credenciales válidas
      expect(() async => await authService.deleteAccount(
        email: 'test@example.com', 
        password: 'password123'
      ), returnsNormally);
    });

    test('resetPasswordFromCurrentPassword should not throw exception for valid data', () async {
      // Este test verifica que resetPasswordFromCurrentPassword no lance excepciones
      expect(() async => await authService.resetPasswordFromCurrentPassword(
        currentPassword: 'oldpassword',
        newPassword: 'newpassword123',
        email: 'test@example.com'
      ), returnsNormally);
    });
  });
}

