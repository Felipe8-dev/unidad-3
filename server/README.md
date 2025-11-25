# Servidor API REST - Contactos

Este es el servidor backend para la aplicación Flutter de gestión de contactos.

## 🚀 Cómo Ejecutar

### 1. Instalar dependencias (solo la primera vez)
```bash
cd server
npm install
```

### 2. Iniciar el servidor
```bash
node server.js
```

o

```bash
npm start
```

## 📡 Endpoints Disponibles

- **GET** `/api/contactos` - Obtener todos los contactos
- **POST** `/api/contactos` - Crear un nuevo contacto
- **PUT** `/api/contactos/:id` - Actualizar un contacto
- **DELETE** `/api/contactos/:id` - Eliminar un contacto

## 🔧 Tecnologías

- Node.js
- Express.js
- CORS
- Body-Parser

## 📝 Nota

El servidor corre en `http://localhost:3000`
Los datos se almacenan en memoria (se pierden al reiniciar el servidor).

