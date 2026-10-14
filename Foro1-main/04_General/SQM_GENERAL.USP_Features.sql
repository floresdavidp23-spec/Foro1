USE DB_SCRUM_PLANNING;
GO

CREATE OR ALTER PROCEDURE SQM_GENERAL.USP_Features
(
    @i_featureId INT = NULL,
    @i_featureSummary VARCHAR(500) = NULL,
    @i_featureDescription VARCHAR(2000) = NULL,
    @i_featureAcceptanceCriteria VARCHAR(4000) = NULL,
    @i_featureOwner INT = NULL,
    @i_featureParentLink INT = NULL,
    @i_featurePriority INT = NULL,
    @i_featureStartDate DATE = NULL,
    @i_featureDueDate DATE = NULL,
    @i_featureCreatorId INT = NULL,
    @i_featureModificatorId INT = NULL,
    @i_featureStatus INT = NULL,
    @i_PageNumber INT = 1,
    @i_RowsPerPage INT = 10,
    @w_Accion CHAR(1)
)
AS
BEGIN

    -- INSERTAR
    IF @w_Accion = 'I'
    BEGIN

        INSERT INTO SQM_GENERAL.TBL_Features
        (
            featureSummary,
            featureDescription,
            featuresAcceptanceCriteria, -- Nombre exacto de la tabla física
            featureOwner,
            featureParentLink,
            featurePriority,
            featureStartDate,
            featureDueDate,
            featureCreationDate,
            featureCreatorId,
            featureModificationDate,
            featureModificatorId,
            featureStatus
        )
        VALUES
        (
            @i_featureSummary,
            @i_featureDescription,
            @i_featureAcceptanceCriteria,
            @i_featureOwner,
            @i_featureParentLink,
            @i_featurePriority,
            @i_featureStartDate,
            @i_featureDueDate,
            GETDATE(),
            @i_featureCreatorId,
            NULL,
            NULL,
            @i_featureStatus
        );

        PRINT 'FEATURE REGISTRADA CORRECTAMENTE';

    END

    -- ACTUALIZAR
    ELSE IF @w_Accion = 'U'
    BEGIN

        UPDATE SQM_GENERAL.TBL_Features
        SET featureSummary = @i_featureSummary,
            featureDescription = @i_featureDescription,
            featuresAcceptanceCriteria = @i_featureAcceptanceCriteria, -- Nombre exacto de la tabla física
            featureOwner = @i_featureOwner,
            featureParentLink = @i_featureParentLink,
            featurePriority = @i_featurePriority,
            featureStartDate = @i_featureStartDate,
            featureDueDate = @i_featureDueDate,
            featureModificationDate = GETDATE(),
            featureModificatorId = @i_featureModificatorId,
            featureStatus = @i_featureStatus
        WHERE featureId = @i_featureId;

        PRINT 'FEATURE ACTUALIZADA CORRECTAMENTE';

    END

    -- LISTAR CON PAGINACION
    ELSE IF @w_Accion = 'S'
    BEGIN
        IF @i_PageNumber < 1 SET @i_PageNumber = 1;
        IF @i_RowsPerPage < 1 SET @i_RowsPerPage = 10;

        SELECT *
        FROM SQM_GENERAL.TBL_Features
        ORDER BY featureId
        OFFSET (@i_PageNumber - 1) * @i_RowsPerPage ROWS
        FETCH NEXT @i_RowsPerPage ROWS ONLY;
    END

END;
GO