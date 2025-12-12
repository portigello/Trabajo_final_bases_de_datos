
-- DATOS DE PRUEBA - FASE 2
-- Clínica VetSalud
-- todos los archivos SQL estan hechos para PostgreSQL, probados y funcionando correctamente directamente en VSC Y PGAdmin4
-- Autor: Luis Fernando Portillo Pérez, Luis Antonio Jiménez Olivares, Juan Manuel Gómez Martínez

-- Este script inserta datos de prueba en las tablas creadas en las fases anteriores,
-- especialmente para probar el Stored Procedure sp_agendar_cirugia.
-- Se incluyen casos con y sin conflictos de horario para validar la lógica del procedimiento almacenado.
-- Además, se realiza una consulta final para verificar las cirugías programadas.


-- Limpieza previa 
TRUNCATE TABLE Programacion_Cirugia RESTART IDENTITY CASCADE;
TRUNCATE TABLE Quirofano RESTART IDENTITY CASCADE;
TRUNCATE TABLE Cita RESTART IDENTITY CASCADE;
TRUNCATE TABLE Mascota RESTART IDENTITY CASCADE;
TRUNCATE TABLE Telefono_Dueno RESTART IDENTITY CASCADE;
TRUNCATE TABLE Dueno RESTART IDENTITY CASCADE;
TRUNCATE TABLE Veterinario RESTART IDENTITY CASCADE;

--PRIMERO INSERTAMOS LOS DATOS BÁSICOS NECESARIOS PARA LAS PRUEBAS

-- DUEÑOS

INSERT INTO Dueno (nombre, direccion) VALUES
('Carlos Ramírez', 'Av. 123'),
('Laura Gómez', 'Calle 45 #12-34');


-- TELÉFONOS

INSERT INTO Telefono_Dueno (id_dueno, telefono) VALUES
(1, '3001234567'),
(1, '3017654321'),
(2, '3125558899');


-- MASCOTAS

INSERT INTO Mascota (nombre, especie, raza, fecha_nacimiento, id_dueno) VALUES
('Firulais', 'Perro', 'Labrador', '2020-01-01', 1),
('Mishi', 'Gato', 'Criollo', '2019-06-15', 2);


-- VETERINARIOS

INSERT INTO Veterinario (cedula, nombre, especialidad) VALUES
('123456', 'Dra. Ana Torres', 'Cirugía'),
('654321', 'Dr. Luis Pérez', 'Medicina General');


-- QUIRÓFANOS

INSERT INTO Quirofano (nombre, capacidad, estado) VALUES
('Q1', 2, 'DISPONIBLE'),
('Q2', 1, 'DISPONIBLE');


-- PRUEBAS DEL STORED PROCEDURE sp_agendar_cirugia
-- Se prueban varios casos, incluyendo conflictos de horario y casos válidos.
-- Cada llamada al procedimiento se comenta con el resultado esperado.
-- Se asume que las mascotas y veterinarios existen según los datos insertados arriba.
-- Las fechas y horas son elegidas para probar diferentes escenarios.


-- CASO 1: Cirugía válida (debe INSERTAR)

CALL sp_agendar_cirugia(
    1,              -- id_mascota (Firulais)
    '123456',       -- veterinario
    1,              -- quirófano Q1
    '2025-12-01',
    '09:00',
    '10:00',
    'Cirugía general'
);

-- CASO 2: Otra cirugía válida en mismo quirófano, sin solape
-- Debe INSERTAR        
CALL sp_agendar_cirugia(
    2,              -- Mishi
    '654321',
    1,              -- quirófano Q1
    '2025-12-01',
    '10:30',
    '11:30',
    'Esterilización'
);

-- CASO 3: Conflicto de horario (DEBE FALLAR)
-- Mismo quirófano, mismo día, horario solapado
CALL sp_agendar_cirugia(
    2,
    '123456',
    1,
    '2025-12-01',
    '09:30',
    '10:30',
    'Conflicto esperado'
);

-- CASO 4: Mismo horario pero en quirófano distinto (DEBE INSERTAR)
-- No hay conflicto porque es otro quirófano
CALL sp_agendar_cirugia(
    2,
    '123456',
    2,              -- quirófano Q2
    '2025-12-01',
    '09:30',
    '10:30',
    'Cirugía en quirófano alterno'
);


-- CONSULTA DE VERIFICACIÓN
-- genera una lista de todas las cirugías programadas
SELECT 
    pc.id_programacion,
    m.nombre AS mascota,
    v.nombre AS veterinario,
    q.nombre AS quirofano,
    pc.fecha,
    pc.hora_inicio,
    pc.hora_fin,
    pc.observaciones
FROM Programacion_Cirugia pc
JOIN Mascota m ON pc.id_mascota = m.id_mascota
JOIN Veterinario v ON pc.cedula_veterinario = v.cedula
JOIN Quirofano q ON pc.id_quirofano = q.id_quirofano
ORDER BY pc.fecha, pc.hora_inicio;
