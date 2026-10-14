USE DB_SCRUM_PLANNING;
GO

-- =============================================
-- PRUEBA 1: INSERTAR FEATURE
-- =============================================

EXEC SQM_GENERAL.USP_Features
    @i_featureSummary = 'Feature de Prueba',
    @i_featureDescription = 'Descripcion para comprobar el INSERT y UPDATE',
    @i_featureAcceptanceCriteria = 'La funcionalidad debe registrarse correctamente',
    @i_featureOwner = 2,
    @i_featureParentLink = 3,
    @i_featurePriority = 1,
    @i_featureStartDate = '2026-10-14',
    @i_featureDueDate = '2026-10-30',
    @i_featureCreatorId = 2,
    @i_featureStatus = 3,
    @w_Accion = 'I';
GO

-- =============================================
-- VERIFICAR EL REGISTRO INSERTADO
-- =============================================

SELECT *
FROM SQM_GENERAL.TBL_Features;
GO

-- =============================================
-- PRUEBA 2: ACTUALIZAR FEATURE
-- =============================================

EXEC SQM_GENERAL.USP_Features
    @i_featureId = 1,
    @i_featureSummary = 'Feature Actualizada',
    @i_featureDescription = 'Descripcion actualizada para comprobar el UPDATE',
    @i_featureAcceptanceCriteria = 'Los cambios deben guardarse correctamente',
    @i_featureOwner = 2,
    @i_featureParentLink = 3,
    @i_featurePriority = 1,
    @i_featureStartDate = '2026-10-14',
    @i_featureDueDate = '2026-11-15',
    @i_featureModificatorId = 2,
    @i_featureStatus = 4,
    @w_Accion = 'U';
GO

-- =============================================
-- VERIFICAR LA ACTUALIZACIÓN
-- =============================================

SELECT *
FROM SQM_GENERAL.TBL_Features
WHERE featureId = 1;
GO