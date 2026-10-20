USE DB_SCRUM_PLANNING;
GO

CREATE OR ALTER PROC [SQM_CATALOGS].[USP_Status]
(
    @i_statusId INT = NULL,
    @i_statusName VARCHAR(80) = NULL,
    @i_statusCreatorId INT = NULL,
    @i_statusModificatorId INT = NULL,
    @i_statusEnable BIT = NULL,
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

    -- INSERTAR ESTADO (ACCION 'I')
    IF @w_Accion = 'I'
    BEGIN

        -- VALIDACIÓN 1: Nombre de estado obligatorio
        IF ISNULL(@i_statusName, '') = ''
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL NOMBRE DEL ESTADO ES OBLIGATORIO';
        END

        -- VALIDACIÓN 2: ID de creador obligatorio
        ELSE IF ISNULL(@i_statusCreatorId, 0) = 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL ID DEL CREADOR ES OBLIGATORIO';
        END

        -- VALIDACIÓN 3: Control de duplicados
        ELSE IF EXISTS (
            SELECT 1
            FROM SQM_CATALOGS.TBL_Status
            WHERE statusName = @i_statusName
        )
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL NOMBRE DEL ESTADO YA EXISTE';
        END

        ELSE
        BEGIN

            BEGIN TRANSACTION TRX_INS_STATUS;

            BEGIN TRY

                INSERT INTO SQM_CATALOGS.TBL_Status
                (
                    statusName,
                    statusCreationDate,
                    statusCreatorId,
                    statusModificationDate,
                    statusModificatorId,
                    statusEnable
                )
                VALUES
                (
                    @i_statusName,
                    GETDATE(),
                    @i_statusCreatorId,
                    GETDATE(),
                    NULL,
                    1
                );

                COMMIT TRANSACTION TRX_INS_STATUS;

                SET @o_Numero = 201;
                SET @o_MensajeUsuario = 'ESTADO REGISTRADO CORRECTAMENTE';

            END TRY

            BEGIN CATCH

                IF @@TRANCOUNT > 0
                    ROLLBACK TRANSACTION TRX_INS_STATUS;

                SET @o_Numero = 500;
                SET @o_MensajeUsuario = 'ERROR AL REGISTRAR ESTADO';

                SET @o_MensajeTecnico = CONCAT_WS(
                    ' - ',
                    'ERROR AL REGISTRAR ESTADO',
                    ERROR_PROCEDURE(),
                    ERROR_LINE(),
                    ERROR_MESSAGE()
                );

            END CATCH

        END
    END

    
    -- ACTUALIZAR ESTADO (ACCION 'U')
   
    ELSE IF @w_Accion = 'U'
    BEGIN

        -- VALIDACIÓN 1: ID de estado obligatorio
        IF ISNULL(@i_statusId, 0) = 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL ID DEL ESTADO ES OBLIGATORIO';
        END

        -- VALIDACIÓN 2: ID de modificador obligatorio
        ELSE IF ISNULL(@i_statusModificatorId, 0) = 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL ID DEL MODIFICADOR ES OBLIGATORIO';
        END

        -- VALIDACIÓN 3: Existencia del registro
        ELSE IF NOT EXISTS (
            SELECT 1
            FROM SQM_CATALOGS.TBL_Status
            WHERE statusId = @i_statusId
        )
        BEGIN
            SET @o_Numero = 404;
            SET @o_MensajeUsuario = 'EL ESTADO NO EXISTE';
        END

        -- VALIDACIÓN 4: Control de duplicados con otro registro
        ELSE IF @i_statusName IS NOT NULL
            AND EXISTS (
                SELECT 1
                FROM SQM_CATALOGS.TBL_Status
                WHERE statusName = @i_statusName
                  AND statusId <> @i_statusId
            )
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL NOMBRE DEL ESTADO YA EXISTE';
        END

        ELSE
        BEGIN

            BEGIN TRANSACTION TRX_UPD_STATUS;

            BEGIN TRY

                UPDATE SQM_CATALOGS.TBL_Status
                SET statusName = COALESCE(@i_statusName, statusName),
                    statusModificationDate = GETDATE(),
                    statusModificatorId = @i_statusModificatorId,
                    statusEnable = COALESCE(@i_statusEnable, statusEnable)
                WHERE statusId = @i_statusId;

                COMMIT TRANSACTION TRX_UPD_STATUS;

                SET @o_Numero = 200;
                SET @o_MensajeUsuario = 'ESTADO ACTUALIZADO CORRECTAMENTE';

            END TRY

            BEGIN CATCH

                IF @@TRANCOUNT > 0
                    ROLLBACK TRANSACTION TRX_UPD_STATUS;

                SET @o_Numero = 500;
                SET @o_MensajeUsuario = 'ERROR AL ACTUALIZAR ESTADO';

                SET @o_MensajeTecnico = CONCAT_WS(
                    ' - ',
                    'ERROR AL ACTUALIZAR ESTADO',
                    ERROR_PROCEDURE(),
                    ERROR_LINE(),
                    ERROR_MESSAGE()
                );

            END CATCH

        END
    END

    
    -- LISTAR ESTADOS CON PAGINACIÓN (ACCION 'S')
    ELSE IF @w_Accion = 'S'
    BEGIN

        IF ISNULL(@i_PageNumber, 0) < 1 SET @i_PageNumber = 1;
        IF ISNULL(@i_RowsPerPage, 0) < 1 SET @i_RowsPerPage = 10;

        BEGIN TRY

            SELECT
                statusId,
                statusName,
                statusCreationDate,
                statusCreatorId,
                statusModificationDate,
                statusModificatorId,
                statusEnable
            FROM SQM_CATALOGS.TBL_Status
            ORDER BY statusId
            OFFSET (@i_PageNumber - 1) * @i_RowsPerPage ROWS
            FETCH NEXT @i_RowsPerPage ROWS ONLY;

            SET @w_totalRows = @@ROWCOUNT;

            IF @w_totalRows > 0
            BEGIN
                SET @o_Numero = 200;
                SET @o_MensajeUsuario = 'ESTADOS LISTADOS CORRECTAMENTE';
            END
            ELSE
            BEGIN
                SET @o_Numero = 204;
                SET @o_MensajeUsuario = 'NO HAY MAS REGISTROS PARA LISTAR';
            END

        END TRY

        BEGIN CATCH

            SET @o_Numero = 500;
            SET @o_MensajeUsuario = 'ERROR AL LISTAR LOS ESTADOS';

            SET @o_MensajeTecnico = CONCAT_WS(
                ' - ',
                'ERROR AL LISTAR ESTADOS',
                ERROR_PROCEDURE(),
                ERROR_LINE(),
                ERROR_MESSAGE()
            );

        END CATCH

    END

    -- ACCIÓN NO VÁLIDA
    ELSE
    BEGIN

        SET @o_Numero = 405;
        SET @o_MensajeUsuario = 'METODO NO HABILITADO';
        SET @o_MensajeTecnico =
            'EL PROCEDIMIENTO ALMACENADO NO TIENE HABILITADA ESA OPCION';

    END

END;
GO