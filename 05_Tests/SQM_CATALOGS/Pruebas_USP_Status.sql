USE DB_SCRUM_PLANNING;
GO

/* =============================================
   PRUEBA 1: CONSULTAR LOS ESTADOS EXISTENTES
   ============================================= */

SELECT *
FROM SQM_CATALOGS.TBL_Status;
GO


/* =============================================
   PRUEBA 2: INSERTAR UN ESTADO
   ============================================= */

EXEC SQM_CATALOGS.USP_Status
    @i_statusName = 'En Progreso',
    @i_statusCreatorId = 1,
    @w_Accion = 'I';
GO

-- Verificar los estados registrados

SELECT *
FROM SQM_CATALOGS.TBL_Status;
GO


/* =============================================
   PRUEBA 3: ACTUALIZAR UN ESTADO
   ============================================= */

-- IMPORTANTE:
-- Ejecutar esta prueba únicamente cuando hayamos
-- confirmado el ID del estado que queremos modificar.

EXEC SQM_CATALOGS.USP_Status
    @i_statusId = 4,
    @i_statusName = 'En Desarrollo',
    @i_statusModificatorId = 1,
    @i_statusEnable = 1,
    @w_Accion = 'U';
GO

-- Verificar el estado actualizado

SELECT *
FROM SQM_CATALOGS.TBL_Status
WHERE statusId = 4;
GO