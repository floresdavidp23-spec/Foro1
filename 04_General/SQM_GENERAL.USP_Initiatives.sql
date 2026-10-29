USE [DB_SCRUM_PLANNING]
GO

CREATE OR ALTER PROCEDURE [SQM_GENERAL].[USP_Initiatives]
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
    DECLARE @w_endDate DATE;

    -- INSERTAR INICIATIVA --
    IF @w_Accion = 'I'
    BEGIN
        IF ISNULL(@i_initiativeSummary,'') = ''
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL RESUMEN DE LA INICIATIVA ES OBLIGATORIO';
        END;

        ELSE IF ISNULL(@i_initiativeDescription,'') = ''
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'LA DESCRIPCION DE LA INICIATIVA ES OBLIGATORIA';
        END;

        ELSE IF ISNULL(@i_initiativeOwner,0) = 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL RESPONSABLE DE LA INICIATIVA ES OBLIGATORIO';
        END;

        ELSE IF ISNULL(@i_initiativeBusinessValue,0) = 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL VALOR DE NEGOCIO ES OBLIGATORIO';
        END;

        ELSE IF ISNULL(@i_initiativeCreatorId,0) = 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL ID DEL CREADOR ES OBLIGATORIO';
        END;

        ELSE IF @i_initiativeStatus IS NULL
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL ESTADO ES OBLIGATORIO';
        END;

        ELSE IF NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[TBL_Users] WHERE userId = @i_initiativeOwner)
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL RESPONSABLE NO EXISTE';
        END;

        ELSE IF NOT EXISTS (SELECT 1 FROM [SQM_CATALOGS].[TBL_BusinessValues] WHERE BusinessValueId = @i_initiativeBusinessValue)
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL VALOR DE NEGOCIO NO EXISTE';
        END;

        ELSE IF NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[TBL_Users] WHERE userId = @i_initiativeCreatorId)
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL CREADOR NO EXISTE';
        END;

        ELSE IF NOT EXISTS (SELECT 1 FROM [SQM_CATALOGS].[TBL_Status] WHERE statusId = @i_initiativeStatus)
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL ESTADO NO EXISTE';
        END;

        ELSE IF @i_initiativeTargetStart IS NOT NULL AND @i_initiativeTargetEnd IS NOT NULL
                AND @i_initiativeTargetEnd < @i_initiativeTargetStart
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'LA FECHA FINAL NO PUEDE SER MENOR A LA FECHA DE INICIO';
        END;

        ELSE
        BEGIN
            BEGIN TRANSACTION TRX_INS_INITIATIVE;

            BEGIN TRY

                INSERT INTO [SQM_GENERAL].[TBL_Initiatives]
                (initiativeSummary, initiativeDescription, initiativeOwner, initiativeGoals,
                 initiativeBusinessValue, initiativeTargetStart, initiativeTargetEnd,
                 initiativeCreationDate, initiativeCreatorId, initiativeStatus)
                VALUES
                (@i_initiativeSummary, @i_initiativeDescription, @i_initiativeOwner, @i_initiativeGoals,
                 @i_initiativeBusinessValue, @i_initiativeTargetStart, @i_initiativeTargetEnd,
                 GETDATE(), @i_initiativeCreatorId, @i_initiativeStatus);

                COMMIT TRANSACTION TRX_INS_INITIATIVE;

                SET @o_Numero = 201;
                SET @o_MensajeUsuario = 'INICIATIVA REGISTRADA CORRECTAMENTE';

            END TRY

            BEGIN CATCH

                IF @@TRANCOUNT > 0
                    ROLLBACK TRANSACTION TRX_INS_INITIATIVE;

                SET @o_Numero = 500;
                SET @o_MensajeUsuario = 'ERROR AL REGISTRAR INICIATIVA';
                SET @o_MensajeTecnico = CONCAT_WS(' - ', 'ERROR AL REGISTRAR INICIATIVA', ERROR_PROCEDURE(), ERROR_LINE(), ERROR_MESSAGE());

            END CATCH
        END
    END

    -- ACTUALIZAR INICIATIVA --
    ELSE IF @w_Accion = 'U'
    BEGIN
        -- Fechas finales (las nuevas, o las que ya estan guardadas si no vienen)
        SELECT @w_startDate = COALESCE(@i_initiativeTargetStart, initiativeTargetStart),
               @w_endDate   = COALESCE(@i_initiativeTargetEnd, initiativeTargetEnd)
        FROM [SQM_GENERAL].[TBL_Initiatives] (NOLOCK)
        WHERE initiativeId = @i_initiativeId;

        IF ISNULL(@i_initiativeId,0) = 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL ID DE LA INICIATIVA ES OBLIGATORIO';
        END;

        ELSE IF ISNULL(@i_initiativeModificatorId,0) = 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL ID DEL MODIFICADOR ES OBLIGATORIO';
        END;

        ELSE IF @i_initiativeSummary IS NOT NULL AND @i_initiativeSummary = ''
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL RESUMEN DE LA INICIATIVA NO PUEDE ESTAR VACIO';
        END;

        ELSE IF @i_initiativeDescription IS NOT NULL AND @i_initiativeDescription = ''
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'LA DESCRIPCION DE LA INICIATIVA NO PUEDE ESTAR VACIA';
        END;

        ELSE IF NOT EXISTS (SELECT 1 FROM [SQM_GENERAL].[TBL_Initiatives] WHERE initiativeId = @i_initiativeId)
        BEGIN
            SET @o_Numero = 404;
            SET @o_MensajeUsuario = 'LA INICIATIVA NO EXISTE';
        END;

        ELSE IF NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[TBL_Users] WHERE userId = @i_initiativeModificatorId)
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL MODIFICADOR NO EXISTE';
        END;

        ELSE IF @i_initiativeOwner IS NOT NULL AND
                NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[TBL_Users] WHERE userId = @i_initiativeOwner)
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL RESPONSABLE NO EXISTE';
        END;

        ELSE IF @i_initiativeBusinessValue IS NOT NULL AND
                NOT EXISTS (SELECT 1 FROM [SQM_CATALOGS].[TBL_BusinessValues] WHERE BusinessValueId = @i_initiativeBusinessValue)
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL VALOR DE NEGOCIO NO EXISTE';
        END;

        ELSE IF @i_initiativeStatus IS NOT NULL AND
                NOT EXISTS (SELECT 1 FROM [SQM_CATALOGS].[TBL_Status] WHERE statusId = @i_initiativeStatus)
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL ESTADO NO EXISTE';
        END;

        ELSE IF @w_startDate IS NOT NULL AND @w_endDate IS NOT NULL
                AND @w_endDate < @w_startDate
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'LA FECHA FINAL NO PUEDE SER MENOR A LA FECHA DE INICIO';
        END;

        ELSE
        BEGIN
            BEGIN TRANSACTION TRX_UPD_INITIATIVE;

            BEGIN TRY

                UPDATE [SQM_GENERAL].[TBL_Initiatives]
                SET initiativeSummary = COALESCE(@i_initiativeSummary, initiativeSummary),
                    initiativeDescription = COALESCE(@i_initiativeDescription, initiativeDescription),
                    initiativeOwner = COALESCE(@i_initiativeOwner, initiativeOwner),
                    initiativeGoals = COALESCE(@i_initiativeGoals, initiativeGoals),
                    initiativeBusinessValue = COALESCE(@i_initiativeBusinessValue, initiativeBusinessValue),
                    initiativeTargetStart = COALESCE(@i_initiativeTargetStart, initiativeTargetStart),
                    initiativeTargetEnd = COALESCE(@i_initiativeTargetEnd, initiativeTargetEnd),
                    initiativeStatus = COALESCE(@i_initiativeStatus, initiativeStatus),
                    initiativeModificationDate = GETDATE(),
                    initiativeModificatorId = @i_initiativeModificatorId
                WHERE initiativeId = @i_initiativeId;

                COMMIT TRANSACTION TRX_UPD_INITIATIVE;

                SET @o_Numero = 200;
                SET @o_MensajeUsuario = 'INICIATIVA ACTUALIZADA CORRECTAMENTE';

            END TRY

            BEGIN CATCH

                IF @@TRANCOUNT > 0
                    ROLLBACK TRANSACTION TRX_UPD_INITIATIVE;

                SET @o_Numero = 500;
                SET @o_MensajeUsuario = 'ERROR AL ACTUALIZAR INICIATIVA';
                SET @o_MensajeTecnico = CONCAT_WS(' - ', 'ERROR AL ACTUALIZAR INICIATIVA', ERROR_PROCEDURE(), ERROR_LINE(), ERROR_MESSAGE());

            END CATCH
        END
    END

    -- LISTAR INICIATIVAS --
    ELSE IF @w_Accion = 'S'
    BEGIN
        SET @i_PageNumber = ISNULL(@i_PageNumber,1);
        SET @i_RowsPerPage = ISNULL(@i_RowsPerPage,10);

        IF @i_PageNumber < 1 SET @i_PageNumber = 1;
        IF @i_RowsPerPage < 1 SET @i_RowsPerPage = 10;

        BEGIN TRY

            SELECT initiativeId, initiativeSummary, initiativeDescription, initiativeOwner,
                   initiativeGoals, initiativeBusinessValue, initiativeTargetStart,
                   initiativeTargetEnd, initiativeCreationDate, initiativeCreatorId,
                   initiativeModificationDate, initiativeModificatorId, initiativeStatus
            FROM [SQM_GENERAL].[TBL_Initiatives] (NOLOCK)
            ORDER BY initiativeId
            OFFSET (@i_PageNumber - 1) * @i_RowsPerPage ROWS
            FETCH NEXT @i_RowsPerPage ROWS ONLY;

            SET @w_totalRows = @@ROWCOUNT;

            IF (@w_totalRows > 0)
            BEGIN
                SET @o_Numero = 200;
                SET @o_MensajeUsuario = 'INICIATIVAS LISTADAS CORRECTAMENTE';
            END
            ELSE
            BEGIN
                SET @o_Numero = 204;
                SET @o_MensajeUsuario = 'NO HAY MAS REGISTROS PARA LISTAR';
            END

        END TRY

        BEGIN CATCH

            SET @o_Numero = 500;
            SET @o_MensajeUsuario = 'ERROR AL LISTAR LAS INICIATIVAS';
            SET @o_MensajeTecnico = CONCAT_WS(' - ', 'ERROR AL LISTAR INICIATIVAS', ERROR_PROCEDURE(), ERROR_LINE(), ERROR_MESSAGE());

        END CATCH
    END

    -- ACCION INVALIDA --
    ELSE
    BEGIN
        SET @o_Numero = 405;
        SET @o_MensajeUsuario = 'METODO NO HABILITADO';
        SET @o_MensajeTecnico = 'EL PROCEDIMIENTO ALMACENADO NO TIENE HABILITADA ESA OPCION';
    END

    SELECT @o_Numero AS o_Numero,
           @o_MensajeUsuario AS o_MensajeUsuario,
           @o_MensajeTecnico AS o_MensajeTecnico


END;
GO