
-- todos los archivos SQL estan hechos para PostgreSQL, probados y funcionando correctamente directamente en VSC Y PGAdmin4
--   Autor: Luis Fernando Portillo Pérez, Luis Antonio Jiménez Olivares, Juan Manuel Gómez Martínez


-- LOGICA DE NEGOCIO
--   Stored Procedure para agendar cirugías, verificando conflictos de horario
-- El procedimiento recibe los parámetros necesarios y verifica si el quirófano está disponible en el horario solicitado antes de insertar la programación de la cirugía.
-- Si hay un conflicto, lanza una excepción.
-- Si no hay conflicto, inserta el registro en Programacion_Cirugia.
-- Se asume que las tablas ya existen según el esquema avanzado.
CREATE OR REPLACE PROCEDURE sp_agendar_cirugia(
    p_id_mascota INT,
    p_cedula_veterinario VARCHAR,
    p_id_quirofano INT,
    p_fecha DATE,
    p_hora_inicio TIME,
    p_hora_fin TIME,
    p_observaciones TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Verificación de solapamiento de horarios
    IF EXISTS (
        SELECT 1
        FROM Programacion_Cirugia
        WHERE id_quirofano = p_id_quirofano
          AND fecha = p_fecha
          AND p_hora_inicio < hora_fin
          AND p_hora_fin > hora_inicio
    ) THEN
        RAISE EXCEPTION
            'Conflicto de horario: el quirófano % ya está ocupado entre % y %',
            p_id_quirofano, p_hora_inicio, p_hora_fin;
    END IF;

    -- Inserción si no hay conflicto
    INSERT INTO Programacion_Cirugia (
        id_mascota,
        cedula_veterinario,
        id_quirofano,
        fecha,
        hora_inicio,
        hora_fin,
        observaciones
    )
    VALUES (
        p_id_mascota,
        p_cedula_veterinario,
        p_id_quirofano,
        p_fecha,
        p_hora_inicio,
        p_hora_fin,
        p_observaciones
    );

    -- Confirmar transacción
    COMMIT;
END;
$$;
