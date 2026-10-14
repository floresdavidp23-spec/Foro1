--SQM_CATALOGS.USP_BusinessValues

USE DB_SCRUM_PLANNING;
GO

CREATE OR ALTER PROCEDURE SQM_CATALOGS.USP_BusinessValues
(
    @i_businessValueId INT = NULL,
    @i_businessValueName VARCHAR(80) = NULL,
    @i_businessValueCreatorId INT = NULL,
    @i_businessValueModificatorId INT = NULL,
    @i_businessValueEnable BIT = NULL,
    @w_Accion CHAR(1)
)
AS
BEGIN

    -- INSERTAR
    IF @w_Accion = 'I'
    BEGIN

        INSERT INTO SQM_CATALOGS.TBL_BusinessValues
        (
            businessValueName,
            businessValueCreationDate,
            businessValueCreatorId,
            businessValueModificationDate,
            businessValueModificatorId,
            businessValueEnable
        )
        VALUES
        (
            @i_businessValueName,
            GETDATE(),
            @i_businessValueCreatorId,
            NULL,
            NULL,
            1
        );

        PRINT 'VALOR DE NEGOCIO REGISTRADO CORRECTAMENTE';

    END

    -- ACTUALIZAR
    ELSE IF @w_Accion = 'U'
    BEGIN

        UPDATE SQM_CATALOGS.TBL_BusinessValues
        SET businessValueName = @i_businessValueName,
            businessValueModificationDate = GETDATE(),
            businessValueModificatorId = @i_businessValueModificatorId,
            businessValueEnable = @i_businessValueEnable
        WHERE businessValueId = @i_businessValueId;

        PRINT 'VALOR DE NEGOCIO ACTUALIZADO CORRECTAMENTE';

    END

END;
GO