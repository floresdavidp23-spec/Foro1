from abc import ABC, abstractmethod

from domain.entities.BusinessValuesModels import BusinessValueCreate, BusinessValueUpdate
from domain.shared.operationResult import OperationResult
from domain.shared.queryResult import QueryResult


class IBusinessValuesRepository(ABC):

    @abstractmethod
    def insert_business_value(
        self,
        business_value: BusinessValueCreate,
        creator_id: int
    ) -> OperationResult:
        """
        Registra un nuevo valor de negocio.
        """
        raise NotImplementedError

    @abstractmethod
    def update_business_value(
        self,
        business_value: BusinessValueUpdate,
        modificator_id: int
    ) -> OperationResult:
        """
        Actualiza un valor de negocio existente.
        """
        raise NotImplementedError

    @abstractmethod
    def list_business_values(
        self,
        page_number: int,
        rows_per_page: int
    ) -> QueryResult:
        """
        Obtiene valores de negocio paginados.
        """
        raise NotImplementedError
