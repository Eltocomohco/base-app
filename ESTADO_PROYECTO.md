# Estado del Proyecto Pizzeria Pepe App

**Fecha**: 16 de Enero de 2026  
**Repositorio**: https://github.com/Eltocomohco/base-app.git

## 📋 Resumen del Proyecto

Aplicación Flutter completa para una pizzería con las siguientes funcionalidades implementadas:

### ✅ Funcionalidades Completadas

1. **Menú de Productos**
   - Visualización de categorías (Entrantes, Ensaladas, Pastas, Pizzas, Bebidas, Postres)
   - Listado de productos por categoría
   - Imágenes y descripciones de productos
   - Integración con Firebase Firestore

2. **Carrito de Compras**
   - Añadir/eliminar productos
   - Modificar cantidades
   - Cálculo de totales
   - Persistencia durante la sesión

3. **Proceso de Checkout**
   - Formulario de dirección de entrega
   - Selección de método de pago (Tarjeta, Bizum, Efectivo)
   - Creación de pedidos en Firestore

4. **Autenticación Firebase**
   - Login con email/contraseña
   - Registro de nuevos usuarios
   - Gestión de sesión
   - Pantalla de perfil de usuario

5. **Historial de Pedidos**
   - Visualización de pedidos del usuario
   - Estados de pedidos (Pendiente, Cocinando, Entregado)
   - Detalles de cada pedido

6. **Panel de Administración** 
   - Acceso restringido para `admin@pepe.com`
   - Visualización de todos los pedidos en tiempo real
   - Actualización de estados de pedidos
   - Dashboard administrativo

### 🔧 Tecnologías Utilizadas

- **Flutter**: Framework principal
- **Riverpod**: Gestión de estado (v3.1.0)
- **Firebase**:
  - Authentication (autenticación de usuarios)
  - Firestore (base de datos en tiempo real)
- **Go Router**: Navegación
- **ScreenUtil**: Diseño responsivo
- **Freezed**: Generación de código inmutable
- **Cached Network Image**: Optimización de imágenes

## ⚠️ Error Actual Pendiente

### Problema con StateNotifier

**Error**: `Method not found: 'StateNotifierProvider'`

**Ubicación**: `lib/features/cart/presentation/providers/cart_provider.dart`

**Causa**: 
- `StateNotifierProvider` fue deprecado en Riverpod 3.x
- El paquete `flutter_riverpod` ya no exporta `StateNotifierProvider` directamente
- Se necesita importar desde el paquete `riverpod` en lugar de `flutter_riverpod`

**Solución Pendiente**:

```dart
// En cart_provider.dart, cambiar:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Por:
import 'package:riverpod/riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
```

O alternativamente, migrar a la nueva API de Riverpod usando `Notifier` en lugar de `StateNotifier`.

### Archivos Afectados

1. `/lib/features/cart/presentation/providers/cart_provider.dart` - Provider del carrito
2. `/lib/core/router/scaffold_with_nav_bar.dart` - Falta `cartItemCountProvider`

## 🔑 Credenciales de Admin

Para acceder al panel de administración:

- **Email**: `admin@pepe.com`
- **Contraseña**: `Admin123!Admin123!`

**Nota**: El usuario admin debe crearse manualmente desde la app usando la pantalla de registro.

## 📁 Estructura del Proyecto

```
lib/
├── core/
│   ├── router/          # Configuración de rutas
│   ├── theme/           # Colores y estilos
│   └── utils/           # Utilidades (seed_firestore.dart)
├── features/
│   ├── admin/           # Panel de administración
│   ├── auth/            # Autenticación
│   ├── cart/            # Carrito de compras
│   ├── checkout/        # Proceso de pago
│   ├── menu/            # Menú de productos
│   ├── orders/          # Gestión de pedidos
│   └── profile/         # Perfil de usuario
└── main.dart            # Punto de entrada
```

## 🚀 Pasos para Ejecutar

1. **Instalar dependencias**:
   ```bash
   flutter pub get
   ```

2. **Generar código**:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

3. **Ejecutar la app**:
   ```bash
   flutter run -d <device-id>
   ```

## 🔨 Tareas Pendientes

### Alta Prioridad

1. **Arreglar el error de StateNotifier**
   - Actualizar imports en `cart_provider.dart`
   - Agregar `cartItemCountProvider` en `scaffold_with_nav_bar.dart`
   - Verificar que la compilación sea exitosa

2. **Crear cuenta de admin**
   - Usar la pantalla de registro en la app
   - Email: `admin@pepe.com`
   - Contraseña: `Admin123!Admin123!`

### Media Prioridad

3. **Testing del flujo completo**
   - Crear un pedido como usuario normal
   - Verificar que aparece en el panel admin
   - Cambiar estados del pedido
   - Verificar actualización en tiempo real

4. **Optimizaciones**
   - Mejorar manejo de errores
   - Añadir loading states
   - Validaciones de formularios

### Baja Prioridad

5. **Mejoras futuras**
   - Notificaciones push
   - Búsqueda de productos
   - Filtros avanzados
   - Modo oscuro

## 📝 Notas Importantes

- **Firebase**: El proyecto está conectado a `pizzeria-pepe-2026`
- **Autenticación**: Email/Password está habilitado en Firebase Console
- **Firestore**: Las colecciones son `products`, `categories`, y `orders`
- **Admin Access**: Basado en email hardcodeado (`admin@pepe.com`)

## 🐛 Errores Conocidos

1. **StateNotifierProvider no encontrado** (CRÍTICO)
   - Bloquea la compilación
   - Solución: Actualizar imports

2. **cartItemCountProvider no definido** (MEDIO)
   - Afecta el contador del carrito en la navegación
   - Solución: Crear el provider

## 📞 Próximos Pasos

1. Arreglar el error de `StateNotifierProvider`
2. Compilar y ejecutar la app
3. Crear la cuenta de admin desde la app
4. Probar el flujo completo de pedidos
5. Verificar el panel de administración

---

**Última actualización**: 16/01/2026 15:05
**Estado**: En desarrollo - Error de compilación pendiente
**Commit actual**: `8d40d06` - "Add state_notifier package for StateNotifier support"
