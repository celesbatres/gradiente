import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/providers/auth_provider.dart' as AuthProvider;

/// Ejemplo simple de cómo acceder al usuario en cualquier pantalla
class SimpleUserExample extends StatelessWidget {
  const SimpleUserExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuario Actual'),
        actions: [
          IconButton(
            onPressed: () async {
              final authProvider = Provider.of<AuthProvider.AuthProvider>(context, listen: false);
              await authProvider.signOut();
              Navigator.of(context).pushReplacementNamed('/new_login');
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Consumer<AuthProvider.AuthProvider>(
        builder: (context, authProvider, child) {
          // Verificar si hay usuario autenticado
          if (!authProvider.isAuthenticated) {
            return const Center(
              child: Text('No hay usuario autenticado'),
            );
          }

          // Verificar si el usuario existe en la base de datos
          if (!authProvider.userProvider.isLoggedIn) {
            return const Center(
              child: Text('Usuario no encontrado en la base de datos'),
            );
          }

          // Obtener el usuario actual
          final user = authProvider.userProvider.currentUser!;
          
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.person),
                    title: Text('ID: ${user.user}'),
                    subtitle: Text('Nombre: ${user.name}'),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.email),
                    title: Text('Email: ${authProvider.firebaseUser?.email ?? 'N/A'}'),
                    subtitle: Text('UID: ${authProvider.firebaseUser?.uid ?? 'N/A'}'),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Aquí puedes usar el user.user (ID) para hacer llamadas a la API
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Usuario ID: ${user.user} - Nombre: ${user.name}'),
                      ),
                    );
                  },
                  child: const Text('Mostrar Info del Usuario'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
