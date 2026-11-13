from abc import ABC, abstractmethod

from domain.entities.EpicModels import EpicCreate, EpicUpdate
from domain.shared.operationResult import OperationResult
from domain.shared.queryResult import QueryResult


class IEpicRepository(ABC):

    @abstractmethod
    def insert_epic(
        self,
        epic: EpicCreate,
        creator_id: int
    ) -> OperationResult:
        """
        Registra una nueva épica.
        """
        raise NotImplementedError

    @abstractmethod
    def update_epic(
        self,
        epic: EpicUpdate,
        modificator_id: int
    ) -> OperationResult:
        """
        Actualiza una épica existente.
        """
        raise NotImplementedError

    @abstractmethod
    def list_epics(
        self,
        page_number: int,
        rows_per_page: int
    ) -> QueryResult:
        """
        Obtiene épicas paginadas.
        """
        raise NotImplementedError