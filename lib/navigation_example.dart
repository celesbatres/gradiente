// C:/Users/celes/Documents/Uni/gradiente/lib/navigation_example.dart
import 'package:flutter/material.dart';
import 'package:gradiente/profile.dart';

// void main() => runApp(const NavigationBarApp()); // You might not need this main if it's part of a larger app

class NavigationBarApp extends StatelessWidget {
  const NavigationBarApp({super.key});

  // Add a static routeName
  static const String routeName = '/navigation_example';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp( // This MaterialApp is fine if NavigationBarApp is the entry for this route
      home: NavigationExample(),
    );
  }
}

class NavigationExample extends StatefulWidget {
  const NavigationExample({super.key});

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  int currentPageIndex = 0;
  final List<bool> _notificationCheckboxStates = [false, false];
  final List<bool> _habitsCheckboxStates = [false, false]; // For the "Hábitos" (Leer, Hidratarme) section
  // Add more state lists if you have more lists of checkable items
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      // appBar: AppBar( // Optional: Add an AppBar if you want a title or back button handled by the Scaffold
      //   title: const Text('Navigation Example'),
      // ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          if (index == 4) { // Check if the "Perfil" destination is selected
            Navigator.pushNamed(context, ProfileScreen.routeName);
            // We don't call setState here to change currentPageIndex for "Perfil"
            // because we are navigating away. If ProfileScreen was meant to be
            // one of the bodies in the <Widget>[...] list, then you would update
            // currentPageIndex.
          } else {
            setState(() {
              currentPageIndex = index;
            });
          }
        },
        indicatorColor: Colors.amber,
        selectedIndex: currentPageIndex,
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
          // NavigationDestination(
          //   icon: Badge(label: Text('2'), child: Icon(Icons.messenger_sharp)),
          //   label: 'Messages',
          // ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
      body: <Widget>[
        /// Home page
        Card(
          shadowColor: Colors.transparent,
          margin: const EdgeInsets.all(8.0),
          child: SizedBox.expand(
            child: Center(child: Text('Home page', style: theme.textTheme.titleLarge)),
          ),
        ),



        /// Notifications page
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              const Card(
                child: ListTile(
                  leading: Icon(Icons.book),
                  title: Text('Leer'),
                  subtitle: Text('Objetivo Diario: 10 minutos\nDuración: 1h\nGénero: Acción'),
                ),
              ),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.water_drop),
                  title: const Text('Hidratarme'),
                  subtitle: const Text('Objetivo Diario: 2 lts\nCantidad: 2 vasos'),
                  trailing: Checkbox( // <--- CHECKBOX ADDED
                    value: false, onChanged: (bool? value) {  },
                  ),
                ),
              ),
            ],
          ),
        ),

        /// Notifications page
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children:
            <Widget>[
              Row(
                children: <Widget>[Text(
                  "Elije una actividad",
                  style: TextStyle(fontSize: 24.0), // fontSize is a double
                )],
              ),
              const Card(
                child: ListTile(
                  leading: Icon(Icons.book),
                  title: Text('Leer'),
                ),
              ),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.water_drop),
                  title: const Text('Hidratarme'),
                  ),
                ),
            ],
          ),
        ),

        /// Notifications page
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Card(
                child: ListTile(
                  leading: Icon(Icons.notifications_sharp),
                  title: Text('Notification 1'),
                  subtitle: Text('This is a notification'),
                ),
              ),
              Card(
                child: ListTile(
                  leading: Icon(Icons.notifications_sharp),
                  title: Text('Notification 2'),
                  subtitle: Text('This is a notification'),
                ),
              ),
            ],
          ),
        ),

        /// Notifications page
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Card(
                child: ListTile(
                  leading: Icon(Icons.notifications_sharp),
                  title: Text('Notification 1'),
                  subtitle: Text('This is a notification'),
                ),
              ),
              Card(
                child: ListTile(
                  leading: Icon(Icons.notifications_sharp),
                  title: Text('Notification 2'),
                  subtitle: Text('This is a notification'),
                ),
              ),
            ],
          ),
        ),

        /// Messages page
        ListView.builder(
          reverse: true,
          itemCount: 2,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return Align(
                alignment: Alignment.centerRight,
                child: Container(
                  margin: const EdgeInsets.all(8.0),
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    'Hello',
                    style: theme.textTheme.bodyLarge!.copyWith(color: theme.colorScheme.onPrimary),
                  ),
                ),
              );
            }
            return Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.all(8.0),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  'Hi!',
                  style: theme.textTheme.bodyLarge!.copyWith(color: theme.colorScheme.onPrimary),
                ),
              ),
            );
          },
        ),
      ][currentPageIndex],
    );
  }
}
