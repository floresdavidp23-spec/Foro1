USE DB_SCRUM_PLANNING;
GO

CREATE OR ALTER PROC [SQM_SECURITY].[USP_Roles]
(
    @i_rolId INT = NULL,
    @i_rolName VARCHAR(80) = NULL,
    @i_rolCreatorId INT = NULL,
    @i_rolModificatorId INT = NULL,
    @i_rolEnable BIT = NULL,
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

    -- INSERTAR ROL (ACCION 'I')
   
    IF @w_Accion = 'I'
    BEGIN

        -- VALIDACIÓN 1: Nombre de rol obligatorio
        IF ISNULL(@i_rolName, '') = ''
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL NOMBRE DEL ROL ES OBLIGATORIO';
        END

        -- VALIDACIÓN 2: ID de creador obligatorio
        ELSE IF ISNULL(@i_rolCreatorId, 0) = 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL ID DEL CREADOR ES OBLIGATORIO';
        END

        -- VALIDACIÓN 3: Control de nombre duplicado
        ELSE IF EXISTS (
            SELECT 1
            FROM SQM_SECURITY.TBL_Roles
            WHERE rolName = @i_rolName
        )
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL NOMBRE DEL ROL YA EXISTE';
        END

        ELSE
        BEGIN

            BEGIN TRANSACTION TRX_INS_ROLE;

            BEGIN TRY

                INSERT INTO SQM_SECURITY.TBL_Roles
                (
                    rolName,
                    rolCreationDate,
                    rolCreatorId,
                    rolModificationDate,
                    rolModificatorId,
                    rolEnable
                )
                VALUES
                (
                    @i_rolName,
                    GETDATE(),
                    @i_rolCreatorId,
                    GETDATE(),
                    NULL,
                    1
                );

                COMMIT TRANSACTION TRX_INS_ROLE;

                SET @o_Numero = 201;
                SET @o_MensajeUsuario = 'ROL REGISTRADO CORRECTAMENTE';

            END TRY

            BEGIN CATCH

                IF @@TRANCOUNT > 0
                    ROLLBACK TRANSACTION TRX_INS_ROLE;

                SET @o_Numero = 500;
                SET @o_MensajeUsuario = 'ERROR AL REGISTRAR ROL';

                SET @o_MensajeTecnico = CONCAT_WS(
                    ' - ',
                    'ERROR AL REGISTRAR ROL',
                    ERROR_PROCEDURE(),
                    ERROR_LINE(),
                    ERROR_MESSAGE()
                );

            END CATCH

        END
    END

    -- ACTUALIZAR ROL (ACCION 'U')
    ELSE IF @w_Accion = 'U'
    BEGIN

        -- VALIDACIÓN 1: ID de rol obligatorio
        IF ISNULL(@i_rolId, 0) = 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL ID DEL ROL ES OBLIGATORIO';
        END

        -- VALIDACIÓN 2: ID de modificador obligatorio
        ELSE IF ISNULL(@i_rolModificatorId, 0) = 0
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL ID DEL MODIFICADOR ES OBLIGATORIO';
        END

        -- VALIDACIÓN 3: Existencia del registro
        ELSE IF NOT EXISTS (
            SELECT 1
            FROM SQM_SECURITY.TBL_Roles
            WHERE rolId = @i_rolId
        )
        BEGIN
            SET @o_Numero = 404;
            SET @o_MensajeUsuario = 'EL ROL NO EXISTE';
        END

        -- VALIDACIÓN 4: Control de duplicidad con otro registro
        ELSE IF @i_rolName IS NOT NULL
            AND EXISTS (
                SELECT 1
                FROM SQM_SECURITY.TBL_Roles
                WHERE rolName = @i_rolName
                  AND rolId <> @i_rolId
            )
        BEGIN
            SET @o_Numero = 400;
            SET @o_MensajeUsuario = 'EL NOMBRE DEL ROL YA EXISTE';
        END

        ELSE
        BEGIN

            BEGIN TRANSACTION TRX_UPD_ROLE;

            BEGIN TRY

                UPDATE SQM_SECURITY.TBL_Roles
                SET rolName = COALESCE(@i_rolName, rolName),
                    rolModificationDate = GETDATE(),
                    rolModificatorId = @i_rolModificatorId,
                    rolEnable = COALESCE(@i_rolEnable, rolEnable)
                WHERE rolId = @i_rolId;

                COMMIT TRANSACTION TRX_UPD_ROLE;

                SET @o_Numero = 200;
                SET @o_MensajeUsuario = 'ROL ACTUALIZADO CORRECTAMENTE';

            END TRY

            BEGIN CATCH

                IF @@TRANCOUNT > 0
                    ROLLBACK TRANSACTION TRX_UPD_ROLE;

                SET @o_Numero = 500;
                SET @o_MensajeUsuario = 'ERROR AL ACTUALIZAR ROL';

                SET @o_MensajeTecnico = CONCAT_WS(
                    ' - ',
                    'ERROR AL ACTUALIZAR ROL',
                    ERROR_PROCEDURE(),
                    ERROR_LINE(),
                    ERROR_MESSAGE()
                );

            END CATCH

        END
    END

    -- LISTAR ROLES CON PAGINACIÓN (ACCION 'S')
    
    ELSE IF @w_Accion = 'S'
    BEGIN

        IF @i_PageNumber < 1 SET @i_PageNumber = 1;
        IF @i_RowsPerPage < 1 SET @i_RowsPerPage = 10;

        BEGIN TRY

            SELECT
                rolId,
                rolName,
                rolCreationDate,
                rolCreatorId,
                rolModificationDate,
                rolModificatorId,
                rolEnable
            FROM SQM_SECURITY.TBL_Roles
            ORDER BY rolId
            OFFSET (@i_PageNumber - 1) * @i_RowsPerPage ROWS
            FETCH NEXT @i_RowsPerPage ROWS ONLY;

            SET @w_totalRows = @@ROWCOUNT;

            IF @w_totalRows > 0
            BEGIN
                SET @o_Numero = 200;
                SET @o_MensajeUsuario = 'ROLES LISTADOS CORRECTAMENTE';
            END
            ELSE
            BEGIN
                SET @o_Numero = 204;
                SET @o_MensajeUsuario = 'NO HAY MAS REGISTROS PARA LISTAR';
            END

        END TRY

        BEGIN CATCH

            SET @o_Numero = 500;
            SET @o_MensajeUsuario = 'ERROR AL LISTAR LOS ROLES';

            SET @o_MensajeTecnico = CONCAT_WS(
                ' - ',
                'ERROR AL LISTAR ROLES',
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