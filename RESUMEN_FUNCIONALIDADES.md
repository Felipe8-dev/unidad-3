# App Flutter - Resumen de Funcionalidades y Arquitectura

---

## 📱 Funcionalidades Principales

### 1. Sistema de Login
- Permite al usuario ingresar con usuario y contraseña
- Valida que los campos no estén vacíos
- Guarda la sesión del usuario en el dispositivo (SharedPreferences)
- Mantiene la sesión activa incluso después de cerrar la app
- Muestra notificaciones de éxito al iniciar sesión

### 2. Gestión de Contactos
- **Agregar:** Registro de contactos con nombre, email y teléfono
- **Visualizar:** Lista de todos los contactos guardados
- **Ver detalles:** Consultar información completa de cada contacto
- **Eliminar:** Borrar contactos con confirmación previa

### 3. Menú de Opciones
- Ver perfil del usuario actual
- Cerrar sesión con confirmación
- Regreso automático al login al cerrar sesión

### 4. Notificaciones y Alertas
- **SnackBars:** Notificaciones en la parte inferior (éxito, eliminación, información)
- **Diálogos:** Alertas modales para confirmaciones e información detallada

### 5. Persistencia de Datos
- Los datos del usuario se guardan localmente usando SharedPreferences
- La sesión permanece activa entre reinicios de la app
- No requiere conexión a internet

---

## 📂 Estructura de Archivos y Funciones

```
lib/
├── main.dart                    # Archivo principal
├── screens/                     # Pantallas de la aplicación
│   ├── login_screen.dart       # Pantalla de inicio de sesión
│   └── home_screen.dart        # Pantalla principal
└── services/                    # Servicios y lógica de negocio
    └── storage_service.dart    # Manejo de datos locales
```

---

## 🔍 Descripción Detallada de Cada Archivo

### 📄 `lib/main.dart`

**Propósito:** Punto de entrada de la aplicación

**Funciones:**
- Inicializa la aplicación con `runApp()`
- Configura el tema visual (colores, fuentes)
- Define la pantalla de Splash inicial

**Componentes:**

#### `MyApp` (Widget Principal)
```dart
- Configura MaterialApp
- Define el tema con color azul
- Establece el título de la app
- Define SplashScreen como pantalla inicial
```

#### `SplashScreen` (Pantalla de Carga)
```dart
- Se muestra durante 1 segundo al abrir la app
- Verifica si hay una sesión activa
- Si HAY sesión → Navega a HomeScreen
- Si NO hay sesión → Navega a LoginScreen
- Muestra logo de Flutter y un indicador de carga
```

**Relación con otros archivos:**
- Importa `login_screen.dart` y `home_screen.dart`
- Usa `storage_service.dart` para verificar sesión
- Es el primer archivo que se ejecuta

---

### 📄 `lib/screens/login_screen.dart`

**Propósito:** Pantalla de inicio de sesión

**Funciones:**
- Muestra formulario de login
- Valida credenciales del usuario
- Guarda el usuario en el dispositivo
- Redirige al Home después del login

**Componentes:**

#### `LoginScreen` (StatefulWidget)
```dart
Widgets principales:
- TextFormField para usuario
- TextFormField para contraseña (oculta texto)
- ElevatedButton para "Iniciar Sesión"
- Validadores de campos vacíos
```

**Flujo de funcionamiento:**
1. Usuario ingresa nombre de usuario y contraseña
2. Presiona el botón "Iniciar Sesión"
3. Se valida que los campos no estén vacíos
4. Si es válido:
   - Llama a `StorageService.saveUser(username)`
   - Muestra SnackBar verde de éxito
   - Navega a `HomeScreen`
5. Si es inválido:
   - Muestra mensajes de error en rojo

**Relación con otros archivos:**
- Importa `storage_service.dart` para guardar datos
- Importa `home_screen.dart` para navegar después del login
- Es llamado por `main.dart` cuando no hay sesión

---

### 📄 `lib/screens/home_screen.dart`

**Propósito:** Pantalla principal de la aplicación

**Funciones:**
- Muestra el nombre del usuario logueado
- Permite registrar nuevos contactos
- Muestra lista de contactos guardados
- Gestiona el menú de opciones
- Maneja todas las interacciones del usuario

**Componentes:**

#### Variables de Estado
```dart
- _usernameController: Control del campo nombre
- _emailController: Control del campo email
- _telefonoController: Control del campo teléfono
- _username: Almacena nombre del usuario actual
- _datosGuardados: Lista de contactos (Array)
```

#### Métodos Principales

**`_loadUsername()`**
```dart
Propósito: Cargar el nombre del usuario al iniciar
- Lee datos de SharedPreferences
- Actualiza la variable _username
- Muestra el nombre en el AppBar
```

**`_loadSavedData()`**
```dart
Propósito: Cargar contactos guardados
- Lee los últimos datos guardados
- Los agrega a la lista _datosGuardados
- Actualiza la interfaz
```

**`_guardarDatos()`**
```dart
Propósito: Guardar nuevo contacto
Proceso:
1. Valida el formulario
2. Guarda datos en SharedPreferences
3. Agrega contacto a la lista
4. Limpia los campos del formulario
5. Muestra SnackBar verde de confirmación
```

**`_logout()`**
```dart
Propósito: Cerrar sesión
Proceso:
1. Muestra diálogo de confirmación
2. Si el usuario confirma:
   - Llama a StorageService.logout()
   - Borra datos de sesión
   - Navega de regreso al LoginScreen
```

**`_mostrarInfo()`**
```dart
Propósito: Mostrar detalles de un contacto
- Abre un diálogo modal
- Muestra nombre, email y teléfono completos
- Botón para cerrar
```

**`_eliminarRegistro()`**
```dart
Propósito: Eliminar un contacto
Proceso:
1. Muestra diálogo de confirmación
2. Si confirma:
   - Elimina el contacto de la lista
   - Muestra SnackBar naranja
   - Actualiza la interfaz
```

#### Estructura Visual

**AppBar (Barra Superior)**
```dart
- Título: "Bienvenido, [nombre_usuario]"
- PopupMenuButton con opciones:
  * Ver Perfil → Muestra SnackBar con usuario
  * Cerrar Sesión → Llama a _logout()
```

**Body (Contenido Principal)**
```dart
1. Card con Formulario:
   - Campo Nombre (obligatorio)
   - Campo Email (obligatorio, valida @)
   - Campo Teléfono (obligatorio)
   - Botón "Guardar Datos"

2. Título "Contactos Guardados"

3. ListView con tarjetas de contactos:
   - Cada contacto tiene:
     * Ícono circular azul
     * Nombre y email
     * Botón info (ℹ)
     * Botón eliminar (🗑)
```

**Relación con otros archivos:**
- Importa `storage_service.dart` para leer/guardar datos
- Importa `login_screen.dart` para regresar al cerrar sesión
- Es llamado por `main.dart` cuando hay sesión activa

---

### 📄 `lib/services/storage_service.dart`

**Propósito:** Servicio centralizado para manejo de datos locales

**Funciones:**
- Encapsula toda la lógica de SharedPreferences
- Proporciona métodos para guardar y leer datos
- Gestiona la sesión del usuario
- Abstrae la complejidad del almacenamiento

**Estructura:**

```dart
class StorageService {
  // Constantes para las keys
  static const String _keyUsername = 'username';
  static const String _keyIsLoggedIn = 'isLoggedIn';
  
  // Métodos estáticos (no requieren instancia)
}
```

#### Métodos Disponibles

**`saveUser(String username)`**
```dart
Propósito: Guardar usuario al hacer login
Proceso:
- Obtiene instancia de SharedPreferences
- Guarda el nombre de usuario
- Marca isLoggedIn como true
- Es asíncrono (Future)
```

**`getUsername()`**
```dart
Propósito: Obtener el nombre del usuario guardado
Retorna: String? (puede ser null si no hay usuario)
Uso: Mostrar nombre en el Home
```

**`isLoggedIn()`**
```dart
Propósito: Verificar si hay sesión activa
Retorna: bool (true/false)
Uso: Decidir si mostrar Login o Home en el Splash
```

**`logout()`**
```dart
Propósito: Cerrar sesión del usuario
Proceso:
- Marca isLoggedIn como false
- Elimina el nombre de usuario
- Limpia los datos de sesión
```

**`saveFormData(String key, String value)`**
```dart
Propósito: Guardar datos del formulario
Parámetros:
- key: Identificador del dato (ej: "nombre", "email")
- value: Valor a guardar
Uso: Guardar contactos
```

**`getFormData(String key)`**
```dart
Propósito: Obtener datos del formulario guardados
Parámetros:
- key: Identificador del dato
Retorna: String? (valor guardado o null)
Uso: Recuperar último contacto guardado
```

**Relación con otros archivos:**
- Es usado por `main.dart` para verificar sesión
- Es usado por `login_screen.dart` para guardar usuario
- Es usado por `home_screen.dart` para todos los datos
- No importa ningún otro archivo de la app (solo SharedPreferences)

---

## 🔄 Flujo de la Aplicación

### Flujo 1: Primera Vez que se Abre la App

```
1. main.dart ejecuta runApp()
   ↓
2. Se muestra SplashScreen
   ↓
3. SplashScreen llama a StorageService.isLoggedIn()
   ↓
4. StorageService retorna false (no hay sesión)
   ↓
5. SplashScreen navega a LoginScreen
   ↓
6. Usuario ingresa credenciales
   ↓
7. LoginScreen llama a StorageService.saveUser()
   ↓
8. StorageService guarda datos
   ↓
9. LoginScreen navega a HomeScreen
   ↓
10. HomeScreen llama a StorageService.getUsername()
    ↓
11. Muestra nombre en el AppBar
```

---

### Flujo 2: Abrir la App con Sesión Activa

```
1. main.dart ejecuta runApp()
   ↓
2. Se muestra SplashScreen
   ↓
3. SplashScreen llama a StorageService.isLoggedIn()
   ↓
4. StorageService retorna true (hay sesión)
   ↓
5. SplashScreen navega directamente a HomeScreen
   ↓
6. HomeScreen carga datos del usuario
   ↓
7. Usuario ve su sesión activa
```

---

### Flujo 3: Agregar un Contacto

```
1. Usuario completa formulario en HomeScreen
   ↓
2. Usuario presiona "Guardar Datos"
   ↓
3. HomeScreen valida los campos
   ↓
4. HomeScreen llama a StorageService.saveFormData() (3 veces)
   - saveFormData("nombre", valor)
   - saveFormData("email", valor)
   - saveFormData("telefono", valor)
   ↓
5. StorageService guarda cada dato
   ↓
6. HomeScreen agrega contacto a _datosGuardados[]
   ↓
7. HomeScreen actualiza la interfaz (setState)
   ↓
8. Se muestra el nuevo contacto en la lista
```

---

### Flujo 4: Cerrar Sesión

```
1. Usuario presiona menú (⋮) en HomeScreen
   ↓
2. Usuario selecciona "Cerrar Sesión"
   ↓
3. HomeScreen muestra diálogo de confirmación
   ↓
4. Usuario presiona "Aceptar"
   ↓
5. HomeScreen llama a StorageService.logout()
   ↓
6. StorageService borra datos de sesión
   ↓
7. HomeScreen navega a LoginScreen
   ↓
8. Usuario debe volver a iniciar sesión
```

---

## 🔗 Mapa de Relaciones Entre Archivos

```
main.dart
│
├─→ Importa login_screen.dart
├─→ Importa home_screen.dart
└─→ Usa storage_service.dart (verificar sesión)

login_screen.dart
│
├─→ Importa home_screen.dart (navegar después del login)
└─→ Usa storage_service.dart (guardar usuario)

home_screen.dart
│
├─→ Importa login_screen.dart (regresar al cerrar sesión)
└─→ Usa storage_service.dart (todos los datos)

storage_service.dart
│
└─→ Solo importa shared_preferences (no depende de otros archivos de la app)
```

---

## 💾 Datos que se Guardan en SharedPreferences

| Key (Clave) | Tipo | Descripción | Usado en |
|-------------|------|-------------|----------|
| `username` | String | Nombre del usuario logueado | Login, Home |
| `isLoggedIn` | bool | Indica si hay sesión activa | Splash, Login, Home |
| `nombre` | String | Último nombre guardado | Home |
| `email` | String | Último email guardado | Home |
| `telefono` | String | Último teléfono guardado | Home |

---

## 🎨 Componentes de UI Utilizados

### Material Design Widgets

| Widget | Uso en la App |
|--------|---------------|
| `Scaffold` | Estructura base de todas las pantallas |
| `AppBar` | Barra superior con título y menú |
| `Card` | Contenedor del formulario y contactos |
| `TextFormField` | Campos de texto con validación |
| `ElevatedButton` | Botones principales (Login, Guardar) |
| `IconButton` | Botones de acción (info, eliminar) |
| `PopupMenuButton` | Menú desplegable (⋮) |
| `AlertDialog` | Diálogos de confirmación e información |
| `SnackBar` | Notificaciones temporales |
| `ListView.builder` | Lista dinámica de contactos |
| `CircleAvatar` | Ícono circular en contactos |

---

## 📊 Resumen de Responsabilidades

### main.dart
✅ Inicializar app  
✅ Configurar tema  
✅ Verificar sesión  
✅ Redirigir a pantalla correcta  

### login_screen.dart
✅ Mostrar formulario de login  
✅ Validar credenciales  
✅ Guardar sesión  
✅ Navegar al Home  

### home_screen.dart
✅ Mostrar datos del usuario  
✅ Gestionar formulario de contactos  
✅ Mostrar lista de contactos  
✅ Manejar menú y opciones  
✅ Mostrar notificaciones y diálogos  

### storage_service.dart
✅ Guardar datos localmente  
✅ Recuperar datos guardados  
✅ Gestionar sesión del usuario  
✅ Abstraer lógica de SharedPreferences  

---

## 🎯 Conclusión

Esta aplicación sigue una arquitectura simple pero efectiva:

**Separación de Capas:**
- **UI (Screens):** Maneja la presentación y la interacción con el usuario
- **Lógica (Services):** Gestiona el almacenamiento y persistencia de datos
- **Configuración (Main):** Inicializa y coordina la aplicación

**Ventajas de esta arquitectura:**
- ✅ Código organizado y fácil de mantener
- ✅ Responsabilidades claras para cada archivo
- ✅ Reutilización del servicio de almacenamiento
- ✅ Fácil de testear y modificar
- ✅ Escalable para agregar nuevas funcionalidades

---

**Desarrollado por:** FelipeDev  
**Framework:** Flutter  
**Propósito:** Proyecto educativo




