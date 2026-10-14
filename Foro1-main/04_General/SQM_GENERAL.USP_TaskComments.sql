--SQM_GENERAL.USP_TaskComments

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
    @w_Accion CHAR(1)
)
AS
BEGIN

    -- INSERTAR
    IF @w_Accion = 'I'
    BEGIN

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
            @i_taskCommentText,
            GETDATE(),
            @i_taskCommentCreatorId,
            NULL,
            NULL,
            1
        );

        PRINT 'COMENTARIO REGISTRADO CORRECTAMENTE';

    END

    -- ACTUALIZAR
    ELSE IF @w_Accion = 'U'
    BEGIN

        UPDATE SQM_GENERAL.TBL_TaskComments
        SET taskCommentParentLink = @i_taskCommentParentLink,
            taskCommentOwner = @i_taskCommentOwner,
            taskCommentText = @i_taskCommentText,
            taskCommentModificationDate = GETDATE(),
            taskCommentModificatorId = @i_taskCommentModificatorId,
            taskCommentStatus = @i_taskCommentStatus
        WHERE taskCommentId = @i_taskCommentId;

        PRINT 'COMENTARIO ACTUALIZADO CORRECTAMENTE';

    END

    -- LISTAR CON PAGINACION
    ELSE IF @w_Accion = 'S'
    BEGIN
        IF @i_PageNumber < 1 SET @i_PageNumber = 1;
        IF @i_RowsPerPage < 1 SET @i_RowsPerPage = 10;

        SELECT *
        FROM SQM_GENERAL.TBL_TaskComments
        ORDER BY taskCommentId
        OFFSET (@i_PageNumber - 1) * @i_RowsPerPage ROWS
        FETCH NEXT @i_RowsPerPage ROWS ONLY;
    END

END;
GO