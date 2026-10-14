--SQM_GENERAL.USP_Tasks

USE DB_SCRUM_PLANNING;
GO

CREATE OR ALTER PROCEDURE SQM_GENERAL.USP_Tasks
(
    @i_taskId INT = NULL,
    @i_taskSummary VARCHAR(500) = NULL,
    @i_taskDescription VARCHAR(2000) = NULL,
    @i_taskOwner INT = NULL,
    @i_taskParentLink INT = NULL,
    @i_taskOriginalEstimate INT = NULL,
    @i_taskCompletedWork INT = NULL,
    @i_taskRemaningWork INT = NULL,
    @i_taskStartDate DATE = NULL,
    @i_taskCompletedDate DATE = NULL,
    @i_taskDueDate DATE = NULL,
    @i_taskActivityType INT = NULL,
    @i_taskCreatorId INT = NULL,
    @i_taskModificatorId INT = NULL,
    @i_taskStatus INT = NULL,
    @w_Accion CHAR(1)
)
AS
BEGIN

    -- INSERTAR
    IF @w_Accion = 'I'
    BEGIN

        INSERT INTO SQM_GENERAL.TBL_Tasks
        (
            taskSummary,
            taskDescription,
            taskOwner,
            taskParentLink,
            taskOriginalEstimate,
            taskCompletedWork,
            taskRemaningWork,
            taskStartDate,
            taskCompletedDate,
            taskDueDate,
            taskActivityType,
            taskCreationDate,
            taskCreatorId,
            taskModificationDate,
            taskModificatorId,
            taskStatus
        )
        VALUES
        (
            @i_taskSummary,
            @i_taskDescription,
            @i_taskOwner,
            @i_taskParentLink,
            @i_taskOriginalEstimate,
            @i_taskCompletedWork,
            @i_taskRemaningWork,
            @i_taskStartDate,
            @i_taskCompletedDate,
            @i_taskDueDate,
            @i_taskActivityType,
            GETDATE(),
            @i_taskCreatorId,
            NULL,
            NULL,
            @i_taskStatus
        );

        PRINT 'TAREA REGISTRADA CORRECTAMENTE';

    END

    -- ACTUALIZAR
    ELSE IF @w_Accion = 'U'
    BEGIN

        UPDATE SQM_GENERAL.TBL_Tasks
        SET taskSummary = @i_taskSummary,
            taskDescription = @i_taskDescription,
            taskOwner = @i_taskOwner,
            taskParentLink = @i_taskParentLink,
            taskOriginalEstimate = @i_taskOriginalEstimate,
            taskCompletedWork = @i_taskCompletedWork,
            taskRemaningWork = @i_taskRemaningWork,
            taskStartDate = @i_taskStartDate,
            taskCompletedDate = @i_taskCompletedDate,
            taskDueDate = @i_taskDueDate,
            taskActivityType = @i_taskActivityType,
            taskModificationDate = GETDATE(),
            taskModificatorId = @i_taskModificatorId,
            taskStatus = @i_taskStatus
        WHERE taskId = @i_taskId;

        PRINT 'TAREA ACTUALIZADA CORRECTAMENTE';

    END

END;
GO