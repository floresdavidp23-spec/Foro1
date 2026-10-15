--USP_ActivityTypes

USE DB_SCRUM_PLANNING;
GO

CREATE OR ALTER PROCEDURE SQM_CATALOGS.USP_ActivityTypes
(
    @i_activityTypeId INT = NULL,
    @i_activityTypeName VARCHAR(80) = NULL,
    @i_activityTypeCreatorId INT = NULL,
    @i_activityTypeModificatorId INT = NULL,
    @i_activityTypeEnable BIT = NULL,
    @i_PageNumber INT = 1,
    @i_RowsPerPage INT = 10,
    @w_Accion CHAR(1)
)
AS
BEGIN

    -- INSERTAR
    IF @w_Accion = 'I'
    BEGIN

        INSERT INTO SQM_CATALOGS.TBL_ActivityTypes
        (
            activityTypeName,
            activityTypeCreationDate,
            activityTypeCreatorId,
            activityTypeModificationDate,
            activityTypeEnable
        )
        VALUES
        (
            @i_activityTypeName,
            GETDATE(),
            @i_activityTypeCreatorId,
            NULL,
            1
        );

        PRINT 'TIPO DE ACTIVIDAD REGISTRADO CORRECTAMENTE';

    END

    -- ACTUALIZAR
    ELSE IF @w_Accion = 'U'
    BEGIN

        UPDATE SQM_CATALOGS.TBL_ActivityTypes
        SET activityTypeName = @i_activityTypeName,
            activityTypeModificationDate = GETDATE(),
            activityTypeModificatorId = @i_activityTypeModificatorId,
            activityTypeEnable = @i_activityTypeEnable
        WHERE activityTypeId = @i_activityTypeId;

        PRINT 'TIPO DE ACTIVIDAD ACTUALIZADO CORRECTAMENTE';

    END

    -- LISTAR CON PAGINACION
    ELSE IF @w_Accion = 'S'
    BEGIN
        IF @i_PageNumber < 1 SET @i_PageNumber = 1;
        IF @i_RowsPerPage < 1 SET @i_RowsPerPage = 10;

        SELECT *
        FROM SQM_CATALOGS.TBL_ActivityTypes
        ORDER BY activityTypeId
        OFFSET (@i_PageNumber - 1) * @i_RowsPerPage ROWS
        FETCH NEXT @i_RowsPerPage ROWS ONLY;
    END

END;
GO