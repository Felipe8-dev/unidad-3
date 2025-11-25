import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../services/api_service.dart';
import '../models/contact.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefonoController = TextEditingController();

  String _username = '';
  List<Contact> _contactos = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUsername();
    _loadContacts();
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _emailController.dispose();
    _telefonoController.dispose();
    super.dispose();
  }

  // Cargar nombre de usuario (desde SharedPreferences - solo para sesión)
  Future<void> _loadUsername() async {
    final username = await StorageService.getUsername();
    setState(() {
      _username = username ?? 'Usuario';
    });
  }

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

        // Limpiar formulario
        _nombreController.clear();
        _emailController.clear();
        _telefonoController.clear();

        // Mostrar notificación de éxito
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Contacto guardado exitosamente'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        setState(() => _isLoading = false);
        if (mounted) {
          _mostrarError('Error al guardar contacto', e.toString());
        }
      }
    }
  }

  // UPDATE (PUT) - Actualizar contacto (función adicional)
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
      setState(() => _isLoading = false);
      if (mounted) {
        _mostrarError('Error al actualizar contacto', e.toString());
      }
    }
  }

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
        setState(() => _isLoading = false);
        if (mounted) {
          _mostrarError('Error al eliminar contacto', e.toString());
        }
      }
    }
  }

  // Mostrar información completa del contacto
  void _mostrarInfo(Contact contacto) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Información Completa'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nombre: ${contacto.nombre}'),
              const SizedBox(height: 8),
              Text('Email: ${contacto.email}'),
              const SizedBox(height: 8),
              Text('Teléfono: ${contacto.telefono}'),
              if (contacto.id != null) ...[
                const SizedBox(height: 8),
                Text('ID: ${contacto.id}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  // Mostrar diálogo para editar contacto
  Future<void> _mostrarDialogoEditar(Contact contacto) async {
    String nombre = contacto.nombre;
    String email = contacto.email;
    String telefono = contacto.telefono;

    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (BuildContext dialogContext) {
        final nombreController = TextEditingController(text: nombre);
        final emailController = TextEditingController(text: email);
        final telefonoController = TextEditingController(text: telefono);
        final formKey = GlobalKey<FormState>();

        return AlertDialog(
          title: const Text('Editar Contacto'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nombreController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese un nombre';
                      }
                      return null;
                    },
                    onChanged: (value) => nombre = value,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese un email';
                      }
                      if (!value.contains('@')) {
                        return 'Por favor ingrese un email válido';
                      }
                      return null;
                    },
                    onChanged: (value) => email = value,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: telefonoController,
                    decoration: const InputDecoration(
                      labelText: 'Teléfono',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.phone),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese un teléfono';
                      }
                      return null;
                    },
                    onChanged: (value) => telefono = value,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Navigator.of(dialogContext).pop({
                    'nombre': nombre,
                    'email': email,
                    'telefono': telefono,
                  });
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );

    // Si el usuario guardó los cambios
    if (result != null) {
      final contactoActualizado = Contact(
        id: contacto.id,
        nombre: result['nombre']!,
        email: result['email']!,
        telefono: result['telefono']!,
      );
      _actualizarContacto(contactoActualizado);
    }
  }

  // Mostrar error con try-catch
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
                'Verifica que el servidor esté ejecutándose en http://localhost:3000',
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

  // Cerrar sesión (mantiene SharedPreferences solo para autenticación)
  void _logout() async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cerrar Sesión'),
          content: const Text('¿Está seguro que desea cerrar sesión?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      await StorageService.logout();
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido, $_username'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          // Botón de recargar
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _loadContacts,
            tooltip: 'Recargar contactos',
          ),
          // Menú con opciones
          PopupMenuButton<String>(
            onSelected: (String value) {
              if (value == 'perfil') {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Usuario: $_username')),
                );
              } else if (value == 'logout') {
                _logout();
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: 'perfil',
                child: Row(
                  children: [
                    Icon(Icons.person),
                    SizedBox(width: 8),
                    Text('Ver Perfil'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.exit_to_app),
                    SizedBox(width: 8),
                    Text('Cerrar Sesión'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Formulario de registro
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Registrar Nuevo Contacto',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _nombreController,
                            decoration: const InputDecoration(
                              labelText: 'Nombre',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.person),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese un nombre';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.email),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese un email';
                              }
                              if (!value.contains('@')) {
                                return 'Por favor ingrese un email válido';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _telefonoController,
                            decoration: const InputDecoration(
                              labelText: 'Teléfono',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.phone),
                            ),
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese un teléfono';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _guardarDatos,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                              ),
                              child: const Text(
                                'Guardar Datos',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Lista de contactos
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Contactos Guardados',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${_contactos.length} contacto(s)',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                _contactos.isEmpty
                    ? const Card(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(
                            child: Column(
                              children: [
                                Icon(Icons.contact_page,
                                    size: 48, color: Colors.grey),
                                SizedBox(height: 8),
                                Text('No hay contactos guardados'),
                                SizedBox(height: 4),
                                Text(
                                  'Agrega tu primer contacto usando el formulario',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _contactos.length,
                        itemBuilder: (context, index) {
                          final contacto = _contactos[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: const CircleAvatar(
                                backgroundColor: Colors.blue,
                                child: Icon(Icons.person, color: Colors.white),
                              ),
                              title: Text(contacto.nombre),
                              subtitle: Text(contacto.email),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.info),
                                    onPressed: () => _mostrarInfo(contacto),
                                    tooltip: 'Ver información',
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: Colors.orange),
                                    onPressed: _isLoading
                                        ? null
                                        : () => _mostrarDialogoEditar(contacto),
                                    tooltip: 'Editar contacto',
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: _isLoading
                                        ? null
                                        : () => _eliminarContacto(contacto),
                                    tooltip: 'Eliminar contacto',
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ],
            ),
          ),
          // Indicador de carga
          if (_isLoading)
            Container(
              color: Colors.black26,
              child: const Center(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Procesando...'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
