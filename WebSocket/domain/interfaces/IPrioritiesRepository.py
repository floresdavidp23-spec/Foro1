from abc import ABC, abstractmethod

from domain.entities.PrioritiesModels import PriorityCreate, PriorityUpdate
from domain.shared.operationResult import OperationResult
from domain.shared.queryResult import QueryResult


class IPrioritiesRepository(ABC):

    @abstractmethod
    def insert_priority(
        self,
        priority: PriorityCreate,
        creator_id: int
    ) -> OperationResult:
        """
        Registra una nueva prioridad.
        """
        raise NotImplementedError

    @abstractmethod
    def update_priority(
        self,
        priority: PriorityUpdate,
        modificator_id: int
    ) -> OperationResult:
        """
        Actualiza una prioridad existente.
        """
        raise NotImplementedError

    @abstractmethod
    def list_priorities(
        self,
        page_number: int,
        rows_per_page: int
    ) -> QueryResult:
        """
        Obtiene prioridades paginadas.
        """
        raise NotImplementedError
