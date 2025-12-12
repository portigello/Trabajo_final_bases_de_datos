
--   ESQUEMA BÁSICO - FASE 1 
--   Clínica VetSalud
-- todos los archivos SQL estan hechos para PostgreSQL, probados y funcionando correctamente directamente en VSC Y PGAdmin4
--   Autor: Luis Fernando Portillo Pérez, Luis Antonio Jiménez Olivares, Juan Manuel Gómez Martínez


--CREACION DE TABLAS
--   TABLA: Dueño

CREATE TABLE Dueno (
    id_dueno SERIAL PRIMARY KEY,
    nombre          VARCHAR(100) NOT NULL,
    direccion       VARCHAR(200) NOT NULL
);

-- Teléfonos multivaluados - 1 dueño puede tener varios
CREATE TABLE Telefono_Dueno (
    id_telefono SERIAL PRIMARY KEY,
    id_dueno    INT NOT NULL,
    telefono    VARCHAR(20) NOT NULL,
    FOREIGN KEY (id_dueno) REFERENCES Dueno(id_dueno) ON DELETE CASCADE
);


--   TABLA: Mascota

CREATE TABLE Mascota (
    id_mascota SERIAL PRIMARY KEY,
    nombre         VARCHAR(100) NOT NULL,
    especie        VARCHAR(50)  NOT NULL,
    raza           VARCHAR(100),
    fecha_nacimiento DATE,
    id_dueno       INT NOT NULL,
    FOREIGN KEY (id_dueno) REFERENCES Dueno(id_dueno)
);


--   TABLA: Veterinario

CREATE TABLE Veterinario (
    cedula        VARCHAR(20) PRIMARY KEY,
    nombre        VARCHAR(100) NOT NULL,
    especialidad  VARCHAR(100)
);


--   TABLA: Cita

CREATE TABLE Cita (
    id_cita SERIAL PRIMARY KEY,
    fecha        DATE NOT NULL,
    hora         TIME NOT NULL,
    motivo       VARCHAR(300),
    id_mascota   INT NOT NULL,
    cedula_veterinario VARCHAR(20) NOT NULL,
    FOREIGN KEY (id_mascota) REFERENCES Mascota(id_mascota),
    FOREIGN KEY (cedula_veterinario) REFERENCES Veterinario(cedula)
);


--   TABLA: Diagnóstico (1 cita tiene 1 diagnóstico)

CREATE TABLE Diagnostico (
    id_diagnostico SERIAL PRIMARY KEY,
    descripcion TEXT NOT NULL,
    id_cita INT UNIQUE NOT NULL,
    FOREIGN KEY (id_cita) REFERENCES Cita(id_cita) ON DELETE CASCADE
);


--   TABLA: Medicamento
=
CREATE TABLE Medicamento (
    id_medicamento SERIAL PRIMARY KEY,
    nombre      VARCHAR(100) NOT NULL,
    dosis_info  VARCHAR(200)
);


--   TABLA: Receta (N medicamentos por cada diagnóstico)

CREATE TABLE Receta (
    id_receta SERIAL PRIMARY KEY,
    id_diagnostico  INT NOT NULL,
    id_medicamento  INT NOT NULL,
    cantidad        INT CHECK(cantidad > 0),
    instrucciones   TEXT,
    FOREIGN KEY (id_diagnostico) REFERENCES Diagnostico(id_diagnostico) ON DELETE CASCADE,
    FOREIGN KEY (id_medicamento) REFERENCES Medicamento(id_medicamento)
);


--   TABLAS: Vacunación

CREATE TABLE Vacuna (
    id_vacuna SERIAL PRIMARY KEY,
    nombre_vacuna VARCHAR(100) NOT NULL
);

-- Cada mascota tiene muchas vacunas a lo largo de su vida
CREATE TABLE Historial_Vacunacion (
    id_historial SERIAL PRIMARY KEY,
    id_mascota INT NOT NULL,
    id_vacuna  INT NOT NULL,
    fecha_aplicacion DATE NOT NULL,
    dosis VARCHAR(50),
    FOREIGN KEY (id_mascota) REFERENCES Mascota(id_mascota),
    FOREIGN KEY (id_vacuna)  REFERENCES Vacuna(id_vacuna)
);
