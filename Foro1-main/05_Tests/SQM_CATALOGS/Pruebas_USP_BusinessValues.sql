USE DB_SCRUM_PLANNING;
GO

-- =============================================
-- PRUEBA 1: INSERTAR VALOR DE NEGOCIO
-- =============================================

EXEC SQM_CATALOGS.USP_BusinessValues
    @i_businessValueName = 'Valor de Prueba',
    @i_businessValueCreatorId = 2,
    @w_Accion = 'I';
GO

-- =============================================
-- VERIFICAR EL REGISTRO INSERTADO
-- =============================================

SELECT *
FROM SQM_CATALOGS.TBL_BusinessValues;
GO

-- =============================================
-- PRUEBA 2: ACTUALIZAR VALOR DE NEGOCIO
-- =============================================

EXEC SQM_CATALOGS.USP_BusinessValues
    @i_businessValueId = 1,
    @i_businessValueName = 'Valor Actualizado',
    @i_businessValueModificatorId = 2,
    @i_businessValueEnable = 1,
    @w_Accion = 'U';
GO

-- =============================================
-- VERIFICAR LA ACTUALIZACIÓN
-- =============================================

SELECT *
FROM SQM_CATALOGS.TBL_BusinessValues
WHERE businessValueId = 1;
GO