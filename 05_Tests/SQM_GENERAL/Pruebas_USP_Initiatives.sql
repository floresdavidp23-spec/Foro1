USE DB_SCRUM_PLANNING;
GO

DECLARE @n INT, @mt VARCHAR(500), @mu VARCHAR(500);
DECLARE @initiativeId INT, @bv INT;

SELECT TOP 1 @bv = BusinessValueId FROM [SQM_CATALOGS].[TBL_BusinessValues];

-- 1. INSERTAR (espera 201)
EXEC [SQM_GENERAL].[USP_Initiatives]
     @w_Accion = 'I',
     @i_initiativeSummary = 'Iniciativa de prueba',
     @i_initiativeDescription = 'Descripcion de prueba',
     @i_initiativeOwner = 4,
     @i_initiativeGoals = 'Objetivos de prueba',
     @i_initiativeBusinessValue = @bv,
     @i_initiativeTargetStart = '2026-10-20',
     @i_initiativeTargetEnd = '2026-12-20',
     @i_initiativeCreatorId = 4,
     @i_initiativeStatus = 1,
     @o_Numero = @n OUT, @o_MensajeTecnico = @mt OUT, @o_MensajeUsuario = @mu OUT;

SELECT 'INSERTAR' AS Prueba, @n AS Numero, @mu AS Mensaje, @mt AS Tecnico;

SELECT @initiativeId = MAX(initiativeId) FROM [SQM_GENERAL].[TBL_Initiatives];

-- 2. ACTUALIZAR (espera 200)
EXEC [SQM_GENERAL].[USP_Initiatives]
     @w_Accion = 'U',
     @i_initiativeId = @initiativeId,
     @i_initiativeSummary = 'Iniciativa actualizada',
     @i_initiativeStatus = 2,
     @i_initiativeTargetEnd = '2027-01-15',
     @i_initiativeModificatorId = 4,
     @o_Numero = @n OUT, @o_MensajeTecnico = @mt OUT, @o_MensajeUsuario = @mu OUT;

SELECT 'ACTUALIZAR' AS Prueba, @n AS Numero, @mu AS Mensaje, @mt AS Tecnico;

SELECT * FROM [SQM_GENERAL].[TBL_Initiatives] WHERE initiativeId = @initiativeId;

-- 3. LISTAR (espera 200)
EXEC [SQM_GENERAL].[USP_Initiatives]
     @w_Accion = 'S',
     @i_PageNumber = 1,
     @i_RowsPerPage = 5,
     @o_Numero = @n OUT, @o_MensajeTecnico = @mt OUT, @o_MensajeUsuario = @mu OUT;

SELECT 'LISTAR' AS Prueba, @n AS Numero, @mu AS Mensaje, @mt AS Tecnico;
GO