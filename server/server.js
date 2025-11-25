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
  console.log('GET /api/contactos - Obteniendo todos los contactos');
  res.json(contactos);
});

// CREATE (POST) - Crear un nuevo contacto
app.post('/api/contactos', (req, res) => {
  const { nombre, email, telefono } = req.body;
  
  console.log('POST /api/contactos - Creando contacto:', { nombre, email, telefono });
  
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
  console.log('Contacto creado exitosamente:', nuevoContacto);
  res.status(201).json(nuevoContacto);
});

// UPDATE (PUT) - Actualizar un contacto
app.put('/api/contactos/:id', (req, res) => {
  const { id } = req.params;
  const { nombre, email, telefono } = req.body;

  console.log(`PUT /api/contactos/${id} - Actualizando contacto`);

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

  console.log('Contacto actualizado:', contactos[index]);
  res.json(contactos[index]);
});

// DELETE (DELETE) - Eliminar un contacto
app.delete('/api/contactos/:id', (req, res) => {
  const { id } = req.params;
  
  console.log(`DELETE /api/contactos/${id} - Eliminando contacto`);
  
  const index = contactos.findIndex(c => c._id === id);
  
  if (index === -1) {
    return res.status(404).json({ error: 'Contacto no encontrado' });
  }

  const contactoEliminado = contactos[index];
  contactos.splice(index, 1);
  
  console.log('Contacto eliminado:', contactoEliminado);
  res.status(200).json({ mensaje: 'Contacto eliminado' });
});

// Iniciar servidor
app.listen(PORT, () => {
  console.log('='.repeat(50));
  console.log(`✓ Servidor corriendo en http://localhost:${PORT}`);
  console.log(`✓ API disponible en http://localhost:${PORT}/api/contactos`);
  console.log('='.repeat(50));
  console.log('Esperando peticiones...\n');
});

