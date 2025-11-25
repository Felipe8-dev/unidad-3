import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/contact.dart';

class ApiService {
  // URL base del servidor Node.js/Express
  // IP de tu computadora en la red local
  static const String baseUrl = 'http://192.168.0.36:3000/api/contactos';

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
}

