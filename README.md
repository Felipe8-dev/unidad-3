# App Flutter - Login y Gestión de Contactos

Aplicación móvil desarrollada en Flutter que incluye sistema de login, persistencia de datos con SharedPreferences y gestión de contactos.

## 📋 Descripción

Esta aplicación permite a los usuarios:
- Iniciar sesión y mantener la sesión activa
- Registrar contactos (nombre, email, teléfono)
- Ver y gestionar la lista de contactos guardados
- Recibir notificaciones y alertas de las acciones realizadas

## 🔧 Requisitos Previos

Antes de ejecutar el proyecto, asegúrate de tener instalado:

- Flutter SDK (versión 3.0 o superior)
- Android Studio o Visual Studio Code
- Un dispositivo Android (físico o emulador)
- Git (para clonar el repositorio)

## 📦 Instalación

1. **Clonar el repositorio:**
   ```bash
   git clone https://github.com/TU_USUARIO/TU_REPOSITORIO.git
   cd TU_REPOSITORIO
   ```

2. **Instalar las dependencias:**
   ```bash
   flutter pub get
   ```

3. **Verificar que Flutter esté correctamente instalado:**
   ```bash
   flutter doctor
   ```

## 🚀 Cómo Ejecutar

### Opción 1: Desde Android Studio

1. Abre el proyecto en Android Studio
2. Conecta un dispositivo Android o inicia un emulador
3. Selecciona el dispositivo en la barra superior
4. Presiona el botón verde ▶ (Run) o presiona `Shift + F10`

### Opción 2: Desde la Terminal

1. Conecta un dispositivo o inicia un emulador
2. Ejecuta el siguiente comando:
   ```bash
   flutter run
   ```

## 📱 Uso de la Aplicación

1. **Pantalla de Login:** Ingresa un usuario y contraseña para acceder
2. **Pantalla Principal:** Completa el formulario para agregar nuevos contactos
3. **Lista de Contactos:** Visualiza, consulta detalles o elimina contactos
4. **Menú:** Accede a las opciones desde el menú en la esquina superior derecha

## 🛠️ Tecnologías Utilizadas

- **Flutter** - Framework de desarrollo
- **Dart** - Lenguaje de programación
- **SharedPreferences** - Almacenamiento local de datos
- **Material Design** - Diseño de interfaz

## 📂 Estructura del Proyecto

```
lib/
├── main.dart                    # Punto de entrada de la aplicación
├── screens/
│   ├── login_screen.dart       # Pantalla de login
│   └── home_screen.dart        # Pantalla principal
└── services/
    └── storage_service.dart    # Servicio de almacenamiento local
```

## 📄 Licencia

Este proyecto es de código abierto y está disponible para uso educativo.

## ✨ Características Principales

- ✅ Sistema de autenticación
- ✅ Persistencia de sesión
- ✅ Formularios con validación
- ✅ Alertas y notificaciones
- ✅ Menú de opciones
- ✅ Gestión de datos local

---

Desarrollado con ❤️ usando Flutter
