USE [DB_SCRUM_PLANNING]
GO

CREATE OR ALTER PROCEDURE [SQM_GENERAL].[USP_Epics]
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
    @i_PageNumber INT = NULL,
    @i_RowsPerPage INT = NULL,
    @w_Accion CHAR(1),
    @o_Numero INT = NULL OUT,
    @o_MensajeTecnico VARCHAR(500) = NULL OUT,
    @o_MensajeUsuario VARCHAR(500) = NULL OUT
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @w_totalRows INT;
    DECLARE @w_startDate DATE;
    DECLARE @w_dueDate DATE;

    -- INSERTAR EPICA --
    IF @w_Accion = 'I'
    BEGIN
        IF ISNULL(@i_epicName,'') = ''
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL NOMBRE DE LA EPICA ES OBLIGATORIO';
        END;

        ELSE IF ISNULL(@i_epicSummary,'') = ''
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL RESUMEN DE LA EPICA ES OBLIGATORIO';
        END;

        ELSE IF ISNULL(@i_epicDescription,'') = ''
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'LA DESCRIPCION DE LA EPICA ES OBLIGATORIA';
        END;

        ELSE IF ISNULL(@i_epicOwner,0) = 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL RESPONSABLE DE LA EPICA ES OBLIGATORIO';
        END;

        ELSE IF ISNULL(@i_epicCreatorId,0) = 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL ID DEL CREADOR ES OBLIGATORIO';
        END;

        ELSE IF @i_epicStatus IS NULL
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL ESTADO ES OBLIGATORIO';
        END;

        ELSE IF NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[TBL_Users] (NOLOCK) WHERE userId = @i_epicOwner)
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL RESPONSABLE NO EXISTE';
        END;

        ELSE IF NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[TBL_Users] (NOLOCK) WHERE userId = @i_epicCreatorId)
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL CREADOR NO EXISTE';
        END;

        ELSE IF NOT EXISTS (SELECT 1 FROM [SQM_CATALOGS].[TBL_Status] (NOLOCK) WHERE statusId = @i_epicStatus)
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL ESTADO NO EXISTE';
        END;

        ELSE IF @i_epicPriority IS NOT NULL AND
                NOT EXISTS (SELECT 1 FROM [SQM_CATALOGS].[TBL_Priorities] (NOLOCK) WHERE priorityId = @i_epicPriority)
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'LA PRIORIDAD NO EXISTE';
        END;

        ELSE IF @i_epicStartDate IS NOT NULL AND @i_epicDueDate IS NOT NULL
                AND @i_epicDueDate < @i_epicStartDate
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'LA FECHA DE VENCIMIENTO NO PUEDE SER MENOR A LA FECHA DE INICIO';
        END;

        ELSE IF @i_epicParentLink IS NOT NULL AND
                NOT EXISTS (SELECT 1 FROM [SQM_GENERAL].[TBL_Initiatives] (NOLOCK)
                            WHERE initiativeId = @i_epicParentLink)
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'LA INICIATIVA PADRE NO EXISTE';
        END;

        ELSE
        BEGIN
            BEGIN TRANSACTION TRX_INS_EPIC;

            BEGIN TRY

                INSERT INTO [SQM_GENERAL].[TBL_Epics]
                (epicName, epicSummary, epicDescription, epicOwner, epicParentLink,
                 epicPriority, epicStartDate, epicDueDate, epicCreationDate,
                 epicCreatorId, epicStatus)
                VALUES
                (@i_epicName, @i_epicSummary, @i_epicDescription, @i_epicOwner, @i_epicParentLink,
                 @i_epicPriority, @i_epicStartDate, @i_epicDueDate, GETDATE(),
                 @i_epicCreatorId, @i_epicStatus);

                COMMIT TRANSACTION TRX_INS_EPIC;

                SET @o_Numero = 201;
                SET @o_MensajeUsuario = 'EPICA REGISTRADA CORRECTAMENTE';

            END TRY

            BEGIN CATCH

                IF @@TRANCOUNT > 0
                    ROLLBACK TRANSACTION TRX_INS_EPIC;

                SET @o_Numero = 500;
                SET @o_MensajeUsuario = 'ERROR AL REGISTRAR EPICA';
                SET @o_MensajeTecnico = CONCAT_WS(' - ', 'ERROR AL REGISTRAR EPICA', ERROR_PROCEDURE(), ERROR_LINE(), ERROR_MESSAGE());

            END CATCH
        END
    END

    -- ACTUALIZAR EPICA --
    ELSE IF @w_Accion = 'U'
    BEGIN
        -- Fechas finales (las nuevas, o las que ya estan guardadas por si no vienen)
        SELECT @w_startDate = COALESCE(@i_epicStartDate, epicStartDate),
               @w_dueDate   = COALESCE(@i_epicDueDate, epicDueDate)
        FROM [SQM_GENERAL].[TBL_Epics] (NOLOCK)
        WHERE epicId = @i_epicId;

        IF ISNULL(@i_epicId,0) = 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL ID DE LA EPICA ES OBLIGATORIO';
        END;

        ELSE IF ISNULL(@i_epicModificatorId,0) = 0
        BEGIN 
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL ID DEL MODIFICADOR ES OBLIGATORIO';
        END;

        ELSE IF @i_epicName IS NOT NULL AND @i_epicName = ''
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL NOMBRE DE LA EPICA NO PUEDE ESTAR VACIO';
        END;

        ELSE IF NOT EXISTS (SELECT 1 FROM [SQM_GENERAL].[TBL_Epics] (NOLOCK) WHERE epicId = @i_epicId)
        BEGIN
            SET @o_Numero = 404;
            SET @o_MensajeUsuario = 'LA EPICA NO EXISTE';
        END;

        ELSE IF @i_epicSummary IS NOT NULL AND @i_epicSummary = ''
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL RESUMEN DE LA EPICA NO PUEDE ESTAR VACIO'; 
        END;

        ELSE IF @i_epicDescription IS NOT NULL AND @i_epicDescription = ''
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'LA DESCRIPCION DE LA EPICA NO PUEDE ESTAR VACIA';
        END;

        ELSE IF NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[TBL_Users] (NOLOCK) WHERE userId = @i_epicModificatorId)
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL MODIFICADOR NO EXISTE';
        END;

        ELSE IF @i_epicOwner IS NOT NULL AND
                NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[TBL_Users] (NOLOCK) WHERE userId = @i_epicOwner)
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL RESPONSABLE NO EXISTE';
        END;

        ELSE IF @i_epicStatus IS NOT NULL AND
                NOT EXISTS (SELECT 1 FROM [SQM_CATALOGS].[TBL_Status] (NOLOCK) WHERE statusId = @i_epicStatus)
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL ESTADO NO EXISTE';
        END;

        ELSE IF @i_epicPriority IS NOT NULL AND
                NOT EXISTS (SELECT 1 FROM [SQM_CATALOGS].[TBL_Priorities] (NOLOCK) WHERE priorityId = @i_epicPriority)
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'LA PRIORIDAD NO EXISTE';
        END;

        ELSE IF @w_startDate IS NOT NULL AND @w_dueDate IS NOT NULL
                AND @w_dueDate < @w_startDate
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'LA FECHA DE VENCIMIENTO NO PUEDE SER MENOR A LA FECHA DE INICIO';
        END;

        ELSE IF @i_epicParentLink IS NOT NULL AND
                NOT EXISTS (SELECT 1 FROM [SQM_GENERAL].[TBL_Initiatives] (NOLOCK)
                            WHERE initiativeId = @i_epicParentLink)
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'LA INICIATIVA PADRE NO EXISTE';
        END;

        ELSE
        BEGIN
            BEGIN TRANSACTION TRX_UPD_EPIC;

            BEGIN TRY

                UPDATE [SQM_GENERAL].[TBL_Epics]
                SET epicName = COALESCE(@i_epicName, epicName),
                    epicSummary = COALESCE(@i_epicSummary, epicSummary),
                    epicDescription = COALESCE(@i_epicDescription, epicDescription),
                    epicOwner = COALESCE(@i_epicOwner, epicOwner),
                    epicParentLink = COALESCE(@i_epicParentLink, epicParentLink),
                    epicPriority = COALESCE(@i_epicPriority, epicPriority),
                    epicStartDate = COALESCE(@i_epicStartDate, epicStartDate),
                    epicDueDate = COALESCE(@i_epicDueDate, epicDueDate),
                    epicStatus = COALESCE(@i_epicStatus, epicStatus),
                    epicModificationDate = GETDATE(),
                    epicModificatorId = @i_epicModificatorId
                WHERE epicId = @i_epicId;

                COMMIT TRANSACTION TRX_UPD_EPIC;

                SET @o_Numero = 200;
                SET @o_MensajeUsuario = 'EPICA ACTUALIZADA CORRECTAMENTE';

            END TRY

            BEGIN CATCH

                IF @@TRANCOUNT > 0
                    ROLLBACK TRANSACTION TRX_UPD_EPIC;

                SET @o_Numero = 500;
                SET @o_MensajeUsuario = 'ERROR AL ACTUALIZAR EPICA';
                SET @o_MensajeTecnico = CONCAT_WS(' - ', 'ERROR AL ACTUALIZAR EPICA', ERROR_PROCEDURE(), ERROR_LINE(), ERROR_MESSAGE());

            END CATCH
        END
    END

    -- LISTAR EPICAS --
    ELSE IF @w_Accion = 'S'
    BEGIN
        SET @i_PageNumber = ISNULL(@i_PageNumber,1);
        SET @i_RowsPerPage = ISNULL(@i_RowsPerPage,10);

        IF @i_PageNumber < 1 SET @i_PageNumber = 1;
        IF @i_RowsPerPage < 1 SET @i_RowsPerPage = 10;

        BEGIN TRY

            SELECT epicId, epicName, epicSummary, epicDescription, epicOwner,
                   epicParentLink, epicPriority, epicStartDate, epicDueDate,
                   epicCreationDate, epicCreatorId, epicModificationDate,
                   epicModificatorId, epicStatus
            FROM [SQM_GENERAL].[TBL_Epics] (NOLOCK)
            ORDER BY epicId
            OFFSET (@i_PageNumber - 1) * @i_RowsPerPage ROWS
            FETCH NEXT @i_RowsPerPage ROWS ONLY;

            SET @w_totalRows = @@ROWCOUNT;

            IF (@w_totalRows > 0)
            BEGIN
                SET @o_Numero = 200;
                SET @o_MensajeUsuario = 'EPICAS LISTADAS CORRECTAMENTE';
            END
            ELSE
            BEGIN
                SET @o_Numero = 204;
                SET @o_MensajeUsuario = 'NO HAY MAS REGISTROS PARA LISTAR';
            END

        END TRY

        BEGIN CATCH

            SET @o_Numero = 500;
            SET @o_MensajeUsuario = 'ERROR AL LISTAR LAS EPICAS';
            SET @o_MensajeTecnico = CONCAT_WS(' - ', 'ERROR AL LISTAR EPICAS', ERROR_PROCEDURE(), ERROR_LINE(), ERROR_MESSAGE());

        END CATCH
    END

    -- ACCION INVALIDA --
    ELSE
    BEGIN
        SET @o_Numero = 405;
        SET @o_MensajeUsuario = 'METODO NO HABILITADO';
        SET @o_MensajeTecnico = 'EL PROCEDIMIENTO ALMACENADO NO TIENE HABILITADA ESA OPCION';
    END

END;
GO



 