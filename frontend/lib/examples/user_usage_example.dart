import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/providers/auth_provider.dart';

/// Ejemplo de cómo usar el usuario en cualquier pantalla de la aplicación
class UserUsageExample extends StatelessWidget {
  const UserUsageExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ejemplo de Uso del Usuario'),
        actions: [
          IconButton(
            onPressed: () async {
              final authProvider = Provider.of<AuthProvider>(context, listen: false);
              await authProvider.signOut();
              // Navegar de vuelta al login
              Navigator.of(context).pushReplacementNamed('/new_login');
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          final userProvider = authProvider.userProvider;
          
          if (userProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!authProvider.isAuthenticated) {
            return const Center(
              child: Text('No hay usuario autenticado'),
            );
          }

          if (!userProvider.isLoggedIn) {
            return const Center(
              child: Text('Usuario no encontrado en la base de datos'),
            );
          }

          final user = userProvider.currentUser!;
          
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Información del Usuario',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 16),
                        Text('ID de Usuario: ${user.user}'),
                        Text('Nombre: ${user.name}'),
                        Text('Firebase UID: ${authProvider.firebaseUser?.uid ?? 'N/A'}'),
                        Text('Email: ${authProvider.firebaseUser?.email ?? 'N/A'}'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Acciones Disponibles',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () async {
                            // Refrescar datos del usuario desde la API
                            await userProvider.refreshUser();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Usuario actualizado')),
                            );
                          },
                          child: const Text('Actualizar Usuario'),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {
                            // Mostrar información detallada
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Detalles del Usuario'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('ID: ${user.user}'),
                                    Text('Nombre: ${user.name}'),
                                    Text('Firebase UID: ${authProvider.firebaseUser?.uid}'),
                                    Text('Email: ${authProvider.firebaseUser?.email}'),
                                    Text('Verificado: ${authProvider.firebaseUser?.emailVerified}'),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(),
                                    child: const Text('Cerrar'),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: const Text('Ver Detalles'),
                        ),
                      ],
                    ),
                  ),
                ),
                if (userProvider.errorMessage != null) ...[
                  const SizedBox(height: 16),
                  Card(
                    color: Colors.red.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Error',
                            style: TextStyle(
                              color: Colors.red.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            userProvider.errorMessage!,
                            style: TextStyle(color: Colors.red.shade700),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () => userProvider.clearError(),
                            child: const Text('Limpiar Error'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
