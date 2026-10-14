--Fn_DecryptByKey.sql

﻿USE [DB_SCRUM_PLANNING]
GO

----------------------------------------
/* FUNCION ESCALAR PARA DESENCRIPTADO */
----------------------------------------
CREATE OR ALTER FUNCTION [SQM_SECURITY].[Fn_DecryptByKey]
(
	@EncryptedValue VARBINARY(256)
)
RETURNS VARCHAR(256)
AS
BEGIN
	DECLARE @UnencryptedValue VARCHAR(256);

		SET @UnencryptedValue = CONVERT(VARCHAR(256), DECRYPTBYKEY(@EncryptedValue));

	RETURN @UnencryptedValue;
END