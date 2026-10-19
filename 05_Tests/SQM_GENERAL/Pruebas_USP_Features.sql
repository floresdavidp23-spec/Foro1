USE DB_SCRUM_PLANNING;
GO

DECLARE @n INT, @mt VARCHAR(500), @mu VARCHAR(500);
DECLARE @featureId INT;

-- =========== 1. INSERTAR (espera 201) ===========
EXEC [SQM_GENERAL].[USP_Features]
     @w_Accion = 'I',
     @i_featureSummary = 'Feature de prueba',
     @i_featureDescription = 'Descripcion de prueba',
     @i_featureAcceptanceCriteria = 'Criterios de prueba',
     @i_featureParentLink = 4,
     @i_featureOwner = 4,
     @i_featureCreatorId = 4,
     @i_featureStatus = 1,
     @i_featurePriority = 1,
     @i_featureStartDate = '2026-10-20',
     @i_featureDueDate = '2026-11-20',
     @o_Numero = @n OUT, @o_MensajeTecnico = @mt OUT, @o_MensajeUsuario = @mu OUT;

SELECT 'INSERTAR' AS Prueba, @n AS Numero, @mu AS Mensaje, @mt AS Tecnico;

-- Toma el id de la feature recién insertada
SELECT @featureId = MAX(featureId) FROM [SQM_GENERAL].[TBL_Features];

-- =========== 2. ACTUALIZAR (espera 200) ===========
EXEC [SQM_GENERAL].[USP_Features]
     @w_Accion = 'U',
     @i_featureId = @featureId,
     @i_featureSummary = 'Feature actualizada',
     @i_featureDescription = 'Descripcion modificada',
     @i_featureAcceptanceCriteria = 'Criterios modificados',
     @i_featureStatus = 2,
     @i_featureDueDate = '2026-12-01',
     @i_featureModificatorId = 4,
     @o_Numero = @n OUT, @o_MensajeTecnico = @mt OUT, @o_MensajeUsuario = @mu OUT;

SELECT 'ACTUALIZAR' AS Prueba, @n AS Numero, @mu AS Mensaje, @mt AS Tecnico;

-- Verifica que cambió (resumen, estado 2, vencimiento y fecha de modificación)
SELECT * FROM [SQM_GENERAL].[TBL_Features] WHERE featureId = @featureId;

-- =========== 3. LISTAR (espera 200) ===========
EXEC [SQM_GENERAL].[USP_Features]
     @w_Accion = 'S',
     @i_PageNumber = 1,
     @i_RowsPerPage = 5,
     @o_Numero = @n OUT, @o_MensajeTecnico = @mt OUT, @o_MensajeUsuario = @mu OUT;

SELECT 'LISTAR' AS Prueba, @n AS Numero, @mu AS Mensaje, @mt AS Tecnico;
GO