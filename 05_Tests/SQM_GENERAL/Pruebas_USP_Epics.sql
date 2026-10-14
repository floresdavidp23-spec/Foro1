USE DB_SCRUM_PLANNING;
GO

-- =============================================
-- PRUEBA DE INSERT: SQM_GENERAL.USP_Epics
-- =============================================

EXEC SQM_GENERAL.USP_Epics
    @i_epicName = 'Epica de Prueba',
    @i_epicSummary = 'Resumen de prueba para validar el procedimiento',
    @i_epicDescription = 'Descripcion de prueba para comprobar el INSERT y UPDATE',
    @i_epicOwner = 2,
    @i_epicParentLink = 1,
    @i_epicPriority = 1,
    @i_epicStartDate = '2026-10-14',
    @i_epicDueDate = '2026-10-30',
    @i_epicCreatorId = 2,
    @i_epicStatus = 3,
    @w_Accion = 'I';
GO

-- =============================================
-- VERIFICAR EL REGISTRO INSERTADO
-- =============================================

SELECT *
FROM SQM_GENERAL.TBL_Epics;
GO

-- =============================================
-- PRUEBA 2: ACTUALIZAR ÉPICA
-- =============================================

EXEC SQM_GENERAL.USP_Epics
    @i_epicId = 3,
    @i_epicName = 'Epica Actualizada',
    @i_epicSummary = 'Resumen actualizado de la epica',
    @i_epicDescription = 'Descripcion modificada para comprobar el UPDATE',
    @i_epicOwner = 2,
    @i_epicParentLink = 1,
    @i_epicPriority = 1,
    @i_epicStartDate = '2026-10-14',
    @i_epicDueDate = '2026-11-15',
    @i_epicModificatorId = 2,
    @i_epicStatus = 4,
    @w_Accion = 'U';
GO

-- =============================================
-- VERIFICAR LA ACTUALIZACIÓN
-- =============================================

SELECT *
FROM SQM_GENERAL.TBL_Epics
WHERE epicId = 3;
GO