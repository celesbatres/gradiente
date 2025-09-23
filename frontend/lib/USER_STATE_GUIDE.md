# Guía de Manejo de Estado del Usuario

## 📋 Resumen

Se ha implementado un sistema completo de manejo de estado del usuario usando **Provider** + **SharedPreferences** que permite:

- ✅ Persistencia local del usuario (funciona offline)
- ✅ Estado reactivo en toda la aplicación
- ✅ Sincronización automática con Firebase Auth
- ✅ Manejo de errores centralizado

## 🏗️ Arquitectura

### Providers

1. **AuthProvider** (`services/providers/auth_provider.dart`)
   - Maneja la autenticación con Firebase
   - Coordina con UserProvider
   - Proporciona métodos para login, registro y logout

2. **UserProvider** (`services/providers/user_provider.dart`)
   - Maneja los datos del usuario de la base de datos
   - Persistencia local con SharedPreferences
   - Sincronización con la API

## 🚀 Cómo Usar

### 1. Acceder al Usuario en Cualquier Pantalla

```dart
import 'package:provider/provider.dart';
import 'package:gradiente/services/providers/auth_provider.dart' as AuthProvider;

class MiPantalla extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider.AuthProvider>(
      builder: (context, authProvider, child) {
        // Verificar si está autenticado
        if (!authProvider.isAuthenticated) {
          return Text('No autenticado');
        }

        // Verificar si el usuario existe en la BD
        if (!authProvider.userProvider.isLoggedIn) {
          return Text('Usuario no encontrado');
        }

        // Obtener el usuario actual
        final user = authProvider.userProvider.currentUser!;
        
        return Text('Usuario ID: ${user.user}, Nombre: ${user.name}');
      },
    );
  }
}
```

### 2. Usar el ID del Usuario para Llamadas API

```dart
// En cualquier pantalla
final authProvider = Provider.of<AuthProvider.AuthProvider>(context, listen: false);
final userId = authProvider.userProvider.currentUser?.user;

if (userId != null) {
  // Usar userId para llamadas a la API
  final habits = await HabitApiService.getUserHabits(userId);
}
```

### 3. Verificar Estado de Carga

```dart
Consumer<AuthProvider.AuthProvider>(
  builder: (context, authProvider, child) {
    if (authProvider.isLoading) {
      return CircularProgressIndicator();
    }
    
    // Resto del UI
  },
)
```

### 4. Manejar Errores

```dart
Consumer<AuthProvider.AuthProvider>(
  builder: (context, authProvider, child) {
    if (authProvider.errorMessage != null) {
      return Text('Error: ${authProvider.errorMessage}');
    }
    
    // Resto del UI
  },
)
```

## 🔧 Métodos Disponibles

### AuthProvider

- `signInWithEmail(email, password)` - Login con email
- `signUpWithEmail(email, password, name)` - Registro con email
- `signInWithGoogle()` - Login con Google
- `signOut()` - Cerrar sesión
- `isAuthenticated` - Verificar si está autenticado
- `isLoading` - Estado de carga
- `errorMessage` - Mensaje de error

### UserProvider

- `currentUser` - Usuario actual
- `isLoggedIn` - Verificar si existe en BD
- `refreshUser()` - Actualizar desde API
- `clearError()` - Limpiar errores

## 📱 Ejemplos

Ver archivos en `lib/examples/`:
- `simple_user_example.dart` - Ejemplo básico
- `user_usage_example.dart` - Ejemplo completo

## 🎯 Ventajas de esta Implementación

1. **Persistencia**: El usuario se mantiene entre sesiones
2. **Reactividad**: Cambios automáticos en toda la app
3. **Offline**: Funciona sin conexión
4. **Centralizado**: Un solo lugar para manejar el estado
5. **Escalable**: Fácil de extender
6. **Mantenible**: Código limpio y organizado

## 🔄 Flujo de Datos

1. Usuario inicia sesión → AuthProvider
2. AuthProvider crea/obtiene usuario → UserProvider
3. UserProvider guarda en SharedPreferences
4. Toda la app puede acceder al usuario via Provider
5. Al cerrar sesión → Se limpia todo el estado

## 🚨 Notas Importantes

- Siempre verificar `isAuthenticated` antes de acceder al usuario
- Usar `Consumer` para widgets que necesitan reaccionar a cambios
- Usar `Provider.of(..., listen: false)` para acciones que no necesitan rebuild
- El `user.user` es el ID numérico que debes usar en las APIs
