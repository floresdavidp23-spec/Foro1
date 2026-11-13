from abc import ABC, abstractmethod

from domain.entities.InitiativesModels import InitiativeCreate, InitiativeUpdate
from domain.shared.operationResult import OperationResult
from domain.shared.queryResult import QueryResult


class IInitiativeRepository(ABC):

    @abstractmethod
    def insert_initiative(
        self,
        initiative: InitiativeCreate,
        creator_id: int
    ) -> OperationResult:
        """
        Registra una nueva iniciativa.
        """
        raise NotImplementedError

    @abstractmethod
    def update_initiative(
        self,
        initiative: InitiativeUpdate,
        modificator_id: int
    ) -> OperationResult:
        """
        Actualiza una iniciativa existente.
        """
        raise NotImplementedError

    @abstractmethod
    def list_initiatives(
        self,
        page_number: int,
        rows_per_page: int
    ) -> QueryResult:
        """
        Obtiene iniciativas paginadas.
        """
        raise NotImplementedError