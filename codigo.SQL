DROP DATABASE IF EXISTS sistema_gestion_hospitalaria;
CREATE DATABASE sistema_gestion_hospitalaria CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE sistema_gestion_hospitalaria;

CREATE TABLE Especialidades (
    id_especialidad INT AUTO_INCREMENT PRIMARY KEY,
    nombre_especialidad VARCHAR(100) NOT NULL,
    descripcion TEXT
) ENGINE=InnoDB;

CREATE TABLE Medicos (
    id_medico INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefono VARCHAR(20),
    id_especialidad INT NOT NULL,
    CONSTRAINT fk_medico_especialidad FOREIGN KEY (id_especialidad) REFERENCES Especialidades(id_especialidad)
) ENGINE=InnoDB;

CREATE TABLE Pacientes (
    id_paciente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    genero ENUM('Masculino', 'Femenino', 'Otro') NOT NULL,
    telefono VARCHAR(20),
    direccion VARCHAR(255)
) ENGINE=InnoDB;

CREATE TABLE Habitaciones (
    id_habitacion INT AUTO_INCREMENT PRIMARY KEY,
    numero_habitacion VARCHAR(10) UNIQUE NOT NULL,
    tipo ENUM('UCI', 'General', 'Privada') NOT NULL,
    estado ENUM('Disponible', 'Ocupada', 'Mantenimiento') DEFAULT 'Disponible'
) ENGINE=InnoDB;


CREATE TABLE Citas (
    id_cita INT AUTO_INCREMENT PRIMARY KEY,
    id_paciente INT NOT NULL,
    id_medico INT NOT NULL,
    fecha_hora DATETIME NOT NULL,
    estado ENUM('Programada', 'Completada', 'Cancelada') DEFAULT 'Programada',
    CONSTRAINT fk_cita_paciente FOREIGN KEY (id_paciente) REFERENCES Pacientes(id_paciente),
    CONSTRAINT fk_cita_medico FOREIGN KEY (id_medico) REFERENCES Medicos(id_medico)
) ENGINE=InnoDB;


CREATE TABLE Historial_Medico (
    id_historial INT AUTO_INCREMENT PRIMARY KEY,
    id_paciente INT NOT NULL,
    id_medico INT NOT NULL,
    diagnostico TEXT NOT NULL,
    observaciones TEXT,
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_historial_paciente FOREIGN KEY (id_paciente) REFERENCES Pacientes(id_paciente),
    CONSTRAINT fk_historial_medico FOREIGN KEY (id_medico) REFERENCES Medicos(id_medico)
) ENGINE=InnoDB;


CREATE TABLE Medicamentos (
    id_medicamento INT AUTO_INCREMENT PRIMARY KEY,
    nombre_comercial VARCHAR(100) NOT NULL,
    principio_activo VARCHAR(100) NOT NULL,
    stock_actual INT UNSIGNED NOT NULL DEFAULT 0,
    precio_unitario DECIMAL(10, 2) NOT NULL
) ENGINE=InnoDB;


CREATE TABLE Recetas_Detalle (
    id_receta INT AUTO_INCREMENT PRIMARY KEY,
    id_historial INT NOT NULL,
    id_medicamento INT NOT NULL,
    cantidad INT UNSIGNED NOT NULL,
    instrucciones_dosis VARCHAR(255) NOT NULL,
    CONSTRAINT fk_receta_historial FOREIGN KEY (id_historial) REFERENCES Historial_Medico(id_historial),
    CONSTRAINT fk_receta_medicamento FOREIGN KEY (id_medicamento) REFERENCES Medicamentos(id_medicamento)
) ENGINE=InnoDB;


CREATE TABLE Facturacion (
    id_factura INT AUTO_INCREMENT PRIMARY KEY,
    id_paciente INT NOT NULL,
    monto_total DECIMAL(10, 2) NOT NULL,
    fecha_emision DATETIME DEFAULT CURRENT_TIMESTAMP,
    metodo_pago ENUM('Efectivo', 'Tarjeta de Credito', 'Transferencia', 'Seguro Medico'),
    estado_pago ENUM('Pendiente', 'Pagado', 'Anulado') DEFAULT 'Pendiente',
    CONSTRAINT fk_factura_paciente FOREIGN KEY (id_paciente) REFERENCES Pacientes(id_paciente)
) ENGINE=InnoDB;
