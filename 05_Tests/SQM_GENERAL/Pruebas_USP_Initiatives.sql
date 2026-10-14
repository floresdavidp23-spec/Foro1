USE DB_SCRUM_PLANNING;
GO

-- =============================================
-- PRUEBA 1: INSERTAR INICIATIVA
-- =============================================

EXEC SQM_GENERAL.USP_Initiatives
    @i_initiativeSummary = 'Iniciativa de Prueba',
    @i_initiativeDescription = 'Descripcion de prueba para validar el procedimiento',
    @i_initiativeOwner = 2,
    @i_initiativeGoals = 'Validar las operaciones INSERT y UPDATE',
    @i_initiativeBusinessValue = 1,
    @i_initiativeTargetStart = '2026-10-14',
    @i_initiativeTargetEnd = '2026-10-30',
    @i_initiativeCreatorId = 2,
    @i_initiativeStatus = 3,
    @w_Accion = 'I';
GO

-- =============================================
-- VERIFICAR EL REGISTRO INSERTADO
-- =============================================

SELECT *
FROM SQM_GENERAL.TBL_Initiatives;
GO

-- =============================================
-- PRUEBA 2: ACTUALIZAR INICIATIVA
-- =============================================

EXEC SQM_GENERAL.USP_Initiatives
    @i_initiativeId = 1,
    @i_initiativeSummary = 'Iniciativa Actualizada',
    @i_initiativeDescription = 'Descripcion actualizada para comprobar el UPDATE',
    @i_initiativeOwner = 2,
    @i_initiativeGoals = 'Comprobar que la actualizacion funciona',
    @i_initiativeBusinessValue = 1,
    @i_initiativeTargetStart = '2026-10-14',
    @i_initiativeTargetEnd = '2026-11-15',
    @i_initiativeModificatorId = 2,
    @i_initiativeStatus = 4,
    @w_Accion = 'U';
GO

-- =============================================
-- VERIFICAR LA ACTUALIZACIÓN
-- =============================================

SELECT *
FROM SQM_GENERAL.TBL_Initiatives
WHERE initiativeId = 1;
GO