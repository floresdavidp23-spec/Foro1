USE DB_SCRUM_PLANNING;
GO

-- =============================================
-- PRUEBA 1: INSERTAR PRODUCT BACKLOG ITEM
-- =============================================

EXEC SQM_GENERAL.USP_ProductBacklogItems
    @i_PBISummary = 'PBI de Prueba',
    @i_PBIDescription = 'Descripcion para comprobar INSERT y UPDATE',
    @i_PBIAcceptanceCriteria = 'El elemento debe registrarse correctamente',
    @i_PBIOwner = 2,
    @i_PBIParentLink = 1,
    @i_PBIStoryPoint = 5,
    @i_PBIStartDate = '2026-10-14',
    @i_PBIDueDate = '2026-10-30',
    @i_PBIPriority = 1,
    @i_PBICreatorId = 2,
    @i_PBIStatus = 3,
    @w_Accion = 'I';
GO

-- =============================================
-- VERIFICAR EL REGISTRO INSERTADO
-- =============================================

SELECT *
FROM SQM_GENERAL.TBL_ProductBacklogItems;
GO

-- =============================================
-- PRUEBA 2: ACTUALIZAR PRODUCT BACKLOG ITEM
-- =============================================

EXEC SQM_GENERAL.USP_ProductBacklogItems
    @i_PBIId = 1,
    @i_PBISummary = 'PBI Actualizado',
    @i_PBIDescription = 'Descripcion actualizada para comprobar el UPDATE',
    @i_PBIAcceptanceCriteria = 'Los cambios deben guardarse correctamente',
    @i_PBIOwner = 2,
    @i_PBIParentLink = 1,
    @i_PBIStoryPoint = 8,
    @i_PBIStartDate = '2026-10-14',
    @i_PBIDueDate = '2026-11-15',
    @i_PBIPriority = 1,
    @i_PBIModificatorId = 2,
    @i_PBIStatus = 4,
    @w_Accion = 'U';
GO

-- =============================================
-- VERIFICAR LA ACTUALIZACIÓN
-- =============================================

SELECT *
FROM SQM_GENERAL.TBL_ProductBacklogItems
WHERE PBIId = 1;
GO