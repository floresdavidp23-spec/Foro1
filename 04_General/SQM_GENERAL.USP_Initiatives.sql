--SQM_GENERAL.USP_Initiatives

USE DB_SCRUM_PLANNING;
GO

CREATE OR ALTER PROCEDURE SQM_GENERAL.USP_Initiatives
(
    @i_initiativeId INT = NULL,
    @i_initiativeSummary VARCHAR(200) = NULL,
    @i_initiativeDescription VARCHAR(2000) = NULL,
    @i_initiativeOwner INT = NULL,
    @i_initiativeGoals VARCHAR(255) = NULL,
    @i_initiativeBusinessValue INT = NULL,
    @i_initiativeTargetStart DATE = NULL,
    @i_initiativeTargetEnd DATE = NULL,
    @i_initiativeCreatorId INT = NULL,
    @i_initiativeModificatorId INT = NULL,
    @i_initiativeStatus INT = NULL,
    @w_Accion CHAR(1)
)
AS
BEGIN

    -- INSERTAR
    IF @w_Accion = 'I'
    BEGIN

        INSERT INTO SQM_GENERAL.TBL_Initiatives
        (
            initiativeSummary,
            initiativeDescription,
            initiativeOwner,
            initiativeGoals,
            initiativeBusinessValue,
            initiativeTargetStart,
            initiativeTargetEnd,
            initiativeCreationDate,
            initiativeCreatorId,
            initiativeModificationDate,
            initiativeModificatorId,
            initiativeStatus
        )
        VALUES
        (
            @i_initiativeSummary,
            @i_initiativeDescription,
            @i_initiativeOwner,
            @i_initiativeGoals,
            @i_initiativeBusinessValue,
            @i_initiativeTargetStart,
            @i_initiativeTargetEnd,
            GETDATE(),
            @i_initiativeCreatorId,
            NULL,
            NULL,
            @i_initiativeStatus
        );

        PRINT 'INICIATIVA REGISTRADA CORRECTAMENTE';

    END

    -- ACTUALIZAR
    ELSE IF @w_Accion = 'U'
    BEGIN

        UPDATE SQM_GENERAL.TBL_Initiatives
        SET initiativeSummary = @i_initiativeSummary,
            initiativeDescription = @i_initiativeDescription,
            initiativeOwner = @i_initiativeOwner,
            initiativeGoals = @i_initiativeGoals,
            initiativeBusinessValue = @i_initiativeBusinessValue,
            initiativeTargetStart = @i_initiativeTargetStart,
            initiativeTargetEnd = @i_initiativeTargetEnd,
            initiativeModificationDate = GETDATE(),
            initiativeModificatorId = @i_initiativeModificatorId,
            initiativeStatus = @i_initiativeStatus
        WHERE initiativeId = @i_initiativeId;

        PRINT 'INICIATIVA ACTUALIZADA CORRECTAMENTE';

    END

END;
GO