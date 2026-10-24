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
    @i_PageNumber INT = 1,
    @i_RowsPerPage INT = 10,
    @w_Accion CHAR(1) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @v_RowsAffected INT;
    DECLARE @v_Offset BIGINT;

    BEGIN TRY

        -- Validar la accion
        IF @w_Accion IS NULL
           OR @w_Accion NOT IN ('I', 'U', 'S')
        BEGIN
            ;THROW 50001, 'Accion no valida. Use I, U o S.', 1;
        END;

        -- Insertar tarea
        IF @w_Accion = 'I'
        BEGIN
            -- Validar resumen
            IF @i_taskSummary IS NULL
               OR LTRIM(RTRIM(@i_taskSummary)) = ''
            BEGIN
                ;THROW 50002, 'El resumen de la tarea es obligatorio.', 1;
            END;

            -- Validar propietario
            IF @i_taskOwner IS NULL OR @i_taskOwner <= 0
            BEGIN
                ;THROW 50003, 'Debe proporcionar un ID de propietario valido.', 1;
            END;

            -- Validar creador
            IF @i_taskCreatorId IS NULL OR @i_taskCreatorId <= 0
            BEGIN
                ;THROW 50004, 'Debe proporcionar un ID de creador valido.', 1;
            END;

            -- Validar estado
            IF @i_taskStatus IS NULL OR @i_taskStatus < 0
            BEGIN
                ;THROW 50005, 'El estado es obligatorio y no puede ser negativo.', 1;
            END;

            -- Validar tarea padre
            IF @i_taskParentLink IS NOT NULL
               AND @i_taskParentLink <= 0
            BEGIN
                ;THROW 50006, 'El ID de la tarea padre debe ser positivo.', 1;
            END;

            -- Validar estimaciones de trabajo
            IF @i_taskOriginalEstimate IS NOT NULL
               AND @i_taskOriginalEstimate < 0
            BEGIN
                ;THROW 50007, 'La estimacion original no puede ser negativa.', 1;
            END;

            IF @i_taskCompletedWork IS NOT NULL
               AND @i_taskCompletedWork < 0
            BEGIN
                ;THROW 50008, 'El trabajo completado no puede ser negativo.', 1;
            END;

            IF @i_taskRemaningWork IS NOT NULL
               AND @i_taskRemaningWork < 0
            BEGIN
                ;THROW 50009, 'El trabajo restante no puede ser negativo.', 1;
            END;

            -- Validar fechas
            IF @i_taskStartDate IS NOT NULL
               AND @i_taskDueDate IS NOT NULL
               AND @i_taskStartDate > @i_taskDueDate
            BEGIN
                ;THROW 50010, 'La fecha de inicio no puede ser posterior al vencimiento.', 1;
            END;

            IF @i_taskCompletedDate IS NOT NULL
               AND @i_taskStartDate IS NOT NULL
               AND @i_taskCompletedDate < @i_taskStartDate
            BEGIN
                ;THROW 50011, 'La fecha de finalizacion no puede ser anterior al inicio.', 1;
            END;

            IF @i_taskCompletedDate IS NOT NULL
               AND @i_taskDueDate IS NOT NULL
               AND @i_taskCompletedDate < @i_taskStartDate
            BEGIN
                ;THROW 50012, 'Revise las fechas de finalizacion y vencimiento.', 1;
            END;

            -- Validar tipo de actividad
            IF @i_taskActivityType IS NOT NULL
               AND @i_taskActivityType <= 0
            BEGIN
                ;THROW 50013, 'El tipo de actividad debe ser un ID positivo.', 1;
            END;

            -- Registrar tarea
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
                LTRIM(RTRIM(@i_taskSummary)),
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

            SET @v_RowsAffected = @@ROWCOUNT;

            IF @v_RowsAffected = 0
            BEGIN
                ;THROW 50014, 'No se pudo registrar la tarea.', 1;
            END;

            PRINT 'TAREA REGISTRADA CORRECTAMENTE';
        END

        -- Actualizar tarea
        ELSE IF @w_Accion = 'U'
        BEGIN
            -- Validar ID de la tarea
            IF @i_taskId IS NULL OR @i_taskId <= 0
            BEGIN
                ;THROW 50015, 'Debe proporcionar un ID de tarea valido.', 1;
            END;

            -- Verificar que la tarea exista
            IF NOT EXISTS
            (
                SELECT 1
                FROM SQM_GENERAL.TBL_Tasks
                WHERE taskId = @i_taskId
            )
            BEGIN
                ;THROW 50016, 'La tarea no existe.', 1;
            END;

            -- Validar resumen
            IF @i_taskSummary IS NULL
               OR LTRIM(RTRIM(@i_taskSummary)) = ''
            BEGIN
                ;THROW 50017, 'El resumen de la tarea es obligatorio.', 1;
            END;

            -- Validar propietario
            IF @i_taskOwner IS NULL OR @i_taskOwner <= 0
            BEGIN
                ;THROW 50018, 'Debe proporcionar un ID de propietario valido.', 1;
            END;

            -- Validar modificador
            IF @i_taskModificatorId IS NULL
               OR @i_taskModificatorId <= 0
            BEGIN
                ;THROW 50019, 'Debe proporcionar un ID de modificador valido.', 1;
            END;

            -- Validar estado
            IF @i_taskStatus IS NULL OR @i_taskStatus < 0
            BEGIN
                ;THROW 50020, 'El estado es obligatorio y no puede ser negativo.', 1;
            END;

            -- Evitar que la tarea sea su propio padre
            IF @i_taskParentLink = @i_taskId
            BEGIN
                ;THROW 50021, 'Una tarea no puede ser su propia tarea padre.', 1;
            END;

            IF @i_taskParentLink IS NOT NULL
               AND @i_taskParentLink <= 0
            BEGIN
                ;THROW 50022, 'El ID de la tarea padre debe ser positivo.', 1;
            END;

            -- Validar estimaciones de trabajo
            IF @i_taskOriginalEstimate IS NOT NULL
               AND @i_taskOriginalEstimate < 0
            BEGIN
                ;THROW 50023, 'La estimacion original no puede ser negativa.', 1;
            END;

            IF @i_taskCompletedWork IS NOT NULL
               AND @i_taskCompletedWork < 0
            BEGIN
                ;THROW 50024, 'El trabajo completado no puede ser negativo.', 1;
            END;

            IF @i_taskRemaningWork IS NOT NULL
               AND @i_taskRemaningWork < 0
            BEGIN
                ;THROW 50025, 'El trabajo restante no puede ser negativo.', 1;
            END;

            -- Validar fechas
            IF @i_taskStartDate IS NOT NULL
               AND @i_taskDueDate IS NOT NULL
               AND @i_taskStartDate > @i_taskDueDate
            BEGIN
                ;THROW 50026, 'La fecha de inicio no puede ser posterior al vencimiento.', 1;
            END;

            IF @i_taskCompletedDate IS NOT NULL
               AND @i_taskStartDate IS NOT NULL
               AND @i_taskCompletedDate < @i_taskStartDate
            BEGIN
                ;THROW 50027, 'La fecha de finalizacion no puede ser anterior al inicio.', 1;
            END;

            IF @i_taskActivityType IS NOT NULL
               AND @i_taskActivityType <= 0
            BEGIN
                ;THROW 50028, 'El tipo de actividad debe ser un ID positivo.', 1;
            END;

            -- Actualizar tarea
            UPDATE SQM_GENERAL.TBL_Tasks
            SET taskSummary = LTRIM(RTRIM(@i_taskSummary)),
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

            SET @v_RowsAffected = @@ROWCOUNT;

            IF @v_RowsAffected = 0
            BEGIN
                ;THROW 50029, 'No se pudo actualizar la tarea.', 1;
            END;

            PRINT 'TAREA ACTUALIZADA CORRECTAMENTE';
        END

        -- Listar tareas con paginacion
        ELSE IF @w_Accion = 'S'
        BEGIN
            -- Validar numero de pagina
            IF @i_PageNumber IS NULL OR @i_PageNumber < 1
            BEGIN
                SET @i_PageNumber = 1;
            END;

            -- Validar filas por pagina
            IF @i_RowsPerPage IS NULL OR @i_RowsPerPage < 1
            BEGIN
                SET @i_RowsPerPage = 10;
            END;

            IF @i_RowsPerPage > 100
            BEGIN
                ;THROW 50030, 'El maximo permitido es de 100 filas por pagina.', 1;
            END;

            -- Calcular desplazamiento
            SET @v_Offset =
                CAST(@i_PageNumber - 1 AS BIGINT)
                * CAST(@i_RowsPerPage AS BIGINT);

            SELECT *
            FROM SQM_GENERAL.TBL_Tasks
            ORDER BY taskId
            OFFSET @v_Offset ROWS
            FETCH NEXT @i_RowsPerPage ROWS ONLY;
        END;

    END TRY
    BEGIN CATCH
        ;THROW;
    END CATCH;
END;
GO
