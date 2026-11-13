from abc import ABC, abstractmethod

from domain.entities.FeaturesModels import FeatureCreate, FeatureUpdate
from domain.shared.operationResult import OperationResult
from domain.shared.queryResult import QueryResult


class IFeatureRepository(ABC):

    @abstractmethod
    def insert_feature(
        self,
        feature: FeatureCreate,
        creator_id: int
    ) -> OperationResult:
        """
        Registra una nueva feature.
        """
        raise NotImplementedError

    @abstractmethod
    def update_feature(
        self,
        feature: FeatureUpdate,
        modificator_id: int
    ) -> OperationResult:
        """
        Actualiza una feature existente.
        """
        raise NotImplementedError

    @abstractmethod
    def list_features(
        self,
        page_number: int,
        rows_per_page: int
    ) -> QueryResult:
        """
        Obtiene features paginadas.
        """
        raise NotImplementedError