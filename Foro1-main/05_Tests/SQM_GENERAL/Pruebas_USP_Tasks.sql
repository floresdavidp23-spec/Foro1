USE DB_SCRUM_PLANNING;
GO

-- =============================================
-- PRUEBA 1: INSERTAR TAREA
-- =============================================

EXEC SQM_GENERAL.USP_Tasks
    @i_taskSummary = 'Tarea de Prueba',
    @i_taskDescription = 'Descripcion para comprobar INSERT y UPDATE',
    @i_taskOwner = 2,
    @i_taskParentLink = 1,
    @i_taskOriginalEstimate = 8,
    @i_taskCompletedWork = 0,
    @i_taskRemaningWork = 8,
    @i_taskStartDate = '2026-10-14',
    @i_taskCompletedDate = NULL,
    @i_taskDueDate = '2026-10-30',
    @i_taskActivityType = 3,
    @i_taskCreatorId = 2,
    @i_taskStatus = 3,
    @w_Accion = 'I';
GO

-- =============================================
-- VERIFICAR EL REGISTRO INSERTADO
-- =============================================

SELECT *
FROM SQM_GENERAL.TBL_Tasks;
GO

-- =============================================
-- PRUEBA 2: ACTUALIZAR TAREA
-- =============================================

EXEC SQM_GENERAL.USP_Tasks
    @i_taskId = 1,
    @i_taskSummary = 'Tarea Actualizada',
    @i_taskDescription = 'Descripcion actualizada para comprobar el UPDATE',
    @i_taskOwner = 2,
    @i_taskParentLink = 1,
    @i_taskOriginalEstimate = 8,
    @i_taskCompletedWork = 3,
    @i_taskRemaningWork = 5,
    @i_taskStartDate = '2026-10-14',
    @i_taskCompletedDate = NULL,
    @i_taskDueDate = '2026-11-15',
    @i_taskActivityType = 3,
    @i_taskModificatorId = 2,
    @i_taskStatus = 4,
    @w_Accion = 'U';
GO

-- =============================================
-- VERIFICAR LA ACTUALIZACIÓN
-- =============================================

SELECT *
FROM SQM_GENERAL.TBL_Tasks
WHERE taskId = 1;
GO