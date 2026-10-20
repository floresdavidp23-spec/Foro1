--Fn_EncryptByKey.sql

﻿USE [DB_SCRUM_PLANNING]
GO

--------------------------------------
/* FUNCION ESCALAR PARA ENCRIPTADO  */
--------------------------------------
CREATE OR ALTER FUNCTION [SQM_SECURITY].[Fn_EncryptByKey]
(
	@UnencryptedValue VARCHAR(256)
)
RETURNS VARBINARY(256)
AS
BEGIN
	DECLARE @EncryptedValue VARBINARY(256);

		SET @EncryptedValue = ENCRYPTBYKEY(KEY_GUID('KEY_HASH'), @UnencryptedValue);

	RETURN @EncryptedValue;
END