--SQM_GENERAL.USP_Epics

USE DB_SCRUM_PLANNING;
GO

CREATE OR ALTER PROCEDURE SQM_GENERAL.USP_Epics
(
    @i_epicId INT = NULL,
    @i_epicName VARCHAR(100) = NULL,
    @i_epicSummary VARCHAR(500) = NULL,
    @i_epicDescription VARCHAR(4000) = NULL,
    @i_epicOwner INT = NULL,
    @i_epicParentLink INT = NULL,
    @i_epicPriority INT = NULL,
    @i_epicStartDate DATE = NULL,
    @i_epicDueDate DATE = NULL,
    @i_epicCreatorId INT = NULL,
    @i_epicModificatorId INT = NULL,
    @i_epicStatus INT = NULL,
    @w_Accion CHAR(1)
)
AS
BEGIN

    -- INSERTAR
    IF @w_Accion = 'I'
    BEGIN

        INSERT INTO SQM_GENERAL.TBL_Epics
        (
            epicName,
            epicSummary,
            epicDescription,
            epicOwner,
            epicParentLink,
            epicPriority,
            epicStartDate,
            epicDueDate,
            epicCreationDate,
            epicCreatorId,
            epicModificationDate,
            epicModificatorId,
            epicStatus
        )
        VALUES
        (
            @i_epicName,
            @i_epicSummary,
            @i_epicDescription,
            @i_epicOwner,
            @i_epicParentLink,
            @i_epicPriority,
            @i_epicStartDate,
            @i_epicDueDate,
            GETDATE(),
            @i_epicCreatorId,
            NULL,
            NULL,
            @i_epicStatus
        );

        PRINT 'EPICA REGISTRADA CORRECTAMENTE';

    END

    -- ACTUALIZAR
    ELSE IF @w_Accion = 'U'
    BEGIN

        UPDATE SQM_GENERAL.TBL_Epics
        SET epicName = @i_epicName,
            epicSummary = @i_epicSummary,
            epicDescription = @i_epicDescription,
            epicOwner = @i_epicOwner,
            epicParentLink = @i_epicParentLink,
            epicPriority = @i_epicPriority,
            epicStartDate = @i_epicStartDate,
            epicDueDate = @i_epicDueDate,
            epicModificationDate = GETDATE(),
            epicModificatorId = @i_epicModificatorId,
            epicStatus = @i_epicStatus
        WHERE epicId = @i_epicId;

        PRINT 'EPICA ACTUALIZADA CORRECTAMENTE';

    END

END;
GO