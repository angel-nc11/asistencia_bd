-- Crear base de datos
CREATE DATABASE IF NOT EXISTS asistencia_db CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE asistencia_db;

DROP TABLE IF EXISTS tipo_usuario;
-- Tabla de tipos de usuario del sistema
CREATE TABLE tipo_usuario (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(50),
  descripcion TEXT,
  fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  activo TINYINT(1) DEFAULT 1
);

select * from tipo_usuario;

DROP TABLE IF EXISTS usuarios;
-- Tabla de usuarios
CREATE TABLE usuarios (
  id INT AUTO_INCREMENT PRIMARY KEY,
  usuario VARCHAR(50) NOT NULL UNIQUE,
  correo VARCHAR(255) NOT NULL,
  contrasena VARCHAR(255) NOT NULL,
  tipo_usuario_id INT NOT NULL,
  fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  activo TINYINT(1) DEFAULT 1,
  CONSTRAINT FK_tipoUsuario FOREIGN KEY (tipo_usuario_id) REFERENCES tipo_usuario(id)
);


DROP TABLE IF EXISTS tipo_empleado;
-- Tabla de tipos de empleados
CREATE TABLE tipo_empleado (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(50) NOT NULL UNIQUE,
  descripcion TEXT,
  fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  activo TINYINT(1) DEFAULT 1
);

DROP TABLE IF EXISTS empleados;
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
  CONSTRAINT FK_tipoEmpleado FOREIGN KEY (tipo_empleado_id) REFERENCES tipo_empleado(id)
);

DROP TABLE IF EXISTS horarios;
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

DROP TABLE IF EXISTS empleado_horario;
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
  CONSTRAINT FK_empleadoId FOREIGN KEY (empleado_id) REFERENCES empleados(id),
  CONSTRAINT FK_horarioId FOREIGN KEY (horario_id) REFERENCES horarios(id),
  INDEX(empleado_id),
  INDEX(horario_id)
);

DROP TABLE IF EXISTS asistencia;
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
  CONSTRAINT FK_asistencia_empleado FOREIGN KEY (empleado_id) REFERENCES empleados(id),
  INDEX(fecha)
);

DROP TABLE IF EXISTS justificaciones;
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
  CONSTRAINT FK_asistenciaId FOREIGN KEY (asistencia_id) REFERENCES asistencia(id),
  CONSTRAINT FK_usuarioId FOREIGN KEY (aprobado_por) REFERENCES usuarios(id)
);


DROP TABLE IF EXISTS visitas;
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
  CONSTRAINT FK_registroVisita FOREIGN KEY (registrado_por) REFERENCES usuarios(id)
);

SELECT* from usuarios;


INSERT INTO usuarios(usuario, correo, contrasena, tipo_usuario_id)
VALUES ('angel','angel@gmail.com','ancaraMessi',1);
select * from usuarios;


INSERT INTO tipo_usuario (nombre, descripcion)
values
    ('Super Administrador','Administra todo el sistema'),
    ('Admin','Admiitra todo el sistema'),
    ('Empleado','Persona encargada de marcar las asistencias');

select * from tipo_usuario;

INSERT INTO tipo_empleado (nombre, descripcion)
VALUES ('Administrativo','responsable de marcar asistencia'),
       ('Operativo','colaborador operativo de la empresa');
SELECT * FROM tipo_empleado;

select * from empleados;