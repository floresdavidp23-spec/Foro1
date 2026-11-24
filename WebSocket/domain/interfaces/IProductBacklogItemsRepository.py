from abc import ABC, abstractmethod

from domain.entities.ProductBacklogItemsModels import PBICreate, PBIUpdate
from domain.shared.operationResult import OperationResult
from domain.shared.queryResult import QueryResult


class IProductBacklogItemsRepository(ABC):

    @abstractmethod
    def insert_pbi(
        self,
        pbi: PBICreate,
        creator_id: int
    ) -> OperationResult:
        """
        Registra un elemento del Product Backlog.
        """
        raise NotImplementedError

    @abstractmethod
    def update_pbi(
        self,
        pbi: PBIUpdate,
        modificator_id: int
    ) -> OperationResult:
        """
        Actualiza un elemento del Product Backlog existente.
        """
        raise NotImplementedError

    @abstractmethod
    def list_pbis(
        self,
        page_number: int,
        rows_per_page: int
    ) -> QueryResult:
        """
        Obtiene los elementos del Product Backlog paginados.
        """
        raise NotImplementedError
