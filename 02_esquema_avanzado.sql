
--   FASE 2 - ESQUEMA AVANZADO
--   Control de Cirugías
-- todos los archivos SQL estan hechos para PostgreSQL, probados y funcionando correctamente directamente en VSC Y PGAdmin4
--   Autor: Luis Fernando Portillo Pérez, Luis Antonio Jiménez Olivares, Juan Manuel Gómez Martínez



-- Tabla de Quirófanos
CREATE TABLE Quirofano (
    id_quirofano SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    capacidad INTEGER CHECK (capacidad > 0),
    estado VARCHAR(20) DEFAULT 'DISPONIBLE'
);

-- Tabla de Programación de Cirugías
CREATE TABLE Programacion_Cirugia (
    id_programacion SERIAL PRIMARY KEY,
    id_mascota INT NOT NULL,
    cedula_veterinario VARCHAR(20) NOT NULL,
    id_quirofano INT NOT NULL,
    fecha DATE NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,
    observaciones TEXT,

    FOREIGN KEY (id_mascota) REFERENCES Mascota(id_mascota),
    FOREIGN KEY (cedula_veterinario) REFERENCES Veterinario(cedula),
    FOREIGN KEY (id_quirofano) REFERENCES Quirofano(id_quirofano),

    CHECK (hora_fin > hora_inicio)
);

-- Índice para búsquedas por quirófano y fecha
CREATE INDEX idx_cirugia_quirofano_fecha
ON Programacion_Cirugia (id_quirofano, fecha);
