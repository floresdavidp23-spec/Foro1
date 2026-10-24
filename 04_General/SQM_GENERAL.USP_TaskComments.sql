USE DB_SCRUM_PLANNING;
GO

CREATE OR ALTER PROCEDURE SQM_GENERAL.USP_TaskComments
(
    @i_taskCommentId INT = NULL,
    @i_taskCommentParentLink INT = NULL,
    @i_taskCommentOwner INT = NULL,
    @i_taskCommentText NVARCHAR(4000) = NULL,
    @i_taskCommentCreatorId INT = NULL,
    @i_taskCommentModificatorId INT = NULL,
    @i_taskCommentStatus BIT = NULL,
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

        -- Insertar comentario
        IF @w_Accion = 'I'
        BEGIN
            -- Validar tarea relacionada
            IF @i_taskCommentParentLink IS NULL
               OR @i_taskCommentParentLink <= 0
            BEGIN
                ;THROW 50002, 'Debe proporcionar un ID de tarea valido.', 1;
            END;

            -- Validar propietario
            IF @i_taskCommentOwner IS NULL
               OR @i_taskCommentOwner <= 0
            BEGIN
                ;THROW 50003, 'Debe proporcionar un ID de propietario valido.', 1;
            END;

            -- Validar texto obligatorio
            IF @i_taskCommentText IS NULL
               OR LTRIM(RTRIM(@i_taskCommentText)) = ''
            BEGIN
                ;THROW 50004, 'El texto del comentario es obligatorio.', 1;
            END;

            -- Validar creador
            IF @i_taskCommentCreatorId IS NULL
               OR @i_taskCommentCreatorId <= 0
            BEGIN
                ;THROW 50005, 'Debe proporcionar un ID de creador valido.', 1;
            END;

            INSERT INTO SQM_GENERAL.TBL_TaskComments
            (
                taskCommentParentLink,
                taskCommentOwner,
                taskCommentText,
                taskCommentCreationDate,
                taskCommentCreatorId,
                taskCommentModificationDate,
                taskCommentModificatorId,
                taskCommentStatus
            )
            VALUES
            (
                @i_taskCommentParentLink,
                @i_taskCommentOwner,
                LTRIM(RTRIM(@i_taskCommentText)),
                GETDATE(),
                @i_taskCommentCreatorId,
                NULL,
                NULL,
                1
            );

            SET @v_RowsAffected = @@ROWCOUNT;

            IF @v_RowsAffected = 0
            BEGIN
                ;THROW 50006, 'No se pudo registrar el comentario.', 1;
            END;

            PRINT 'COMENTARIO REGISTRADO CORRECTAMENTE';
        END

        -- Actualizar comentario
        ELSE IF @w_Accion = 'U'
        BEGIN
            -- Validar ID del comentario
            IF @i_taskCommentId IS NULL
               OR @i_taskCommentId <= 0
            BEGIN
                ;THROW 50007, 'Debe proporcionar un ID de comentario valido.', 1;
            END;

            -- Verificar que el comentario exista
            IF NOT EXISTS
            (
                SELECT 1
                FROM SQM_GENERAL.TBL_TaskComments
                WHERE taskCommentId = @i_taskCommentId
            )
            BEGIN
                ;THROW 50008, 'El comentario no existe.', 1;
            END;

            -- Validar tarea relacionada
            IF @i_taskCommentParentLink IS NULL
               OR @i_taskCommentParentLink <= 0
            BEGIN
                ;THROW 50009, 'Debe proporcionar un ID de tarea valido.', 1;
            END;

            -- Validar propietario
            IF @i_taskCommentOwner IS NULL
               OR @i_taskCommentOwner <= 0
            BEGIN
                ;THROW 50010, 'Debe proporcionar un ID de propietario valido.', 1;
            END;

            -- Validar texto obligatorio
            IF @i_taskCommentText IS NULL
               OR LTRIM(RTRIM(@i_taskCommentText)) = ''
            BEGIN
                ;THROW 50011, 'El texto del comentario es obligatorio.', 1;
            END;

            -- Validar modificador
            IF @i_taskCommentModificatorId IS NULL
               OR @i_taskCommentModificatorId <= 0
            BEGIN
                ;THROW 50012, 'Debe proporcionar un ID de modificador valido.', 1;
            END;

            -- Validar estado
            IF @i_taskCommentStatus IS NULL
            BEGIN
                ;THROW 50013, 'Debe proporcionar el estado del comentario.', 1;
            END;

            UPDATE SQM_GENERAL.TBL_TaskComments
            SET taskCommentParentLink = @i_taskCommentParentLink,
                taskCommentOwner = @i_taskCommentOwner,
                taskCommentText = LTRIM(RTRIM(@i_taskCommentText)),
                taskCommentModificationDate = GETDATE(),
                taskCommentModificatorId = @i_taskCommentModificatorId,
                taskCommentStatus = @i_taskCommentStatus
            WHERE taskCommentId = @i_taskCommentId;

            SET @v_RowsAffected = @@ROWCOUNT;

            IF @v_RowsAffected = 0
            BEGIN
                ;THROW 50014, 'No se pudo actualizar el comentario.', 1;
            END;

            PRINT 'COMENTARIO ACTUALIZADO CORRECTAMENTE';
        END

        -- Listar comentarios con paginacion
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
                ;THROW 50015, 'El maximo permitido es de 100 filas por pagina.', 1;
            END;

            -- Calcular desplazamiento
            SET @v_Offset =
                CAST(@i_PageNumber - 1 AS BIGINT)
                * CAST(@i_RowsPerPage AS BIGINT);

            SELECT *
            FROM SQM_GENERAL.TBL_TaskComments
            ORDER BY taskCommentId
            OFFSET @v_Offset ROWS
            FETCH NEXT @i_RowsPerPage ROWS ONLY;
        END;

    END TRY
    BEGIN CATCH
        ;THROW;
    END CATCH;
END;
GO
