USE DB_SCRUM_PLANNING;
GO

-- =============================================
-- PRUEBA 1: INSERTAR TIPO DE ACTIVIDAD
-- =============================================

EXEC SQM_CATALOGS.USP_ActivityTypes
    @i_activityTypeName = 'Actividad de Prueba',
    @i_activityTypeCreatorId = 2,
    @w_Accion = 'I';
GO

-- =============================================
-- VERIFICAR EL REGISTRO INSERTADO
-- =============================================

SELECT *
FROM SQM_CATALOGS.TBL_ActivityTypes;
GO

-- =============================================
-- PRUEBA 2: ACTUALIZAR TIPO DE ACTIVIDAD
-- =============================================

EXEC SQM_CATALOGS.USP_ActivityTypes
    @i_activityTypeId = 3,
    @i_activityTypeName = 'Actividad Actualizada',
    @i_activityTypeModificatorId = 2,
    @i_activityTypeEnable = 1,
    @w_Accion = 'U';
GO

-- =============================================
-- VERIFICAR LA ACTUALIZACIÓN
-- =============================================

SELECT *
FROM SQM_CATALOGS.TBL_ActivityTypes
WHERE activityTypeId = 3
GO

-------------------------------------------------
USE DB_SCRUM_PLANNING;
GO

SELECT userId, userFullName, userName
FROM SQM_SECURITY.TBL_Users;
GO