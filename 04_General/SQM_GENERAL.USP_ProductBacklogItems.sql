--SQM_GENERAL.USP_ProductBacklogItems

USE DB_SCRUM_PLANNING;
GO

CREATE OR ALTER PROCEDURE SQM_GENERAL.USP_ProductBacklogItems
(
    @i_PBIId INT = NULL,
    @i_PBISummary VARCHAR(500) = NULL,
    @i_PBIDescription VARCHAR(2000) = NULL,
    @i_PBIAcceptanceCriteria VARCHAR(4000) = NULL,
    @i_PBIOwner INT = NULL,
    @i_PBIParentLink INT = NULL,
    @i_PBIStoryPoint INT = NULL,
    @i_PBIStartDate DATE = NULL,
    @i_PBIDueDate DATE = NULL,
    @i_PBIPriority INT = NULL,
    @i_PBICreatorId INT = NULL,
    @i_PBIModificatorId INT = NULL,
    @i_PBIStatus INT = NULL,
    @i_PageNumber INT = 1,
    @i_RowsPerPage INT = 10,
    @w_Accion CHAR(1)
)
AS
BEGIN

    -- INSERTAR
    IF @w_Accion = 'I'
    BEGIN

        INSERT INTO SQM_GENERAL.TBL_ProductBacklogItems
        (
            PBISummary,
            PBIDescription,
            PBIsAcceptanceCriteria,
            PBIOwner,
            PBIParentLink,
            PBIStoryPoint,
            PBIStartDate,
            PBIDueDate,
            PBIPriority,
            PBICreationDate,
            PBICreatorId,
            PBIModificationDate,
            PBIModificatorId,
            PBIStatus
        )
        VALUES
        (
            @i_PBISummary,
            @i_PBIDescription,
            @i_PBIAcceptanceCriteria,
            @i_PBIOwner,
            @i_PBIParentLink,
            @i_PBIStoryPoint,
            @i_PBIStartDate,
            @i_PBIDueDate,
            @i_PBIPriority,
            GETDATE(),
            @i_PBICreatorId,
            NULL,
            NULL,
            @i_PBIStatus
        );

        PRINT 'ELEMENTO DEL PRODUCT BACKLOG REGISTRADO CORRECTAMENTE';

    END

    -- ACTUALIZAR
    ELSE IF @w_Accion = 'U'
    BEGIN

        UPDATE SQM_GENERAL.TBL_ProductBacklogItems
        SET PBISummary = @i_PBISummary,
            PBIDescription = @i_PBIDescription,
            PBIsAcceptanceCriteria = @i_PBIAcceptanceCriteria,
            PBIOwner = @i_PBIOwner,
            PBIParentLink = @i_PBIParentLink,
            PBIStoryPoint = @i_PBIStoryPoint,
            PBIStartDate = @i_PBIStartDate,
            PBIDueDate = @i_PBIDueDate,
            PBIPriority = @i_PBIPriority,
            PBIModificationDate = GETDATE(),
            PBIModificatorId = @i_PBIModificatorId,
            PBIStatus = @i_PBIStatus
        WHERE PBIId = @i_PBIId;

        PRINT 'ELEMENTO DEL PRODUCT BACKLOG ACTUALIZADO CORRECTAMENTE';

    END

    -- LISTAR CON PAGINACION
    ELSE IF @w_Accion = 'S'
    BEGIN
        IF @i_PageNumber < 1 SET @i_PageNumber = 1;
        IF @i_RowsPerPage < 1 SET @i_RowsPerPage = 10;

        SELECT *
        FROM SQM_GENERAL.TBL_ProductBacklogItems
        ORDER BY PBIId
        OFFSET (@i_PageNumber - 1) * @i_RowsPerPage ROWS
        FETCH NEXT @i_RowsPerPage ROWS ONLY;
    END

END;
GO