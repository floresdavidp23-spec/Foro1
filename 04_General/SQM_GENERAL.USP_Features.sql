USE [DB_SCRUM_PLANNING]
GO

CREATE OR ALTER PROCEDURE [SQM_GENERAL].[USP_Features]
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

    -- INSERTAR FEATURE --
    IF @w_Accion = 'I'
    BEGIN
        IF ISNULL(@i_featureSummary,'') = ''
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL RESUMEN DE LA FEATURE ES OBLIGATORIO';
        END;

        ELSE IF ISNULL(@i_featureDescription,'') = ''
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'LA DESCRIPCION DE LA FEATURE ES OBLIGATORIA';
        END;

        ELSE IF ISNULL(@i_featureAcceptanceCriteria,'') = ''
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'LOS CRITERIOS DE ACEPTACION SON OBLIGATORIOS';
        END;

        ELSE IF ISNULL(@i_featureParentLink,0) = 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'LA EPICA PADRE ES OBLIGATORIA';
        END;

        ELSE IF ISNULL(@i_featureOwner,0) = 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL RESPONSABLE DE LA FEATURE ES OBLIGATORIO';
        END;

        ELSE IF ISNULL(@i_featureCreatorId,0) = 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL ID DEL CREADOR ES OBLIGATORIO';
        END;

        ELSE IF @i_featureStatus IS NULL
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL ESTADO ES OBLIGATORIO';
        END;

        ELSE IF NOT EXISTS (SELECT 1 FROM [SQM_GENERAL].[TBL_Epics] WHERE epicId = @i_featureParentLink)
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'LA EPICA PADRE NO EXISTE';
        END;

        ELSE IF NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[TBL_Users] WHERE userId = @i_featureOwner)
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL RESPONSABLE NO EXISTE';
        END;

        ELSE IF NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[TBL_Users] WHERE userId = @i_featureCreatorId)
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL CREADOR NO EXISTE';
        END;

        ELSE IF NOT EXISTS (SELECT 1 FROM [SQM_CATALOGS].[TBL_Status] WHERE statusId = @i_featureStatus)
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL ESTADO NO EXISTE';
        END;

        ELSE IF @i_featurePriority IS NOT NULL AND
                NOT EXISTS (SELECT 1 FROM [SQM_CATALOGS].[TBL_Priorities] WHERE priorityId = @i_featurePriority)
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'LA PRIORIDAD NO EXISTE';
        END;

        ELSE IF @i_featureStartDate IS NOT NULL AND @i_featureDueDate IS NOT NULL
                AND @i_featureDueDate < @i_featureStartDate
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'LA FECHA DE VENCIMIENTO NO PUEDE SER MENOR A LA FECHA DE INICIO';
        END;

        ELSE
        BEGIN
            BEGIN TRANSACTION TRX_INS_FEATURE;

            BEGIN TRY

                INSERT INTO [SQM_GENERAL].[TBL_Features]
                (featureSummary, featureDescription, featuresAcceptanceCriteria, featureParentLink,
                 featureOwner, featureStartDate, featureDueDate, featurePriority,
                 featureCreationDate, featureCreatorId, featureStatus)
                VALUES
                (@i_featureSummary, @i_featureDescription, @i_featureAcceptanceCriteria, @i_featureParentLink,
                 @i_featureOwner, @i_featureStartDate, @i_featureDueDate, @i_featurePriority,
                 GETDATE(), @i_featureCreatorId, @i_featureStatus);

                COMMIT TRANSACTION TRX_INS_FEATURE;

                SET @o_Numero = 201;
                SET @o_MensajeUsuario = 'FEATURE REGISTRADA CORRECTAMENTE';

            END TRY

            BEGIN CATCH

                IF @@TRANCOUNT > 0
                    ROLLBACK TRANSACTION TRX_INS_FEATURE;

                SET @o_Numero = 500;
                SET @o_MensajeUsuario = 'ERROR AL REGISTRAR FEATURE';
                SET @o_MensajeTecnico = CONCAT_WS(' - ', 'ERROR AL REGISTRAR FEATURE', ERROR_PROCEDURE(), ERROR_LINE(), ERROR_MESSAGE());

            END CATCH
        END
    END

    -- ACTUALIZAR FEATURE --
    ELSE IF @w_Accion = 'U'
    BEGIN
        -- Fechas finales (las nuevas, o las que ya estan guardadas si no vienen)
        SELECT @w_startDate = COALESCE(@i_featureStartDate, featureStartDate),
               @w_dueDate   = COALESCE(@i_featureDueDate, featureDueDate)
        FROM [SQM_GENERAL].[TBL_Features] (NOLOCK)
        WHERE featureId = @i_featureId;

        IF ISNULL(@i_featureId,0) = 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL ID DE LA FEATURE ES OBLIGATORIO';
        END;

        ELSE IF ISNULL(@i_featureModificatorId,0) = 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL ID DEL MODIFICADOR ES OBLIGATORIO';
        END;

        ELSE IF @i_featureSummary IS NOT NULL AND @i_featureSummary = ''
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL RESUMEN DE LA FEATURE NO PUEDE ESTAR VACIO';
        END;

        ELSE IF @i_featureDescription IS NOT NULL AND @i_featureDescription = ''
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'LA DESCRIPCION DE LA FEATURE NO PUEDE ESTAR VACIA';
        END;

        ELSE IF @i_featureAcceptanceCriteria IS NOT NULL AND @i_featureAcceptanceCriteria = ''
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'LOS CRITERIOS DE ACEPTACION NO PUEDEN ESTAR VACIOS';
        END;

        ELSE IF NOT EXISTS (SELECT 1 FROM [SQM_GENERAL].[TBL_Features] WHERE featureId = @i_featureId)
        BEGIN
            SET @o_Numero = 404;
            SET @o_MensajeUsuario = 'LA FEATURE NO EXISTE';
        END;

        ELSE IF NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[TBL_Users] WHERE userId = @i_featureModificatorId)
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL MODIFICADOR NO EXISTE';
        END;

        ELSE IF @i_featureParentLink IS NOT NULL AND
                NOT EXISTS (SELECT 1 FROM [SQM_GENERAL].[TBL_Epics] WHERE epicId = @i_featureParentLink)
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'LA EPICA PADRE NO EXISTE';
        END;

        ELSE IF @i_featureOwner IS NOT NULL AND
                NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[TBL_Users] WHERE userId = @i_featureOwner)
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL RESPONSABLE NO EXISTE';
        END;

        ELSE IF @i_featureStatus IS NOT NULL AND
                NOT EXISTS (SELECT 1 FROM [SQM_CATALOGS].[TBL_Status] WHERE statusId = @i_featureStatus)
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL ESTADO NO EXISTE';
        END;

        ELSE IF @i_featurePriority IS NOT NULL AND
                NOT EXISTS (SELECT 1 FROM [SQM_CATALOGS].[TBL_Priorities] WHERE priorityId = @i_featurePriority)
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

        ELSE
        BEGIN
            BEGIN TRANSACTION TRX_UPD_FEATURE;

            BEGIN TRY

                UPDATE [SQM_GENERAL].[TBL_Features]
                SET featureSummary = COALESCE(@i_featureSummary, featureSummary),
                    featureDescription = COALESCE(@i_featureDescription, featureDescription),
                    featuresAcceptanceCriteria = COALESCE(@i_featureAcceptanceCriteria, featuresAcceptanceCriteria),
                    featureParentLink = COALESCE(@i_featureParentLink, featureParentLink),
                    featureOwner = COALESCE(@i_featureOwner, featureOwner),
                    featureStartDate = COALESCE(@i_featureStartDate, featureStartDate),
                    featureDueDate = COALESCE(@i_featureDueDate, featureDueDate),
                    featurePriority = COALESCE(@i_featurePriority, featurePriority),
                    featureStatus = COALESCE(@i_featureStatus, featureStatus),
                    featureModificationDate = GETDATE(),
                    featureModificatorId = @i_featureModificatorId
                WHERE featureId = @i_featureId;

                COMMIT TRANSACTION TRX_UPD_FEATURE;

                SET @o_Numero = 200;
                SET @o_MensajeUsuario = 'FEATURE ACTUALIZADA CORRECTAMENTE';

            END TRY

            BEGIN CATCH

                IF @@TRANCOUNT > 0
                    ROLLBACK TRANSACTION TRX_UPD_FEATURE;

                SET @o_Numero = 500;
                SET @o_MensajeUsuario = 'ERROR AL ACTUALIZAR FEATURE';
                SET @o_MensajeTecnico = CONCAT_WS(' - ', 'ERROR AL ACTUALIZAR FEATURE', ERROR_PROCEDURE(), ERROR_LINE(), ERROR_MESSAGE());

            END CATCH
        END
    END

    -- LISTAR FEATURES --
    ELSE IF @w_Accion = 'S'
    BEGIN
        SET @i_PageNumber = ISNULL(@i_PageNumber,1);
        SET @i_RowsPerPage = ISNULL(@i_RowsPerPage,10);

        IF @i_PageNumber < 1 SET @i_PageNumber = 1;
        IF @i_RowsPerPage < 1 SET @i_RowsPerPage = 10;

        BEGIN TRY

            SELECT featureId, featureSummary, featureDescription, featuresAcceptanceCriteria,
                   featureParentLink, featureOwner, featureStartDate, featureDueDate,
                   featurePriority, featureCreationDate, featureCreatorId,
                   featureModificationDate, featureModificatorId, featureStatus
            FROM [SQM_GENERAL].[TBL_Features] (NOLOCK)
            ORDER BY featureId
            OFFSET (@i_PageNumber - 1) * @i_RowsPerPage ROWS
            FETCH NEXT @i_RowsPerPage ROWS ONLY;

            SET @w_totalRows = @@ROWCOUNT;

            IF (@w_totalRows > 0)
            BEGIN
                SET @o_Numero = 200;
                SET @o_MensajeUsuario = 'FEATURES LISTADAS CORRECTAMENTE';
            END
            ELSE
            BEGIN
                SET @o_Numero = 204;
                SET @o_MensajeUsuario = 'NO HAY MAS REGISTROS PARA LISTAR';
            END

        END TRY

        BEGIN CATCH

            SET @o_Numero = 500;
            SET @o_MensajeUsuario = 'ERROR AL LISTAR LAS FEATURES';
            SET @o_MensajeTecnico = CONCAT_WS(' - ', 'ERROR AL LISTAR FEATURES', ERROR_PROCEDURE(), ERROR_LINE(), ERROR_MESSAGE());

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