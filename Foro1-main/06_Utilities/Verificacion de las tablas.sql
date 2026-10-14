--Verificacion de las tablas
USE DB_SCRUM_PLANNING;
GO

EXEC sp_helptext 'SQM_CATALOGS.USP_Status';
GO

SELECT
    SCHEMA_NAME(schema_id) AS Esquema,
    name AS Procedimiento
FROM sys.procedures
WHERE name LIKE 'USP%'
ORDER BY SCHEMA_NAME(schema_id), name;
GO

SELECT
    TABLE_SCHEMA AS Esquema,
    TABLE_NAME AS Tabla
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_SCHEMA, TABLE_NAME;
GO

EXEC sp_help 'SQM_CATALOGS.TBL_ActivityTypes';
GO

EXEC sp_help 'SQM_CATALOGS.TBL_BusinessValues';
GO

EXEC sp_help 'SQM_CATALOGS.TBL_Priorities';
GO

EXEC sp_help 'SQM_GENERAL.TBL_Epics';
GO

EXEC sp_help 'SQM_GENERAL.TBL_Features';
GO

EXEC sp_help 'SQM_GENERAL.TBL_Initiatives';
GO

EXEC sp_help 'SQM_GENERAL.TBL_ProductBacklogItems';
GO

EXEC sp_help 'SQM_GENERAL.TBL_TaskComments';
GO

EXEC sp_help 'SQM_GENERAL.TBL_Tasks';
GO

EXEC sp_help 'SQM_SECURITY.TBL_Roles';
GO

EXEC sp_help 'SQM_SECURITY.TBL_Users';
GO