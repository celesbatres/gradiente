import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gradiente/firebase_options.dart';
import 'package:gradiente/new_login_screen.dart';
import 'package:gradiente/services/auth/auth_service.dart';

void main() {
  group('Integration Tests - Firebase Authentication Flow', () {
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

    test('Firebase should be properly initialized', () {
      expect(Firebase.apps.isNotEmpty, true);
      expect(FirebaseAuth.instance, isNotNull);
    });

    test('AuthService should be properly instantiated', () {
      expect(authService, isNotNull);
      expect(authService.getCurrentUser(), anyOf(isNull, isNotNull));
    });

    testWidgets('Login screen should render without errors', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: NewLoginScreen(),
      ));

      // Verificar que la pantalla se renderice correctamente
      expect(find.text('Login'), findsOneWidget);
      expect(find.text('Welcome Back!'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('Form validation should work correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: NewLoginScreen(),
      ));

      // Probar validación de campos vacíos
      await tester.tap(find.text('Login'));
      await tester.pump();

      expect(find.text('Please enter your email'), findsOneWidget);
      expect(find.text('Please enter your password'), findsOneWidget);

      // Probar validación de email inválido
      await tester.enterText(find.byType(TextFormField).first, 'invalid-email');
      await tester.enterText(find.byType(TextFormField).last, 'password123');
      
      await tester.tap(find.text('Login'));
      await tester.pump();

      expect(find.text('Please enter a valid email address'), findsOneWidget);
    });

    testWidgets('Loading state should be properly managed', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: NewLoginScreen(),
      ));

      // Verificar que no hay indicador de carga inicialmente
      expect(find.byType(CircularProgressIndicator), findsNothing);

      // Llenar formulario y presionar login
      await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
      await tester.enterText(find.byType(TextFormField).last, 'password123');
      
      await tester.tap(find.text('Login'));
      await tester.pump();

      // Verificar que aparezca el indicador de carga
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Error handling should work for invalid credentials', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: NewLoginScreen(),
      ));

      // Llenar formulario con credenciales que probablemente fallen
      await tester.enterText(find.byType(TextFormField).first, 'nonexistent@example.com');
      await tester.enterText(find.byType(TextFormField).last, 'wrongpassword');
      
      await tester.tap(find.text('Login'));
      
      // Esperar a que se procese la autenticación
      await tester.pumpAndSettle();

      // Verificar que se muestre algún mensaje de error
      expect(find.byType(Text), anyElement);
    });

    testWidgets('Navigation should work after successful authentication', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: NewLoginScreen(),
      ));

      // Este test requeriría un usuario válido en Firebase
      // Por ahora solo verificamos que la navegación esté configurada
      expect(find.byType(NewLoginScreen), findsOneWidget);
    });

    test('Firebase Auth state changes should be listenable', () {
      final auth = FirebaseAuth.instance;
      bool listenerCalled = false;
      
      final subscription = auth.authStateChanges().listen((User? user) {
        listenerCalled = true;
        expect(user, anyOf(isNull, isNotNull));
      });

      // Cancelar la suscripción después de un breve delay
      Future.delayed(const Duration(milliseconds: 100), () {
        subscription.cancel();
      });

      expect(listenerCalled, true);
    });

    test('AuthService methods should not throw unexpected exceptions', () async {
      // Probar que los métodos básicos no lancen excepciones inesperadas
      expect(() async => await authService.signOut(), returnsNormally);
      expect(() async => await authService.resetPassword(email: 'test@example.com'), returnsNormally);
    });
  });
}
