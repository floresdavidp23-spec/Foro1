from domain.entities.FeaturesModels import FeatureCreate, FeatureUpdate
from domain.interfaces.IFeaturesRepository import IFeatureRepository


class FeatureUseCase:

    def __init__(
        self,
        repository: IFeatureRepository
    ):
        self.repository = repository

    def create_feature(self, feature: FeatureCreate, creator_id: int):
        return self.repository.insert_feature(feature, creator_id)

    def update_feature(self, feature: FeatureUpdate, modificator_id: int):
        return self.repository.update_feature(feature, modificator_id)

    def list_features(
        self,
        page_number: int,
        rows_per_page: int
    ):
        return self.repository.list_features(
            page_number=page_number,
            rows_per_page=rows_per_page
        )