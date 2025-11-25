class Contact {
  final String? id;
  final String nombre;
  final String email;
  final String telefono;

  Contact({
    this.id,
    required this.nombre,
    required this.email,
    required this.telefono,
  });

  // Convertir de JSON a objeto Contact (Deserialización)
  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['_id'] ?? json['id'],
      nombre: json['nombre'],
      email: json['email'],
      telefono: json['telefono'],
    );
  }

  // Convertir de objeto Contact a JSON (Serialización)
  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'email': email,
      'telefono': telefono,
    };
  }
}

