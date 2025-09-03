import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gradiente/firebase_options.dart';
import 'package:gradiente/new_login_screen.dart';

void main() {
  group('NewLoginScreen Tests', () {
    setUpAll(() async {
      // Inicializar Firebase para testing
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    });

    testWidgets('NewLoginScreen should render correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: NewLoginScreen(),
      ));

      // Verificar que los elementos principales estén presentes
      expect(find.text('Login'), findsOneWidget);
      expect(find.text('Welcome Back!'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Enter your email'), findsOneWidget);
      expect(find.text('Enter your password'), findsOneWidget);
    });

    testWidgets('Form validation should work for empty fields', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: NewLoginScreen(),
      ));

      // Intentar hacer login sin llenar campos
      await tester.tap(find.text('Login'));
      await tester.pump();

      // Verificar que aparezcan mensajes de error
      expect(find.text('Please enter your email'), findsOneWidget);
      expect(find.text('Please enter your password'), findsOneWidget);
    });

    testWidgets('Form validation should work for invalid email', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: NewLoginScreen(),
      ));

      // Escribir email inválido
      await tester.enterText(find.byType(TextFormField).first, 'invalid-email');
      await tester.enterText(find.byType(TextFormField).last, 'password123');
      
      await tester.tap(find.text('Login'));
      await tester.pump();

      // Verificar que aparezca mensaje de error para email inválido
      expect(find.text('Please enter a valid email address'), findsOneWidget);
    });

    testWidgets('Form validation should work for short password', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: NewLoginScreen(),
      ));

      // Escribir email válido y contraseña corta
      await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
      await tester.enterText(find.byType(TextFormField).last, '123');
      
      await tester.tap(find.text('Login'));
      await tester.pump();

      // Verificar que aparezca mensaje de error para contraseña corta
      expect(find.text('Password must be at least 6 characters'), findsOneWidget);
    });

    testWidgets('Form should accept valid input', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: NewLoginScreen(),
      ));

      // Escribir datos válidos
      await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
      await tester.enterText(find.byType(TextFormField).last, 'password123');
      
      await tester.tap(find.text('Login'));
      await tester.pump();

      // Verificar que no haya mensajes de error
      expect(find.text('Please enter your email'), findsNothing);
      expect(find.text('Please enter your password'), findsNothing);
      expect(find.text('Please enter a valid email address'), findsNothing);
      expect(find.text('Password must be at least 6 characters'), findsNothing);
    });

    testWidgets('Loading indicator should show when login button is pressed', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: NewLoginScreen(),
      ));

      // Escribir datos válidos
      await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
      await tester.enterText(find.byType(TextFormField).last, 'password123');
      
      // Verificar que no haya indicador de carga inicialmente
      expect(find.byType(CircularProgressIndicator), findsNothing);
      
      await tester.tap(find.text('Login'));
      await tester.pump();

      // Verificar que aparezca el indicador de carga
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Form fields should have correct labels', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: NewLoginScreen(),
      ));

      // Verificar que los campos tengan las etiquetas correctas
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
    });
  });
}
