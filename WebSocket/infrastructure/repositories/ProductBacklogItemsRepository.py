from typing import Any, Dict

from domain.entities.ProductBacklogItemsModels import PBICreate, PBIUpdate
from infrastructure.repositories.SqlHelper import execute_sp, respuesta_lista


class ProductBacklogItemsRepository:

    def insert_pbi(self, pbi: PBICreate) -> Dict[str, Any]:
        execute_sp(""" EXEC [SQM_GENERAL].[USP_ProductBacklogItems] @i_PBISummary = ?, @i_PBIDescription = ?, @i_PBIAcceptanceCriteria = ?, @i_PBIOwner = ?, @i_PBIParentLink = ?, @i_PBIStoryPoint = ?, @i_PBIStartDate = ?, @i_PBIDueDate = ?, @i_PBIPriority = ?, @i_PBICreatorId = ?, @i_PBIStatus = ?, @w_Accion = 'I' """, (
            pbi.PBISummary,
            pbi.PBIDescription,
            pbi.PBIAcceptanceCriteria,
            pbi.PBIOwner,
            pbi.PBIParentLink,
            pbi.PBIStoryPoint,
            pbi.PBIStartDate,
            pbi.PBIDueDate,
            pbi.PBIPriority,
            pbi.PBICreatorId,
            pbi.PBIStatus,
        ))
        return {"status_code": 201, "message": "ELEMENTO DEL PRODUCT BACKLOG REGISTRADO CORRECTAMENTE"}

    def update_pbi(self, pbi: PBIUpdate) -> Dict[str, Any]:
        execute_sp(""" EXEC [SQM_GENERAL].[USP_ProductBacklogItems] @i_PBIId = ?, @i_PBISummary = ?, @i_PBIDescription = ?, @i_PBIAcceptanceCriteria = ?, @i_PBIOwner = ?, @i_PBIParentLink = ?, @i_PBIStoryPoint = ?, @i_PBIStartDate = ?, @i_PBIDueDate = ?, @i_PBIPriority = ?, @i_PBIModificatorId = ?, @i_PBIStatus = ?, @w_Accion = 'U' """, (
            pbi.PBIId,
            pbi.PBISummary,
            pbi.PBIDescription,
            pbi.PBIAcceptanceCriteria,
            pbi.PBIOwner,
            pbi.PBIParentLink,
            pbi.PBIStoryPoint,
            pbi.PBIStartDate,
            pbi.PBIDueDate,
            pbi.PBIPriority,
            pbi.PBIModificatorId,
            pbi.PBIStatus,
        ))
        return {"status_code": 200, "message": "ELEMENTO DEL PRODUCT BACKLOG ACTUALIZADO CORRECTAMENTE"}

    def list_pbis(self, page: int = 1, rows: int = 10) -> Dict[str, Any]:
        data = execute_sp(""" EXEC [SQM_GENERAL].[USP_ProductBacklogItems] @i_PageNumber = ?, @i_RowsPerPage = ?, @w_Accion = 'S' """, (page, rows), fetch=True)
        return respuesta_lista(data, "ELEMENTOS DEL PRODUCT BACKLOG LISTADOS CORRECTAMENTE")