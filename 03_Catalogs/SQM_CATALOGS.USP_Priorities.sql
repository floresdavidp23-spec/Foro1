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

END;
GO