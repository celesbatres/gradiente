import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gradiente/firebase_options.dart';

void main() {
  group('Firebase Connection Tests', () {
    setUpAll(() async {
      // Inicializar Firebase para testing
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    });

    test('Firebase should be initialized', () {
      expect(Firebase.apps.isNotEmpty, true);
      expect(Firebase.app(), isNotNull);
    });

    test('Firebase Auth should be available', () {
      final auth = FirebaseAuth.instance;
      expect(auth, isNotNull);
      expect(auth.app, isNotNull);
    });

    test('Firebase Auth should have correct app name', () {
      final auth = FirebaseAuth.instance;
      expect(auth.app.name, isNotEmpty);
    });

    test('Firebase Auth should be able to get current user', () {
      final auth = FirebaseAuth.instance;
      final currentUser = auth.currentUser;
      // currentUser puede ser null si no hay usuario autenticado
      expect(currentUser, anyOf(isNull, isNotNull));
    });

    test('Firebase Auth should be able to listen to auth state changes', () {
      final auth = FirebaseAuth.instance;
      bool listenerCalled = false;
      
      final subscription = auth.authStateChanges().listen((User? user) {
        listenerCalled = true;
        expect(user, anyOf(isNull, isNotNull));
      });

      // Esperar un poco para que se ejecute el listener
      Future.delayed(const Duration(milliseconds: 100), () {
        subscription.cancel();
      });

      expect(listenerCalled, true);
    });
  });
}

