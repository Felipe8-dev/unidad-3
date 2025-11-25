# Migración a API RESTful - Documentación

## 📋 Requisitos Completados - Actividad 4

### ✅ I. Configuración de Red (Networking)

**Cliente HTTP:**
- ✅ Paquete `http` v1.1.0 integrado en `pubspec.yaml`
- ✅ Todas las operaciones de datos usan peticiones HTTP

**URL Base:**
```dart
static const String baseUrl = 'http://localhost:3000/api/contactos';
```

---

### ✅ II. Implementación del CRUD

| Operación | Método HTTP | Implementado en | Descripción |
|-----------|-------------|-----------------|-------------|
| **READ** | GET | `ApiService.getContacts()` | Carga todos los contactos del servidor |
| **CREATE** | POST | `ApiService.createContact()` | Crea un nuevo contacto en el servidor |
| **UPDATE** | PUT | `ApiService.updateContact()` | Actualiza un contacto existente |
| **DELETE** | DELETE | `ApiService.deleteContact()` | Elimina un contacto del servidor |

---

### ✅ III. Gestión de Datos y Errores

**Serialización JSON (Envío):**
```dart
// En Contact.toJson()
body: json.encode(contact.toJson())
```

**Deserialización JSON (Recepción):**
```dart
// En Contact.fromJson()
Contact.fromJson(json.decode(response.body))
```

**Manejo de Errores:**
```dart
try {
  // Operación HTTP
} catch (e) {
  throw Exception('Error de conexión: $e');
}
```
- ✅ Try-catch en todas las operaciones
- ✅ Validación de códigos de respuesta HTTP
- ✅ Alertas al usuario en caso de error

---

## 🗂️ Estructura del Proyecto Actualizada

```
lib/
├── main.dart                    # Punto de entrada (sin cambios)
├── models/
│   └── contact.dart            # ✨ NUEVO: Modelo de datos con serialización
├── screens/
│   ├── login_screen.dart       # Login (sin cambios - usa SharedPreferences)
│   └── home_screen.dart        # ✨ ACTUALIZADO: Usa API para CRUD
└── services/
    ├── storage_service.dart    # Sesión de usuario (sin cambios)
    └── api_service.dart        # ✨ NUEVO: Servicio HTTP para API
```

---

## 🔧 Configuración del Servidor Node.js/Express

### 1. Crear el Servidor API

Crea un proyecto Node.js separado:

```bash
# Crear carpeta del servidor
mkdir server-contactos
cd server-contactos

# Inicializar proyecto Node.js
npm init -y

# Instalar dependencias
npm install express cors body-parser mongoose
```

### 2. Código del Servidor (server.js)

```javascript
const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');

const app = express();
const PORT = 3000;

// Middleware
app.use(cors());
app.use(bodyParser.json());

// Base de datos en memoria (simulación)
let contactos = [];
let nextId = 1;

// READ (GET) - Obtener todos los contactos
app.get('/api/contactos', (req, res) => {
  res.json(contactos);
});

// CREATE (POST) - Crear un nuevo contacto
app.post('/api/contactos', (req, res) => {
  const { nombre, email, telefono } = req.body;
  
  if (!nombre || !email || !telefono) {
    return res.status(400).json({ error: 'Faltan campos requeridos' });
  }

  const nuevoContacto = {
    _id: String(nextId++),
    nombre,
    email,
    telefono
  };

  contactos.push(nuevoContacto);
  res.status(201).json(nuevoContacto);
});

// UPDATE (PUT) - Actualizar un contacto
app.put('/api/contactos/:id', (req, res) => {
  const { id } = req.params;
  const { nombre, email, telefono } = req.body;

  const index = contactos.findIndex(c => c._id === id);
  
  if (index === -1) {
    return res.status(404).json({ error: 'Contacto no encontrado' });
  }

  contactos[index] = {
    _id: id,
    nombre: nombre || contactos[index].nombre,
    email: email || contactos[index].email,
    telefono: telefono || contactos[index].telefono
  };

  res.json(contactos[index]);
});

// DELETE (DELETE) - Eliminar un contacto
app.delete('/api/contactos/:id', (req, res) => {
  const { id } = req.params;
  
  const index = contactos.findIndex(c => c._id === id);
  
  if (index === -1) {
    return res.status(404).json({ error: 'Contacto no encontrado' });
  }

  contactos.splice(index, 1);
  res.status(200).json({ mensaje: 'Contacto eliminado' });
});

// Iniciar servidor
app.listen(PORT, () => {
  console.log(`Servidor corriendo en http://localhost:${PORT}`);
  console.log(`API disponible en http://localhost:${PORT}/api/contactos`);
});
```

### 3. Ejecutar el Servidor

```bash
# En la carpeta server-contactos
node server.js
```

Deberías ver:
```
Servidor corriendo en http://localhost:3000
API disponible en http://localhost:3000/api/contactos
```

---

## 🚀 Cómo Ejecutar el Proyecto Completo

### Paso 1: Instalar Dependencias de Flutter

```bash
# En la carpeta del proyecto Flutter
flutter pub get
```

### Paso 2: Iniciar el Servidor API

```bash
# En la carpeta server-contactos
node server.js
```

### Paso 3: Ejecutar la App Flutter

**Opción A - Dispositivo Android:**
```bash
flutter run
```

**Opción B - Desde Android Studio:**
1. Conecta dispositivo o inicia emulador
2. Click en Run ▶

---

## 📱 Configuración de Red para Dispositivos

### Emulador Android (Android Studio)

✅ `localhost:3000` funciona directamente

### Dispositivo Físico Android

⚠️ Debes usar la IP de tu computadora:

1. **Obtén tu IP local:**
   ```bash
   # Windows
   ipconfig
   
   # Linux/Mac
   ifconfig
   ```

2. **Actualiza la URL en Flutter:**
   ```dart
   // En lib/services/api_service.dart
   static const String baseUrl = 'http://192.168.1.X:3000/api/contactos';
   ```

3. **Asegúrate de estar en la misma red WiFi**

---

## 🧪 Probar la API con Postman/Thunder Client

### GET - Obtener contactos
```http
GET http://localhost:3000/api/contactos
```

### POST - Crear contacto
```http
POST http://localhost:3000/api/contactos
Content-Type: application/json

{
  "nombre": "Juan Pérez",
  "email": "juan@ejemplo.com",
  "telefono": "1234567890"
}
```

### PUT - Actualizar contacto
```http
PUT http://localhost:3000/api/contactos/1
Content-Type: application/json

{
  "nombre": "Juan Actualizado",
  "email": "juan.nuevo@ejemplo.com",
  "telefono": "9876543210"
}
```

### DELETE - Eliminar contacto
```http
DELETE http://localhost:3000/api/contactos/1
```

---

## 🔍 Archivos Modificados/Creados

### ✨ Archivos Nuevos

1. **`lib/models/contact.dart`**
   - Modelo de datos Contact
   - Métodos `toJson()` y `fromJson()`
   - Serialización/deserialización JSON

2. **`lib/services/api_service.dart`**
   - Servicio HTTP completo
   - Métodos CRUD: GET, POST, PUT, DELETE
   - Manejo de errores con try-catch
   - URL base configurable

### 📝 Archivos Modificados

1. **`pubspec.yaml`**
   - ✅ Agregada dependencia `http: ^1.1.0`

2. **`lib/screens/home_screen.dart`**
   - ✅ Reescrito completamente para usar API
   - ✅ Lista de `Contact` en lugar de `Map<String, String>`
   - ✅ Métodos asíncronos con `async/await`
   - ✅ Indicador de carga (`_isLoading`)
   - ✅ Manejo de errores con diálogos informativos
   - ✅ Botón de recargar datos

### 📌 Archivos Sin Cambios

- `lib/main.dart` - Splash screen y navegación
- `lib/screens/login_screen.dart` - Login con SharedPreferences
- `lib/services/storage_service.dart` - Solo para sesión de usuario

---

## 📊 Flujo de Datos Actualizado

### Antes (Almacenamiento Local)
```
Usuario → HomeScreen → SharedPreferences → Dispositivo Local
```

### Ahora (API RESTful)
```
Usuario → HomeScreen → ApiService → HTTP Request → Servidor Node.js → Respuesta JSON → Deserialización → HomeScreen
```

---

## 🎯 Diferencias Clave

| Aspecto | Antes (SharedPreferences) | Ahora (API RESTful) |
|---------|--------------------------|---------------------|
| **Almacenamiento** | Local (dispositivo) | Remoto (servidor) |
| **Persistencia** | Solo en el dispositivo | Centralizada en servidor |
| **Sincronización** | No disponible | Múltiples dispositivos |
| **Tipo de datos** | Map<String, String> | Modelo Contact |
| **Operaciones** | Síncronas | Asíncronas (async/await) |
| **Errores** | No aplica | Try-catch con mensajes |
| **Validación** | Solo en cliente | Cliente + Servidor |

---

## ⚠️ Solución de Problemas

### Error: "No se pudo conectar con el servidor"

**Posibles causas:**
1. El servidor Node.js no está corriendo
2. URL incorrecta en `api_service.dart`
3. Firewall bloqueando el puerto 3000
4. Dispositivo y servidor en redes diferentes

**Soluciones:**
```bash
# 1. Verificar que el servidor esté corriendo
node server.js

# 2. Verificar la URL
# En api_service.dart debe ser: http://localhost:3000/api/contactos

# 3. Desactivar firewall temporalmente (Windows)
# Panel de control > Firewall > Desactivar

# 4. Usar la IP local en lugar de localhost (dispositivos físicos)
```

### Error: "Failed host lookup: 'localhost'"

**Solución para dispositivo físico:**
```dart
// Cambia localhost por tu IP
static const String baseUrl = 'http://192.168.1.X:3000/api/contactos';
```

---

## 📚 Recursos Adicionales

- [Documentación de http package](https://pub.dev/packages/http)
- [Express.js Documentation](https://expressjs.com/)
- [Flutter Networking](https://docs.flutter.dev/development/data-and-backend/networking)
- [RESTful API Design](https://restfulapi.net/)

---

## ✅ Checklist de Verificación

- [ ] Servidor Node.js ejecutándose
- [ ] Dependencia `http` instalada (`flutter pub get`)
- [ ] URL correcta en `api_service.dart`
- [ ] Probar endpoints con Postman
- [ ] App Flutter conectándose correctamente
- [ ] CRUD completo funcionando:
  - [ ] GET (listar contactos)
  - [ ] POST (crear contacto)
  - [ ] PUT (actualizar contacto)
  - [ ] DELETE (eliminar contacto)
- [ ] Manejo de errores mostrando alertas
- [ ] Indicador de carga visible

---

**Tema de Gestión:** Contactos (nombre, email, teléfono)  
**Tecnologías:** Flutter + Node.js/Express  
**Patrón:** Cliente-Servidor con API RESTful  
**Desarrollado por:** FelipeDev

