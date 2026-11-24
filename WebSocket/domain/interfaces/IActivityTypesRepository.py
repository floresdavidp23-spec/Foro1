from abc import ABC, abstractmethod

from domain.entities.ActivityTypesModels import ActivityTypeCreate, ActivityTypeUpdate
from domain.shared.operationResult import OperationResult
from domain.shared.queryResult import QueryResult


class IActivityTypesRepository(ABC):

    @abstractmethod
    def insert_activity_type(
        self,
        activity_type: ActivityTypeCreate,
        creator_id: int
    ) -> OperationResult:
        """
        Registra un nuevo tipo de actividad.
        """
        raise NotImplementedError

    @abstractmethod
    def update_activity_type(
        self,
        activity_type: ActivityTypeUpdate,
        modificator_id: int
    ) -> OperationResult:
        """
        Actualiza un tipo de actividad existente.
        """
        raise NotImplementedError

    @abstractmethod
    def list_activity_types(
        self,
        page_number: int,
        rows_per_page: int
    ) -> QueryResult:
        """
        Obtiene tipos de actividad paginados.
        """
        raise NotImplementedError
