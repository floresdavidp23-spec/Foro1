USE DB_SCRUM_PLANNING;
GO

DECLARE @n INT, @mt VARCHAR(500), @mu VARCHAR(500);

-- PRUEBA 1: INSERTAR (espera 201)
EXEC SQM_GENERAL.USP_Epics
    @i_epicName = 'Epica de Prueba',
    @i_epicSummary = 'Resumen de prueba para validar el procedimiento',
    @i_epicDescription = 'Descripcion de prueba para comprobar el INSERT y UPDATE',
    @i_epicOwner = 4,
    @i_epicParentLink = 2,
    @i_epicPriority = 1,
    @i_epicStartDate = '2026-10-14',
    @i_epicDueDate = '2026-10-30',
    @i_epicCreatorId = 4,
    @i_epicStatus = 1,
    @w_Accion = 'I',
    @o_Numero = @n OUT,
    @o_MensajeTecnico = @mt OUT,
    @o_MensajeUsuario = @mu OUT;

SELECT @n AS Numero, @mu AS Mensaje, @mt AS Tecnico;

SELECT * FROM SQM_GENERAL.TBL_Epics;
GO

DECLARE @n INT, @mt VARCHAR(500), @mu VARCHAR(500);

-- PRUEBA 2: ACTUALIZAR (espera 200)
-- Cambia el 4 por el epicId de la épica que quieras actualizar
EXEC SQM_GENERAL.USP_Epics
    @i_epicId = 4,
    @i_epicName = 'Epica Actualizada',
    @i_epicSummary = 'Resumen actualizado de la epica',
    @i_epicDescription = 'Descripcion modificada para comprobar el UPDATE',
    @i_epicOwner = 4,
    @i_epicParentLink = 2,
    @i_epicPriority = 1,
    @i_epicStartDate = '2026-10-14',
    @i_epicDueDate = '2026-11-15',
    @i_epicModificatorId = 4,
    @i_epicStatus = 2,
    @w_Accion = 'U',
    @o_Numero = @n OUT,
    @o_MensajeTecnico = @mt OUT,
    @o_MensajeUsuario = @mu OUT;

SELECT @n AS Numero, @mu AS Mensaje, @mt AS Tecnico;

SELECT * FROM SQM_GENERAL.TBL_Epics WHERE epicId = 4;
GO


DECLARE @n INT, @m  VARCHAR(500), @mu VARCHAR(500);

USE DB_SCRUM_PLANNING;
GO

DECLARE @n INT, @mt VARCHAR(500), @mu VARCHAR(500);

-- Página 1, 1 fila → espera 200 (muestra la épica con menor epicId)
EXEC SQM_GENERAL.USP_Epics @w_Accion = 'S', @i_PageNumber = 1, @i_RowsPerPage = 1,
     @o_Numero = @n OUT, @o_MensajeTecnico = @mt OUT, @o_MensajeUsuario = @mu OUT;
SELECT @n AS Numero, @mu AS Mensaje, @mt AS Tecnico;

-- Página 2, 1 fila → espera 200 (muestra la siguiente épica)
EXEC SQM_GENERAL.USP_Epics @w_Accion = 'S', @i_PageNumber = 2, @i_RowsPerPage = 1,
     @o_Numero = @n OUT, @o_MensajeTecnico = @mt OUT, @o_MensajeUsuario = @mu OUT;
SELECT @n AS Numero, @mu AS Mensaje, @mt AS Tecnico;

-- Página 99 → espera 204 (no hay más registros)
EXEC SQM_GENERAL.USP_Epics @w_Accion = 'S', @i_PageNumber = 99, @i_RowsPerPage = 1,
     @o_Numero = @n OUT, @o_MensajeTecnico = @mt OUT, @o_MensajeUsuario = @mu OUT;
SELECT @n AS Numero, @mu AS Mensaje, @mt AS Tecnico;

-- Sin parámetros de paginación → usa 1 y 10 por defecto, espera 200
EXEC SQM_GENERAL.USP_Epics @w_Accion = 'S',
     @o_Numero = @n OUT, @o_MensajeTecnico = @mt OUT, @o_MensajeUsuario = @mu OUT;
SELECT @n AS Numero, @mu AS Mensaje, @mt AS Tecnico;

-- Valores inválidos (0 y negativo) → se corrigen a 1 y 10, espera 200
EXEC SQM_GENERAL.USP_Epics @w_Accion = 'S', @i_PageNumber = 0, @i_RowsPerPage = -5,
     @o_Numero = @n OUT, @o_MensajeTecnico = @mt OUT, @o_MensajeUsuario = @mu OUT;
SELECT @n AS Numero, @mu AS Mensaje, @mt AS Tecnico;
GO