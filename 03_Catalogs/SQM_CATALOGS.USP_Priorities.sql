--SQM_CATALOGS.USP_Priorities

USE DB_SCRUM_PLANNING;
GO

CREATE OR ALTER PROCEDURE SQM_CATALOGS.USP_Priorities
(
    @i_priorityId INT = NULL,
    @i_priorityName VARCHAR(80) = NULL,
    @i_priorityCreatorId INT = NULL,
    @i_priorityModificatorId INT = NULL,
    @i_priorityEnable BIT = NULL,
    @i_PageNumber INT = 1,
    @i_RowsPerPage INT = 10,
    @w_Accion CHAR(1)
)
AS
BEGIN

    -- INSERTAR
    IF @w_Accion = 'I'
    BEGIN

        INSERT INTO SQM_CATALOGS.TBL_Priorities
        (
            priorityName,
            priorityCreationDate,
            priorityCreatorId,
            priorityModificationDate,
            priorityModificatorId,
            priorityEnable
        )
        VALUES
        (
            @i_priorityName,
            GETDATE(),
            @i_priorityCreatorId,
            NULL,
            NULL,
            1
        );

        PRINT 'PRIORIDAD REGISTRADA CORRECTAMENTE';

    END

    -- ACTUALIZAR
    ELSE IF @w_Accion = 'U'
    BEGIN

        UPDATE SQM_CATALOGS.TBL_Priorities
        SET priorityName = @i_priorityName,
            priorityModificationDate = GETDATE(),
            priorityModificatorId = @i_priorityModificatorId,
            priorityEnable = @i_priorityEnable
        WHERE priorityId = @i_priorityId;

        PRINT 'PRIORIDAD ACTUALIZADA CORRECTAMENTE';

    END

    -- LISTAR CON PAGINACION
    ELSE IF @w_Accion = 'S'
    BEGIN
        IF @i_PageNumber < 1 SET @i_PageNumber = 1;
        IF @i_RowsPerPage < 1 SET @i_RowsPerPage = 10;

        SELECT *
        FROM SQM_CATALOGS.TBL_Priorities
        ORDER BY priorityId
        OFFSET (@i_PageNumber - 1) * @i_RowsPerPage ROWS
        FETCH NEXT @i_RowsPerPage ROWS ONLY;
    END

END;
GO