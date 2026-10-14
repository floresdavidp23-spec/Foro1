USE DB_SCRUM_PLANNING;
GO

/* =============================================
   PRUEBA 1: CONSULTAR LOS USUARIOS EXISTENTES
   ============================================= */

SELECT
    userId,
    userFullName,
    userName,
    userEmail,
    userRolId,
    userCreationDate,
    userModificationDate,
    userEnable
FROM SQM_SECURITY.TBL_Users;
GO


/* =============================================
   PRUEBA 2: ACTUALIZAR UN USUARIO
   ============================================= */

DECLARE @Numero INT,
        @MensajeUsuario VARCHAR(500),
        @MensajeTecnico VARCHAR(500);

EXEC SQM_SECURITY.USP_Users
    @i_userId = 2,
    @i_userModificatorId = 2,
    @i_userFullName = 'Kevin Velasquez',
    @w_Accion = 'U',
    @o_Numero = @Numero OUTPUT,
    @o_MensajeUsuario = @MensajeUsuario OUTPUT,
    @o_MensajeTecnico = @MensajeTecnico OUTPUT;

SELECT
    @Numero AS Codigo,
    @MensajeUsuario AS MensajeUsuario,
    @MensajeTecnico AS MensajeTecnico;
GO


/* =============================================
   PRUEBA 3: VERIFICAR EL USUARIO ACTUALIZADO
   ============================================= */

SELECT
    userId,
    userFullName,
    userName,
    userEmail,
    userRolId,
    userModificationDate,
    userModificatorId,
    userEnable
FROM SQM_SECURITY.TBL_Users
WHERE userId = 2;
GO