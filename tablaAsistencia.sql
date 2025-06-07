-- Crear base de datos
CREATE DATABASE IF NOT EXISTS asistencia_db CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE asistencia_db;

-- Tabla de tipos de usuario del sistema
CREATE TABLE tipo_usuario (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(50) NOT NULL UNIQUE,
  descripcion TEXT,
  tipo_empleado_id INT, 
  fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  activo TINYINT(1) DEFAULT 1,
  FOREIGN KEY (tipo_empleado_id) REFERENCES tipo_empleado(id)
);

-- Tabla de usuarios
CREATE TABLE usuarios (
  id INT AUTO_INCREMENT PRIMARY KEY,
  usuario VARCHAR(50) NOT NULL UNIQUE,
  contrasena VARCHAR(255) NOT NULL,
  tipo_usuario_id INT NOT NULL,
  empleado_id INT UNIQUE, -- Relación con empleados
  fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  activo TINYINT(1) DEFAULT 1,
  FOREIGN KEY (tipo_usuario_id) REFERENCES tipo_usuario(id),
  FOREIGN KEY (empleado_id) REFERENCES empleados(id), 
  INDEX(usuario)
);

-- Tabla de tipos de empleados
CREATE TABLE tipo_empleado (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(50) NOT NULL UNIQUE,
  descripcion TEXT,
  fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  activo TINYINT(1) DEFAULT 1
);

-- Tabla de empleados
CREATE TABLE empleados (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre_completo VARCHAR(100) NOT NULL,
  correo VARCHAR(100),
  telefono VARCHAR(20),
  dpi VARCHAR(20) UNIQUE,
  direccion TEXT,
  tipo_empleado_id INT,
  fecha_contratacion DATE,
  fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  activo TINYINT(1) DEFAULT 1,
  FOREIGN KEY (tipo_empleado_id) REFERENCES tipo_empleado(id),
  INDEX(dpi)
);

-- Tabla de horarios
CREATE TABLE horarios (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  hora_inicio TIME NOT NULL,
  hora_fin TIME NOT NULL,
  tolerancia_minutos INT DEFAULT 10,
  descripcion TEXT,
  fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  activo TINYINT(1) DEFAULT 1
);

-- Tabla de relación entre empleado, horario y día de la semana
CREATE TABLE empleado_horario (
  id INT AUTO_INCREMENT PRIMARY KEY,
  empleado_id INT NOT NULL,
  horario_id INT NOT NULL,
  dia_semana ENUM('Lunes','Martes','Miércoles','Jueves','Viernes','Sábado','Domingo') NOT NULL,
  fecha_inicio DATE NOT NULL,
  fecha_fin DATE,
  fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  activo TINYINT(1) DEFAULT 1,
  FOREIGN KEY (empleado_id) REFERENCES empleados(id),
  FOREIGN KEY (horario_id) REFERENCES horarios(id),
  INDEX(empleado_id),
  INDEX(horario_id)
);

-- Tabla de asistencia
CREATE TABLE asistencia (
  id INT AUTO_INCREMENT PRIMARY KEY,
  empleado_id INT NOT NULL,
  fecha DATE NOT NULL,
  hora_entrada TIME,
  hora_salida TIME,
  estado VARCHAR(20) DEFAULT 'Asistencia',
  observaciones VARCHAR(255),
  fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  activo TINYINT(1) DEFAULT 1,
  FOREIGN KEY (empleado_id) REFERENCES empleados(id),
  INDEX(fecha)
);

-- Tabla de justificaciones asociadas a una asistencia
CREATE TABLE justificaciones (
  id INT AUTO_INCREMENT PRIMARY KEY,
  asistencia_id INT NOT NULL,
  motivo TEXT,
  aprobado_por INT,
  fecha_justificacion DATE,
  archivo_url VARCHAR(255),
  fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  activo TINYINT(1) DEFAULT 1,
  FOREIGN KEY (asistencia_id) REFERENCES asistencia(id),
  FOREIGN KEY (aprobado_por) REFERENCES usuarios(id)
);

-- Tabla de visitas externas
CREATE TABLE visitas (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre_completo VARCHAR(100) NOT NULL,
  dpi VARCHAR(20),
  motivo TEXT,
  persona_a_visitar VARCHAR(100),
  fecha DATE NOT NULL,
  hora_entrada TIME NOT NULL,
  hora_salida TIME,
  observaciones VARCHAR(255),
  registrado_por INT,
  fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  activo TINYINT(1) DEFAULT 1,
  FOREIGN KEY (registrado_por) REFERENCES usuarios(id)
);

