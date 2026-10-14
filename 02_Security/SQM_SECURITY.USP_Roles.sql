--SQM_SECURITY.USP_Roles

USE DB_SCRUM_PLANNING;
GO

CREATE OR ALTER PROCEDURE SQM_SECURITY.USP_Roles
(
    @i_rolId INT = NULL,
    @i_rolName VARCHAR(80) = NULL,
    @i_rolCreatorId INT = NULL,
    @i_rolModificatorId INT = NULL,
    @i_rolEnable BIT = NULL,
    @w_Accion CHAR(1)
)
AS
BEGIN

    -- INSERTAR
    IF @w_Accion = 'I'
    BEGIN

        INSERT INTO SQM_SECURITY.TBL_Roles
        (
            rolName,
            rolCreationDate,
            rolCreatorId,
            rolModificationDate,
            rolModificatorId,
            rolEnable
        )
        VALUES
        (
            @i_rolName,
            GETDATE(),
            @i_rolCreatorId,
            GETDATE(),
            NULL,
            1
        );

        PRINT 'ROL REGISTRADO CORRECTAMENTE';

    END

    -- ACTUALIZAR
    ELSE IF @w_Accion = 'U'
    BEGIN

        UPDATE SQM_SECURITY.TBL_Roles
        SET rolName = @i_rolName,
            rolModificationDate = GETDATE(),
            rolModificatorId = @i_rolModificatorId,
            rolEnable = @i_rolEnable
        WHERE rolId = @i_rolId;

        PRINT 'ROL ACTUALIZADO CORRECTAMENTE';

    END

END;
GO