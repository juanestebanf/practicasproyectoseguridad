-- Base de Datos - Proyecto SeguridadMX (Sincronizada con Entidades)
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Enumeraciones
CREATE TYPE user_role_enum AS ENUM ('admin', 'operador', 'user');
CREATE TYPE alert_status_enum AS ENUM ('pendiente', 'en_progreso', 'autoridad_asignada', 'esperando_aprobacion', 'finalizada', 'rechazada');

-- Tabla de Usuarios
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR NOT NULL UNIQUE,
    password VARCHAR NOT NULL,
    nombre VARCHAR NOT NULL,
    cedula VARCHAR UNIQUE,
    telefono VARCHAR,
    ciudad VARCHAR,
    rol user_role_enum DEFAULT 'user',
    active BOOLEAN DEFAULT true,
    reset_token VARCHAR,
    reset_token_expires TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de Autoridades
CREATE TABLE authorities (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nombre VARCHAR NOT NULL,
    tipo VARCHAR NOT NULL -- POLICIA, BOMBEROS, AMBULANCIA, SEGURIDAD
);

-- Tabla de Contactos SOS
CREATE TABLE contacts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nombre VARCHAR NOT NULL,
    telefono VARCHAR NOT NULL,
    iniciales VARCHAR NOT NULL,
    seleccionado BOOLEAN DEFAULT true,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de Alertas
CREATE TABLE alerts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    titulo VARCHAR NOT NULL,
    descripcion TEXT NOT NULL,
    prioridad VARCHAR NOT NULL,
    estado alert_status_enum DEFAULT 'pendiente',
    ubicacion VARCHAR NOT NULL,
    lat FLOAT NOT NULL,
    lng FLOAT NOT NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ciudadano_id UUID REFERENCES users(id) ON DELETE CASCADE,
    operador_id UUID REFERENCES users(id) ON DELETE SET NULL,
    autoridad_id UUID REFERENCES authorities(id) ON DELETE SET NULL,
    reporte_file_path VARCHAR,
    admin_feedback TEXT
);

-- Evidencia de Alertas
CREATE TABLE evidence (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    file_path VARCHAR NOT NULL,
    file_type VARCHAR NOT NULL,
    alert_id UUID REFERENCES alerts(id) ON DELETE CASCADE
);

-- Eventos de Alertas (Historial)
CREATE TABLE alert_events (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tipo VARCHAR NOT NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    descripcion TEXT NOT NULL,
    alert_id UUID REFERENCES alerts(id) ON DELETE CASCADE
);

-- =========================================
-- DATOS INICIALES (SEED)
-- =========================================

-- Autoridades Base (Sincronizado con Authorities Service)
INSERT INTO authorities (nombre, tipo) VALUES 
('Policía Nacional', 'POLICIA'),
('Bomberos Loja', 'BOMBEROS'),
('Ambulancia 911', 'AMBULANCIA'),
('Seguridad Ciudadana', 'SEGURIDAD');

-- Usuarios de Prueba
-- Contraseña default: Admin123 (Hash bcrypt)
INSERT INTO users (email, password, nombre, cedula, telefono, ciudad, rol) VALUES 
('admin@gmail.com', crypt('Admin123', gen_salt('bf')), 'Administrador Principal', '1100000001', '0999999991', 'Loja', 'admin'),
('operador@gmail.com', crypt('Admin123', gen_salt('bf')), 'Operador Central', '1100000002', '0999999992', 'Loja', 'operador'),
('usuario@gmail.com', crypt('Admin123', gen_salt('bf')), 'Ciudadano Ejemplo', '1100000003', '0999999993', 'Loja', 'user');
