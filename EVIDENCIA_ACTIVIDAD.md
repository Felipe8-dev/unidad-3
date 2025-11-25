# Evidencia de Cumplimiento - Actividad 4

## 📋 Requisitos de la Aplicación Cliente (Flutter)

---

## ✅ I. CONFIGURACIÓN DE RED (NETWORKING)

### 1. Inclusión del Cliente HTTP

**Evidencia en código:**

**Archivo:** `pubspec.yaml` (líneas 37-38)
```yaml
dependencies:
  cupertino_icons: ^1.0.8
  shared_preferences: ^2.2.2
  http: ^1.1.0  ← Cliente HTTP instalado
```

**Captura sugerida:**
- Screenshot del archivo `pubspec.yaml` mostrando la dependencia `http: ^1.1.0`

---

### 2. Definición de URL Base

**Evidencia en código:**

**Archivo:** `lib/services/api_service.dart` (líneas 6-8)
```dart
class ApiService {
  // URL base del servidor Node.js/Express
  // IP de tu computadora en la red local
  static const String baseUrl = 'http://192.168.0.36:3000/api/contactos';
```

**Captura sugerida:**
- Screenshot del archivo `api_service.dart` mostrando la URL base configurada

---

## ✅ II. IMPLEMENTACIÓN DEL CRUD

### READ (GET) - Lectura de Datos

**Evidencia en código:**

**Archivo:** `lib/services/api_service.dart` (líneas 11-24)
```dart
// READ (GET) - Obtener todos los contactos
static Future<List<Contact>> getContacts() async {
  try {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      // Deserialización: Convertir JSON a objetos Dart
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => Contact.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar contactos: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error de conexión: $e');
  }
}
```

**Evidencia en app:**

**Archivo:** `lib/screens/home_screen.dart` (líneas 49-63)
```dart
// READ (GET) - Cargar contactos desde la API
Future<void> _loadContacts() async {
  setState(() => _isLoading = true);

  try {
    final contacts = await ApiService.getContacts();
    setState(() {
      _contactos = contacts;
      _isLoading = false;
    });
  } catch (e) {
    setState(() => _isLoading = false);
    if (mounted) {
      _mostrarError('Error al cargar contactos', e.toString());
    }
  }
}
```

**Capturas sugeridas:**
1. Screenshot de la app mostrando la lista de contactos cargados
2. Screenshot de la terminal del servidor mostrando: `GET /api/contactos - Obteniendo todos los contactos`
3. Video mostrando el botón de recargar (🔄) funcionando

---

### CREATE (POST) - Creación de Datos

**Evidencia en código:**

**Archivo:** `lib/services/api_service.dart` (líneas 26-47)
```dart
// CREATE (POST) - Crear un nuevo contacto
static Future<Contact> createContact(Contact contact) async {
  try {
    // Serialización: Convertir objeto Dart a JSON
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(contact.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Deserialización: Convertir la respuesta JSON a objeto Dart
      return Contact.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al crear contacto: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error de conexión: $e');
  }
}
```

**Evidencia en app:**

**Archivo:** `lib/screens/home_screen.dart` (líneas 67-107)
```dart
// CREATE (POST) - Guardar nuevo contacto en la API
Future<void> _guardarDatos() async {
  if (_formKey.currentState!.validate()) {
    setState(() => _isLoading = true);

    try {
      // Crear objeto Contact
      final nuevoContacto = Contact(
        nombre: _nombreController.text,
        email: _emailController.text,
        telefono: _telefonoController.text,
      );

      // Enviar a la API
      final contactoCreado = await ApiService.createContact(nuevoContacto);

      // Agregar a la lista local
      setState(() {
        _contactos.add(contactoCreado);
        _isLoading = false;
      });

      // Limpiar formulario y mostrar notificación
      _nombreController.clear();
      _emailController.clear();
      _telefonoController.clear();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Contacto guardado exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      // Manejo de errores...
    }
  }
}
```

**Capturas sugeridas:**
1. Screenshot del formulario completo con datos
2. Screenshot del SnackBar verde "Contacto guardado exitosamente"
3. Screenshot del contacto apareciendo en la lista
4. Screenshot de la terminal del servidor mostrando: `POST /api/contactos - Creando contacto: { nombre: '...', email: '...', telefono: '...' }`
5. Video del proceso completo de agregar un contacto

---

### UPDATE (PUT) - Actualización de Datos

**Evidencia en código:**

**Archivo:** `lib/services/api_service.dart` (líneas 49-70)
```dart
// UPDATE (PUT) - Actualizar un contacto existente
static Future<Contact> updateContact(String id, Contact contact) async {
  try {
    // Serialización: Convertir objeto Dart a JSON
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(contact.toJson()),
    );

    if (response.statusCode == 200) {
      // Deserialización: Convertir la respuesta JSON a objeto Dart
      return Contact.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al actualizar contacto: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error de conexión: $e');
  }
}
```

**Evidencia en app:**

**Archivo:** `lib/screens/home_screen.dart` (líneas 109-144)
```dart
// UPDATE (PUT) - Actualizar contacto
Future<void> _actualizarContacto(Contact contacto) async {
  if (contacto.id == null) return;

  setState(() => _isLoading = true);

  try {
    final contactoActualizado = await ApiService.updateContact(
      contacto.id!,
      contacto,
    );

    // Actualizar en la lista local
    setState(() {
      final index = _contactos.indexWhere((c) => c.id == contacto.id);
      if (index != -1) {
        _contactos[index] = contactoActualizado;
      }
      _isLoading = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Contacto actualizado exitosamente'),
          backgroundColor: Colors.green,
        ),
      );
    }
  } catch (e) {
    // Manejo de errores...
  }
}
```

**Capturas sugeridas:**
1. Screenshot mostrando la función `updateContact` en el código
2. Screenshot de la terminal mostrando: `PUT /api/contactos/1 - Actualizando contacto`
3. Nota: La funcionalidad está implementada pero no tiene UI para editar (se puede agregar después)

---

### DELETE (DELETE) - Eliminación de Datos

**Evidencia en código:**

**Archivo:** `lib/services/api_service.dart` (líneas 72-83)
```dart
// DELETE (DELETE) - Eliminar un contacto
static Future<void> deleteContact(String id) async {
  try {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Error al eliminar contacto: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error de conexión: $e');
  }
}
```

**Evidencia en app:**

**Archivo:** `lib/screens/home_screen.dart` (líneas 146-193)
```dart
// DELETE (DELETE) - Eliminar contacto de la API
Future<void> _eliminarContacto(Contact contacto) async {
  if (contacto.id == null) return;

  // Mostrar diálogo de confirmación
  bool? confirm = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Eliminar Contacto'),
        content: Text('¿Está seguro que desea eliminar a ${contacto.nombre}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      );
    },
  );

  if (confirm == true) {
    setState(() => _isLoading = true);

    try {
      // Eliminar de la API
      await ApiService.deleteContact(contacto.id!);

      // Eliminar de la lista local
      setState(() {
        _contactos.removeWhere((c) => c.id == contacto.id);
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Contacto eliminado'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      // Manejo de errores...
    }
  }
}
```

**Capturas sugeridas:**
1. Screenshot del diálogo de confirmación "¿Está seguro que desea eliminar...?"
2. Screenshot del SnackBar naranja "Contacto eliminado"
3. Screenshot de la terminal mostrando: `DELETE /api/contactos/1 - Eliminando contacto`
4. Video del proceso completo de eliminar un contacto

---

## ✅ III. GESTIÓN DE DATOS Y ERRORES

### 1. Serialización JSON (Envío)

**Evidencia en código:**

**Archivo:** `lib/models/contact.dart` (líneas 23-29)
```dart
// Convertir de objeto Contact a JSON (Serialización)
Map<String, dynamic> toJson() {
  return {
    'nombre': nombre,
    'email': email,
    'telefono': telefono,
  };
}
```

**Uso en API Service:**
```dart
body: json.encode(contact.toJson()),  // ← Serialización antes de enviar
```

**Capturas sugeridas:**
1. Screenshot del método `toJson()` en `contact.dart`
2. Screenshot del uso de `json.encode()` en `api_service.dart`

---

### 2. Deserialización JSON (Recepción)

**Evidencia en código:**

**Archivo:** `lib/models/contact.dart` (líneas 13-21)
```dart
// Convertir de JSON a objeto Contact (Deserialización)
factory Contact.fromJson(Map<String, dynamic> json) {
  return Contact(
    id: json['_id'] ?? json['id'],
    nombre: json['nombre'],
    email: json['email'],
    telefono: json['telefono'],
  );
}
```

**Uso en API Service:**
```dart
final List<dynamic> jsonData = json.decode(response.body);  // ← Deserialización
return jsonData.map((json) => Contact.fromJson(json)).toList();
```

**Capturas sugeridas:**
1. Screenshot del método `fromJson()` en `contact.dart`
2. Screenshot del uso de `json.decode()` en `api_service.dart`

---

### 3. Manejo de Errores (Try-Catch)

**Evidencia en código:**

**Archivo:** `lib/services/api_service.dart` - Ejemplo en GET:
```dart
static Future<List<Contact>> getContacts() async {
  try {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => Contact.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar contactos: ${response.statusCode}');
    }
  } catch (e) {  // ← Try-Catch para capturar errores
    throw Exception('Error de conexión: $e');
  }
}
```

**Manejo en UI:**

**Archivo:** `lib/screens/home_screen.dart` (líneas 54-61)
```dart
try {
  final contacts = await ApiService.getContacts();
  setState(() {
    _contactos = contacts;
    _isLoading = false;
  });
} catch (e) {
  setState(() => _isLoading = false);
  if (mounted) {
    _mostrarError('Error al cargar contactos', e.toString());
  }
}
```

**Diálogo de Error:**

**Archivo:** `lib/screens/home_screen.dart` (líneas 246-286)
```dart
void _mostrarError(String titulo, String mensaje) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.error, color: Colors.red),
            const SizedBox(width: 8),
            Text(titulo),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('No se pudo conectar con el servidor.'),
            const SizedBox(height: 8),
            Text(
              'Detalles: $mensaje',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            const Text(
              'Verifica que el servidor esté ejecutándose...',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _loadContacts();
            },
            child: const Text('Reintentar'),
          ),
        ],
      );
    },
  );
}
```

**Capturas sugeridas:**
1. Screenshot del código con try-catch en `api_service.dart`
2. Screenshot del diálogo de error en la app (detén el servidor y recarga)
3. Screenshot mostrando el botón "Reintentar"
4. Video mostrando el manejo de error cuando el servidor está apagado

---

## 📸 LISTA DE CAPTURAS REQUERIDAS

### Capturas de Código

1. ✅ `pubspec.yaml` - Dependencia `http: ^1.1.0`
2. ✅ `api_service.dart` - URL base configurada
3. ✅ `api_service.dart` - Método GET completo
4. ✅ `api_service.dart` - Método POST completo
5. ✅ `api_service.dart` - Método PUT completo
6. ✅ `api_service.dart` - Método DELETE completo
7. ✅ `contact.dart` - Método `toJson()` (serialización)
8. ✅ `contact.dart` - Método `fromJson()` (deserialización)
9. ✅ `home_screen.dart` - Manejo de errores con try-catch
10. ✅ `home_screen.dart` - Función `_mostrarError()`

### Capturas de la App Funcionando

11. ✅ Pantalla de Login
12. ✅ Home vacío (0 contactos)
13. ✅ Formulario con datos ingresados
14. ✅ SnackBar verde "Contacto guardado exitosamente"
15. ✅ Lista con contactos (mínimo 3 contactos)
16. ✅ Botón de recargar (🔄) en acción
17. ✅ Diálogo "Información Completa" de un contacto
18. ✅ Diálogo de confirmación "¿Está seguro que desea eliminar...?"
19. ✅ SnackBar naranja "Contacto eliminado"
20. ✅ Diálogo de error (servidor apagado)
21. ✅ Indicador de carga "Procesando..."

### Capturas del Servidor (Terminal)

22. ✅ Servidor iniciado: "✓ Servidor corriendo en http://localhost:3000"
23. ✅ Log GET: "GET /api/contactos - Obteniendo todos los contactos"
24. ✅ Log POST: "POST /api/contactos - Creando contacto: {...}"
25. ✅ Log POST: "Contacto creado exitosamente: {...}"
26. ✅ Log PUT: "PUT /api/contactos/1 - Actualizando contacto"
27. ✅ Log DELETE: "DELETE /api/contactos/1 - Eliminando contacto"
28. ✅ Log DELETE: "Contacto eliminado: {...}"

### Capturas del Código del Servidor

29. ✅ `server/server.js` - Endpoint GET completo
30. ✅ `server/server.js` - Endpoint POST completo
31. ✅ `server/server.js` - Endpoint PUT completo
32. ✅ `server/server.js` - Endpoint DELETE completo
33. ✅ `server/package.json` - Dependencias (express, cors, body-parser)

### Videos Sugeridos (Opcionales pero muy útiles)

34. ✅ Video (30 seg): Proceso completo de agregar un contacto
35. ✅ Video (20 seg): Proceso completo de eliminar un contacto
36. ✅ Video (15 seg): Recargar contactos con el botón 🔄
37. ✅ Video (20 seg): Manejo de error (servidor apagado)

---

## 📝 DOCUMENTO DE EVIDENCIA SUGERIDO

### Estructura del Documento PDF

**Portada**
- Título: "Actividad 4 - API RESTful con Flutter y Node.js"
- Nombre del estudiante
- Fecha
- Tema: Gestión de Contactos

**1. Introducción**
- Descripción del proyecto
- Tecnologías utilizadas

**2. Requisito I: Configuración de Red**
- 2.1. Cliente HTTP (captura del pubspec.yaml)
- 2.2. URL Base (captura del api_service.dart)

**3. Requisito II: Implementación CRUD**
- 3.1. READ - GET (código + capturas)
- 3.2. CREATE - POST (código + capturas)
- 3.3. UPDATE - PUT (código + capturas)
- 3.4. DELETE - DELETE (código + capturas)

**4. Requisito III: Gestión de Datos**
- 4.1. Serialización JSON (código del toJson)
- 4.2. Deserialización JSON (código del fromJson)
- 4.3. Manejo de Errores (try-catch + diálogos)

**5. Servidor Node.js**
- 5.1. Código del servidor
- 5.2. Endpoints implementados
- 5.3. Logs del servidor funcionando

**6. Demostración Funcional**
- 6.1. Capturas de la app funcionando
- 6.2. Flujo completo de uso
- 6.3. Manejo de errores

**7. Conclusiones**
- Requisitos cumplidos
- Aprendizajes
- Dificultades y soluciones

---

## 🎯 CHECKLIST FINAL

### Código
- [ ] Cliente HTTP instalado (`http: ^1.1.0`)
- [ ] URL base configurada
- [ ] Método GET implementado
- [ ] Método POST implementado
- [ ] Método PUT implementado
- [ ] Método DELETE implementado
- [ ] Serialización JSON (toJson)
- [ ] Deserialización JSON (fromJson)
- [ ] Try-catch en todas las operaciones
- [ ] Manejo de errores con alertas

### Funcionalidad
- [ ] App se conecta al servidor
- [ ] Listar contactos (GET)
- [ ] Crear contactos (POST)
- [ ] Eliminar contactos (DELETE)
- [ ] Actualización implementada (PUT)
- [ ] Notificaciones de éxito
- [ ] Diálogos de confirmación
- [ ] Manejo de errores de conexión
- [ ] Indicador de carga

### Evidencia
- [ ] Capturas de código (mínimo 10)
- [ ] Capturas de la app (mínimo 10)
- [ ] Capturas del servidor (mínimo 5)
- [ ] Video demostrativo (opcional)
- [ ] Documento PDF con evidencia completa

---

## 📌 NOTAS IMPORTANTES

1. **Para capturar el CRUD completo:**
   - Inicia el servidor
   - Abre la app
   - Agrega 3-4 contactos (POST)
   - Recarga la lista (GET)
   - Elimina un contacto (DELETE)
   - Captura cada paso y los logs del servidor

2. **Para evidenciar el manejo de errores:**
   - Detén el servidor (`Ctrl + C`)
   - Intenta agregar un contacto
   - Captura el diálogo de error
   - Reinicia el servidor
   - Presiona "Reintentar"

3. **Para los logs del servidor:**
   - Mantén la terminal del servidor visible
   - Captura cada operación CRUD en la terminal
   - Los logs muestran claramente: GET, POST, PUT, DELETE

4. **Estructura del repositorio GitHub:**
   ```
   unidad-3/
   ├── lib/              ← Código Flutter
   ├── server/           ← Código Node.js
   ├── README.md         ← Instrucciones
   └── README_API.md     ← Documentación API
   ```

---

**Tema de Gestión:** Contactos (nombre, email, teléfono)  
**Desarrollado por:** FelipeDev  
**Repositorio:** https://github.com/Felipe8-dev/unidad-3

