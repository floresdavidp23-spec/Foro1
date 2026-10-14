USE DB_SCRUM_PLANNING;
GO

-- =============================================
-- PRUEBA 1: INSERTAR PRIORIDAD
-- =============================================

EXEC SQM_CATALOGS.USP_Priorities
    @i_priorityName = 'Alta',
    @i_priorityCreatorId = 2,
    @w_Accion = 'I';
GO

-- =============================================
-- VERIFICAR EL REGISTRO INSERTADO
-- =============================================

SELECT *
FROM SQM_CATALOGS.TBL_Priorities;
GO

-- =============================================
-- PRUEBA 2: ACTUALIZAR PRIORIDAD
-- =============================================

EXEC SQM_CATALOGS.USP_Priorities
    @i_priorityId = 1,
    @i_priorityName = 'Prioridad Alta Actualizada',
    @i_priorityModificatorId = 2,
    @i_priorityEnable = 1,
    @w_Accion = 'U';
GO

-- =============================================
-- VERIFICAR LA ACTUALIZACIÓN
-- =============================================

SELECT *
FROM SQM_CATALOGS.TBL_Priorities
WHERE priorityId = 1;
GO