USE DB_SCRUM_PLANNING;
GO

-- =============================================
-- PRUEBA 1: INSERTAR COMENTARIO
-- =============================================

EXEC SQM_GENERAL.USP_TaskComments
    @i_taskCommentParentLink = 1,
    @i_taskCommentOwner = 2,
    @i_taskCommentText = N'Comentario de prueba para verificar INSERT y UPDATE',
    @i_taskCommentCreatorId = 2,
    @w_Accion = 'I';
GO

-- =============================================
-- VERIFICAR EL REGISTRO INSERTADO
-- =============================================

SELECT *
FROM SQM_GENERAL.TBL_TaskComments;
GO

USE DB_SCRUM_PLANNING;
GO

-- =============================================
-- PRUEBA 2: ACTUALIZAR COMENTARIO
-- =============================================

EXEC SQM_GENERAL.USP_TaskComments
    @i_taskCommentId = 1,
    @i_taskCommentParentLink = 1,
    @i_taskCommentOwner = 2,
    @i_taskCommentText = N'Comentario actualizado para comprobar el UPDATE',
    @i_taskCommentModificatorId = 2,
    @i_taskCommentStatus = 1,
    @w_Accion = 'U';
GO

-- =============================================
-- VERIFICAR LA ACTUALIZACIÓN
-- =============================================

SELECT *
FROM SQM_GENERAL.TBL_TaskComments
WHERE taskCommentId = 1;
GO