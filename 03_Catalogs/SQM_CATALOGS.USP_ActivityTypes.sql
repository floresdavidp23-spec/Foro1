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
    @w_Accion CHAR(1),
    @o_Numero INT = NULL OUT,
    @o_MensajeTecnico VARCHAR(500) = NULL OUT,
    @o_MensajeUsuario VARCHAR(500) = NULL OUT
)
AS
BEGIN
    DECLARE @w_totalRows INT;

    -- ACCIÓN: INSERTAR ('I')
    IF @w_Accion = 'I'
    BEGIN
        IF ISNULL(@i_activityTypeName, '') = ''
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL NOMBRE DEL TIPO DE ACTIVIDAD ES OBLIGATORIO';
        END
        ELSE IF ISNULL(@i_activityTypeCreatorId, 0) = 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL ID DEL CREADOR ES OBLIGATORIO';
        END
        ELSE IF NOT EXISTS (
            SELECT 1 FROM SQM_SECURITY.TBL_Users WHERE userId = @i_activityTypeCreatorId AND userEnable = 1
        )
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL USUARIO CREADOR NO EXISTE O ESTA DESHABILITADO';
        END
        ELSE IF EXISTS (
            SELECT 1 FROM SQM_CATALOGS.TBL_ActivityTypes WHERE activityTypeName = @i_activityTypeName
        )
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL TIPO DE ACTIVIDAD YA EXISTE';
        END
        ELSE
        BEGIN
            BEGIN TRANSACTION TRX_INS_ACT_TYPE;
            BEGIN TRY
                INSERT INTO SQM_CATALOGS.TBL_ActivityTypes
                (
                    activityTypeName,
                    activityTypeCreationDate,
                    activityTypeCreatorId,
                    activityTypeModificationDate,
                    activityTypeModificatorId,
                    activityTypeEnable
                )
                VALUES
                (
                    @i_activityTypeName,
                    GETDATE(),
                    @i_activityTypeCreatorId,
                    NULL,
                    NULL,
                    1
                );

                COMMIT TRANSACTION TRX_INS_ACT_TYPE;
                SET @o_Numero = 201;
                SET @o_MensajeUsuario = 'TIPO DE ACTIVIDAD REGISTRADO CORRECTAMENTE';
            END TRY
            BEGIN CATCH
                IF @@TRANCOUNT > 0
                    ROLLBACK TRANSACTION TRX_INS_ACT_TYPE;

                SET @o_Numero = 500;
                SET @o_MensajeUsuario = 'ERROR AL REGISTRAR TIPO DE ACTIVIDAD';
                SET @o_MensajeTecnico = CONCAT_WS(
                    ' - ',
                    'ERROR AL REGISTRAR TIPO DE ACTIVIDAD',
                    ERROR_PROCEDURE(),
                    ERROR_LINE(),
                    ERROR_MESSAGE()
                );
            END CATCH
        END
    END

    -- ACCIÓN: ACTUALIZAR ('U')
    ELSE IF @w_Accion = 'U'
    BEGIN
        IF ISNULL(@i_activityTypeId, 0) = 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL ID DEL TIPO DE ACTIVIDAD ES OBLIGATORIO';
        END
        ELSE IF ISNULL(@i_activityTypeModificatorId, 0) = 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL ID DEL MODIFICADOR ES OBLIGATORIO';
        END
        ELSE IF NOT EXISTS (
            SELECT 1 FROM SQM_CATALOGS.TBL_ActivityTypes WHERE activityTypeId = @i_activityTypeId
        )
        BEGIN
            SET @o_Numero = 404;
            SET @o_MensajeUsuario = 'EL TIPO DE ACTIVIDAD NO EXISTE';
        END
        ELSE IF NOT EXISTS (
            SELECT 1 FROM SQM_SECURITY.TBL_Users WHERE userId = @i_activityTypeModificatorId AND userEnable = 1
        )
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL USUARIO MODIFICADOR NO EXISTE O ESTA DESHABILITADO';
        END
        ELSE IF @i_activityTypeName IS NOT NULL AND EXISTS (
            SELECT 1 FROM SQM_CATALOGS.TBL_ActivityTypes 
            WHERE activityTypeName = @i_activityTypeName AND activityTypeId <> @i_activityTypeId
        )
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL NOMBRE DEL TIPO DE ACTIVIDAD YA EXISTE EN OTRO REGISTRO';
        END
        ELSE
        BEGIN
            BEGIN TRANSACTION TRX_UPD_ACT_TYPE;
            BEGIN TRY
                UPDATE SQM_CATALOGS.TBL_ActivityTypes
                SET activityTypeName = COALESCE(@i_activityTypeName, activityTypeName),
                    activityTypeModificationDate = GETDATE(),
                    activityTypeModificatorId = @i_activityTypeModificatorId,
                    activityTypeEnable = COALESCE(@i_activityTypeEnable, activityTypeEnable)
                WHERE activityTypeId = @i_activityTypeId;

                COMMIT TRANSACTION TRX_UPD_ACT_TYPE;
                SET @o_Numero = 200;
                SET @o_MensajeUsuario = 'TIPO DE ACTIVIDAD ACTUALIZADO CORRECTAMENTE';
            END TRY
            BEGIN CATCH
                IF @@TRANCOUNT > 0
                    ROLLBACK TRANSACTION TRX_UPD_ACT_TYPE;

                SET @o_Numero = 500;
                SET @o_MensajeUsuario = 'ERROR AL ACTUALIZAR TIPO DE ACTIVIDAD';
                SET @o_MensajeTecnico = CONCAT_WS(
                    ' - ',
                    'ERROR AL ACTUALIZAR TIPO DE ACTIVIDAD',
                    ERROR_PROCEDURE(),
                    ERROR_LINE(),
                    ERROR_MESSAGE()
                );
            END CATCH
        END
    END

    -- ACCIÓN: LISTAR CON PAGINACIÓN ('S')
    ELSE IF @w_Accion = 'S'
    BEGIN
        IF ISNULL(@i_PageNumber, 0) < 1 SET @i_PageNumber = 1;
        IF ISNULL(@i_RowsPerPage, 0) < 1 SET @i_RowsPerPage = 10;

        BEGIN TRY
            SELECT 
                activityTypeId,
                activityTypeName,
                activityTypeCreationDate,
                activityTypeCreatorId,
                activityTypeModificationDate,
                activityTypeModificatorId,
                activityTypeEnable
            FROM SQM_CATALOGS.TBL_ActivityTypes
            ORDER BY activityTypeId
            OFFSET (@i_PageNumber - 1) * @i_RowsPerPage ROWS
            FETCH NEXT @i_RowsPerPage ROWS ONLY;

            SET @w_totalRows = @@ROWCOUNT;

            IF @w_totalRows > 0
            BEGIN
                SET @o_Numero = 200;
                SET @o_MensajeUsuario = 'TIPOS DE ACTIVIDAD LISTADOS CORRECTAMENTE';
            END
            ELSE
            BEGIN
                SET @o_Numero = 204;
                SET @o_MensajeUsuario = 'NO HAY MAS REGISTROS PARA LISTAR';
            END
        END TRY
        BEGIN CATCH
            SET @o_Numero = 500;
            SET @o_MensajeUsuario = 'ERROR AL LISTAR TIPOS DE ACTIVIDAD';
            SET @o_MensajeTecnico = CONCAT_WS(
                ' - ',
                'ERROR AL LISTAR TIPOS DE ACTIVIDAD',
                ERROR_PROCEDURE(),
                ERROR_LINE(),
                ERROR_MESSAGE()
            );
        END CATCH
    END

    -- ACCIÓN INVÁLIDA
    ELSE
    BEGIN
        SET @o_Numero = 405;
        SET @o_MensajeUsuario = 'METODO NO HABILITADO';
        SET @o_MensajeTecnico = 'EL PROCEDIMIENTO ALMACENADO NO TIENE HABILITADA ESA OPCION';
    END
END;
GO