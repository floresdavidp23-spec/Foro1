from abc import ABC, abstractmethod

from domain.entities.RolesModels import RoleCreate, RoleUpdate
from domain.shared.operationResult import OperationResult
from domain.shared.queryResult import QueryResult


class IRolesRepository(ABC):

    @abstractmethod
    def insert_role(
        self,
        role: RoleCreate,
        creator_id: int
    ) -> OperationResult:
        """
        Registra un nuevo rol.
        """
        raise NotImplementedError

    @abstractmethod
    def update_role(
        self,
        role: RoleUpdate,
        modificator_id: int
    ) -> OperationResult:
        """
        Actualiza un rol existente.
        """
        raise NotImplementedError

    @abstractmethod
    def list_roles(
        self,
        page_number: int,
        rows_per_page: int
    ) -> QueryResult:
        """
        Obtiene roles paginados.
        """
        raise NotImplementedError