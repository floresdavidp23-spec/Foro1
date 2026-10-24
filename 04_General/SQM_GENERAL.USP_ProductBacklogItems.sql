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
    @w_Accion CHAR(1) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @v_RowsAffected INT;
    DECLARE @v_Offset BIGINT;

    BEGIN TRY

        /*VALIDAR LA ACCION*/

        IF @w_Accion IS NULL
           OR @w_Accion NOT IN ('I', 'U', 'S')
        BEGIN
            ;THROW 50001,
                  'Accion no valida. Use I, U o S.',
                  1;
        END;


        /*INSERTAR*/

        IF @w_Accion = 'I'
        BEGIN

            -- Validar resumen obligatorio
            IF @i_PBISummary IS NULL
               OR LTRIM(RTRIM(@i_PBISummary)) = ''
            BEGIN
                ;THROW 50002,
                      'El resumen del elemento es obligatorio.',
                      1;
            END;

            -- Validar creador
            IF @i_PBICreatorId IS NULL
               OR @i_PBICreatorId <= 0
            BEGIN
                ;THROW 50003,
                      'Debe proporcionar un ID de creador valido.',
                      1;
            END;

            -- Validar estado obligatorio
            IF @i_PBIStatus IS NULL
               OR @i_PBIStatus < 0
            BEGIN
                ;THROW 50004,
                      'El estado es obligatorio y no puede ser negativo.',
                      1;
            END;

            -- Validar propietario, si se proporciona
            IF @i_PBIOwner IS NOT NULL
               AND @i_PBIOwner <= 0
            BEGIN
                ;THROW 50005,
                      'El ID del propietario debe ser positivo.',
                      1;
            END;

            -- Validar enlace al elemento padre
            IF @i_PBIParentLink IS NOT NULL
               AND @i_PBIParentLink <= 0
            BEGIN
                ;THROW 50006,
                      'El ID del elemento padre debe ser positivo.',
                      1;
            END;

            -- Validar puntos de historia
            IF @i_PBIStoryPoint IS NOT NULL
               AND @i_PBIStoryPoint < 0
            BEGIN
                ;THROW 50007,
                      'Los puntos de historia no pueden ser negativos.',
                      1;
            END;

            -- Validar prioridad
            IF @i_PBIPriority IS NOT NULL
               AND @i_PBIPriority < 0
            BEGIN
                ;THROW 50008,
                      'La prioridad no puede ser negativa.',
                      1;
            END;

            -- Validar fechas
            IF @i_PBIStartDate IS NOT NULL
               AND @i_PBIDueDate IS NOT NULL
               AND @i_PBIStartDate > @i_PBIDueDate
            BEGIN
                THROW 50009,
                      'La fecha de inicio no puede ser posterior a la fecha de vencimiento.',
                      1;
            END;

            -- Insertar registro
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
                LTRIM(RTRIM(@i_PBISummary)),
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

            SET @v_RowsAffected = @@ROWCOUNT;

            IF @v_RowsAffected = 0
            BEGIN
                ;THROW 50010,
                      'No se pudo registrar el elemento.',
                      1;
            END;

            PRINT 'ELEMENTO DEL PRODUCT BACKLOG REGISTRADO CORRECTAMENTE';

        END


        /*ACTUALIZAR*/

        ELSE IF @w_Accion = 'U'
        BEGIN

            -- Validar ID obligatorio
            IF @i_PBIId IS NULL OR @i_PBIId <= 0
            BEGIN
                ;THROW 50011,
                      'Debe proporcionar un ID valido para actualizar.',
                      1;
            END;

            -- Validar que el registro exista
            IF NOT EXISTS
            (
                SELECT 1
                FROM SQM_GENERAL.TBL_ProductBacklogItems
                WHERE PBIId = @i_PBIId
            )
            BEGIN
                ;THROW 50012,
                      'El elemento del Product Backlog no existe.',
                      1;
            END;

            -- Validar resumen obligatorio
            IF @i_PBISummary IS NULL
               OR LTRIM(RTRIM(@i_PBISummary)) = ''
            BEGIN
                ;THROW 50013,
                      'El resumen del elemento es obligatorio.',
                      1;
            END;

            -- Validar modificador
            IF @i_PBIModificatorId IS NULL
               OR @i_PBIModificatorId <= 0
            BEGIN
                ;THROW 50014,
                      'Debe proporcionar un ID de modificador valido.',
                      1;
            END;

            -- Validar estado
            IF @i_PBIStatus IS NULL
               OR @i_PBIStatus < 0
            BEGIN
                ;THROW 50015,
                      'El estado es obligatorio y no puede ser negativo.',
                      1;
            END;

            -- Validar propietario, si se proporciona
            IF @i_PBIOwner IS NOT NULL
               AND @i_PBIOwner <= 0
            BEGIN
                ;THROW 50016,
                      'El ID del propietario debe ser positivo.',
                      1;
            END;

            -- Validar elemento padre
            IF @i_PBIParentLink IS NOT NULL
               AND @i_PBIParentLink <= 0
            BEGIN
                ;THROW 50017,
                      'El ID del elemento padre debe ser positivo.',
                      1;
            END;

            -- Evitar que el elemento sea su propio padre
            IF @i_PBIParentLink = @i_PBIId
            BEGIN
                ;THROW 50018,
                      'Un elemento no puede ser su propio padre.',
                      1;
            END;

            -- Validar puntos de historia
            IF @i_PBIStoryPoint IS NOT NULL
               AND @i_PBIStoryPoint < 0
            BEGIN
                ;THROW 50019,
                      'Los puntos de historia no pueden ser negativos.',
                      1;
            END;

            -- Validar prioridad
            IF @i_PBIPriority IS NOT NULL
               AND @i_PBIPriority < 0
            BEGIN
                ;THROW 50020,
                      'La prioridad no puede ser negativa.',
                      1;
            END;

            -- Validar fechas
            IF @i_PBIStartDate IS NOT NULL
               AND @i_PBIDueDate IS NOT NULL
               AND @i_PBIStartDate > @i_PBIDueDate
            BEGIN
                ;THROW 50021,
                      'La fecha de inicio no puede ser posterior a la fecha de vencimiento.',
                      1;
            END;

            -- Actualizar registro
            UPDATE SQM_GENERAL.TBL_ProductBacklogItems
            SET
                PBISummary = LTRIM(RTRIM(@i_PBISummary)),
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

            SET @v_RowsAffected = @@ROWCOUNT;

            IF @v_RowsAffected = 0
            BEGIN
                ;THROW 50022,
                      'No se pudo actualizar el elemento.',
                      1;
            END;

            PRINT 'ELEMENTO DEL PRODUCT BACKLOG ACTUALIZADO CORRECTAMENTE';

        END


        /*4. LISTAR CON PAGINACION */

        ELSE IF @w_Accion = 'S'
        BEGIN

            -- Validar numero de pagina
            IF @i_PageNumber IS NULL OR @i_PageNumber < 1
            BEGIN
                SET @i_PageNumber = 1;
            END;

            -- Validar filas por pagina
            IF @i_RowsPerPage IS NULL OR @i_RowsPerPage < 1
            BEGIN
                SET @i_RowsPerPage = 10;
            END;

            -- Limitar cantidad de filas
            IF @i_RowsPerPage > 100
            BEGIN
                ;THROW 50023,
                      'El maximo permitido es de 100 filas por pagina.',
                      1;
            END;

            -- Calcular desplazamiento evitando overflow
            SET @v_Offset =
                CAST(@i_PageNumber - 1 AS BIGINT)
                * CAST(@i_RowsPerPage AS BIGINT);

            -- Consultar registros
            SELECT *
            FROM SQM_GENERAL.TBL_ProductBacklogItems
            ORDER BY PBIId
            OFFSET @v_Offset ROWS
            FETCH NEXT @i_RowsPerPage ROWS ONLY;

        END;

    END TRY

    BEGIN CATCH

        -- Propagar el error original
        THROW;

    END CATCH;

END;
GO
