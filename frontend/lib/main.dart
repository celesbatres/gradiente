import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:gradiente/dashboard_screen.dart';
import 'package:gradiente/login_screen.dart';
import 'package:gradiente/new_login_screen.dart';
import 'package:gradiente/pages/add_habito.dart';
import 'package:gradiente/pages/test_habits_api.dart';
import 'package:gradiente/example_api_usage.dart';
import 'package:gradiente/profile.dart';
import 'package:gradiente/transition_route_observer.dart';
import 'package:gradiente/services/providers/auth_provider.dart';
import 'package:gradiente/examples/simple_user_example.dart';

import 'firebase_options.dart';
import 'navigation_example.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..initializeAuth()),
      ],
      child: MaterialApp(
        title: 'Login Demo',
        debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textSelectionTheme:
        const TextSelectionThemeData(cursorColor: Colors.orange),
        // fontFamily: 'SourceSansPro',
        textTheme: TextTheme(
          displaySmall: const TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 45,
            // fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
          labelLarge: const TextStyle(
            // OpenSans is similar to NotoSans but the uppercases look a bit better IMO
            fontFamily: 'OpenSans',
          ),
          bodySmall: TextStyle(
            fontFamily: 'NotoSans',
            fontSize: 12,
            fontWeight: FontWeight.normal,
            color: Colors.deepPurple[50],
          ),
          displayLarge: const TextStyle(fontFamily: 'Quicksand'),
          displayMedium: const TextStyle(fontFamily: 'Quicksand'),
          headlineMedium: const TextStyle(fontFamily: 'Quicksand'),
          headlineSmall: const TextStyle(fontFamily: 'NotoSans'),
          titleLarge: const TextStyle(fontFamily: 'NotoSans'),
          titleMedium: const TextStyle(fontFamily: 'NotoSans'),
          bodyLarge: const TextStyle(fontFamily: 'NotoSans'),
          bodyMedium: const TextStyle(fontFamily: 'NotoSans'),
          titleSmall: const TextStyle(fontFamily: 'NotoSans'),
          labelSmall: const TextStyle(fontFamily: 'NotoSans'),
        ),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple)
            .copyWith(secondary: Colors.orange),
      ),
      navigatorObservers: [TransitionRouteObserver()],
      initialRoute: NewLoginScreen.routeName,
      routes: {
        LoginScreen.routeName: (context) => const LoginScreen(),
        DashboardScreen.routeName: (context) => const DashboardScreen(),
        NewLoginScreen.routeName: (context) => const NewLoginScreen(),
        NavigationBarApp.routeName: (context) => const NavigationBarApp(), // <--- ADD THIS LINE
        // OR, if NavigationExample is sufficient and doesn't need its own MaterialApp from NavigationBarApp:
        // NavigationExample.routeName: (context) => const NavigationExample(),
        ProfileScreen.routeName: (context) => const ProfileScreen(),
        AddHabitScreen.routeName: (context) => AddHabitScreen(),
        TestHabitsApiScreen.routeName: (context) => const TestHabitsApiScreen(),
        ExampleApiUsageScreen.routeName: (context) => const ExampleApiUsageScreen(),
        '/user_example': (context) => const SimpleUserExample(),
      },
      ),
    );
  }
}