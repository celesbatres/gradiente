// lib/navigation_example.dart
import 'package:flutter/material.dart';
import 'package:gradiente/profile.dart'; // For Perfil navigation

// Import the new page files
import 'pages/home.dart';
import 'pages/habitos.dart';
import 'pages/registrar.dart';
import 'pages/comunidad.dart';

class NavigationBarApp extends StatelessWidget {
  const NavigationBarApp({super.key});
  static const String routeName = '/navigation_example';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const NavigationExample(),
      routes: { // Define routes that might be pushed from within NavigationExample if needed
        ProfileScreen.routeName: (context) => const ProfileScreen(),
      },
    );
  }
}

class NavigationExample extends StatefulWidget {
  const NavigationExample({super.key});

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  int _currentPageIndex = 0; // Renamed for clarity

  // List of Widgets for the body.
  // These are now instances of your new page classes.
  final List<Widget> _pages = const [
    HomePage(),
    HabitosPage(),
    RegistrarPage(),
    ComunidadPage(),
    // We don't include a widget for "Perfil" here because we navigate away.
  ];

  @override
  Widget build(BuildContext context) {
    // final ThemeData theme = Theme.of(context); // Not needed here anymore

    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          if (index == 4) { // "Perfil" is the 5th item (index 4)
            Navigator.pushNamed(context, ProfileScreen.routeName);
          } else {
            setState(() {
              _currentPageIndex = index;
            });
          }
        },
        indicatorColor: Colors.amber,
        selectedIndex: _currentPageIndex, // This will correctly show active tab unless Perfil is selected
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Inicio',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.self_improvement_sharp),
            icon: Icon(Icons.self_improvement_sharp),
            label: 'Hábitos',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.adjust_sharp),
            icon: Icon(Icons.adjust_sharp),
            label: 'Registrar',
          ),
          NavigationDestination(
            icon: Badge(child: Icon(Icons.groups_sharp)),
            label: 'Comunidad',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
      // Display the current page from the _pages list.
      // If Perfil is selected (and we navigate away), this part might not be
      // relevant as ProfileScreen takes over. We ensure _currentPageIndex doesn't go out of bounds.
      body: _currentPageIndex < _pages.length
          ? _pages[_currentPageIndex]
          : Container(child: Center(child: Text("Error: Page index out of bounds or Profile selected."))), // Fallback
    );
  }
}
