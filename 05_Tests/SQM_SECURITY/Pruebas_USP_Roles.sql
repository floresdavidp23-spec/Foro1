USE DB_SCRUM_PLANNING;
GO

/* =============================================
   PRUEBA 1: CONSULTAR LOS ROLES EXISTENTES
   ============================================= */

SELECT *
FROM SQM_SECURITY.TBL_Roles;
GO


/* =============================================
   PRUEBA 2: INSERTAR UN ROL
   ============================================= */

EXEC SQM_SECURITY.USP_Roles
    @i_rolName = 'Administrador',
    @i_rolCreatorId = 1,
    @w_Accion = 'I';
GO

-- Verificar los roles registrados

SELECT
    rolId,
    rolName,
    rolEnable
FROM SQM_SECURITY.TBL_Roles;
GO

-- =============================================
-- PRUEBA DE UPDATE: SQM_SECURITY.USP_Roles
-- =============================================

EXEC SQM_SECURITY.USP_Roles
    @i_rolId = 1,
    @i_rolName = 'Administrador Actualizado',
    @i_rolModificatorId = 1,
    @i_rolEnable = 1,
    @w_Accion = 'U';
GO

-- =============================================
-- VERIFICAR QUE EL ROL SE ACTUALIZÓ
-- =============================================

SELECT *
FROM SQM_SECURITY.TBL_Roles
WHERE rolId = 1;
GO

--------------------------+----------------
---Verificar los roles existentes----------
SELECT *
FROM SQM_SECURITY.TBL_Roles;
GO