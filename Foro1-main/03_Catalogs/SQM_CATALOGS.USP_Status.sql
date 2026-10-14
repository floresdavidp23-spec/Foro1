--SQM_CATALOGS.USP_Status.sql

USE DB_SCRUM_PLANNING;
GO

CREATE OR ALTER PROC SQM_CATALOGS.USP_Status  
(  
    @i_statusId INT = NULL,  
    @i_statusName VARCHAR(80) = NULL,  
    @i_statusCreatorId INT = NULL,  
    @i_statusModificatorId INT = NULL,  
    @i_statusEnable BIT = NULL,  
    @i_PageNumber INT = 1,  
    @i_RowsPerPage INT = 10,  
    @w_Accion CHAR(1)  
)  
AS  
BEGIN  
  
    -- INSERTAR  
    IF @w_Accion = 'I'  
    BEGIN  
  
        INSERT INTO SQM_CATALOGS.TBL_Status  
(  
    statusName,  
    statusCreationDate,  
    statusCreatorId,  
    statusModificationDate,  
    statusEnable  
)  
VALUES  
(  
    @i_statusName,  
    GETDATE(),  
    @i_statusCreatorId,  
    GETDATE(),  
    1  
);  
  
        PRINT 'ESTADO REGISTRADO CORRECTAMENTE';  
  
    END  
  
    -- ACTUALIZAR  
    ELSE IF @w_Accion = 'U'  
    BEGIN  
  
        UPDATE SQM_CATALOGS.TBL_Status  
        SET statusName = @i_statusName,  
            statusModificationDate = GETDATE(),  
            statusModificatorId = @i_statusModificatorId,  
            statusEnable = @i_statusEnable  
        WHERE statusId = @i_statusId;  
  
        PRINT 'ESTADO ACTUALIZADO CORRECTAMENTE';  
  
    END  
  
    -- LISTAR  
    ELSE IF @w_Accion = 'S'  
    BEGIN  
  
        SELECT *  
        FROM SQM_CATALOGS.TBL_Status  
        ORDER BY statusId  
        OFFSET (@i_PageNumber - 1) * @i_RowsPerPage ROWS  
        FETCH NEXT @i_RowsPerPage ROWS ONLY;  
  
    END  
  
END;
GO
