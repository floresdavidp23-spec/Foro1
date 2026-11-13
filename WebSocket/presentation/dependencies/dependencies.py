
from application.use_cases.EpicsUseCases import EpicUseCase
from application.use_cases.featuresUseCase import FeatureUseCase
from application.use_cases.InitiativeUseCases import InitiativeUseCase


from infrastructure.repositories.EpicRepository import EpicRepository
from infrastructure.repositories.FeaturesRepository import FeatureRepository
from infrastructure.repositories.InitiativeRepository import InitiativeRepository



def get_epic_use_case() -> EpicUseCase:

    repository = EpicRepository()

    return EpicUseCase(repository)


def get_feature_use_case() -> FeatureUseCase:

    repository = FeatureRepository()

    return FeatureUseCase(repository)


def get_initiative_use_case() -> InitiativeUseCase:

    repository = InitiativeRepository()

    return InitiativeUseCase(repository)