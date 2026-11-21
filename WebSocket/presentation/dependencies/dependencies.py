
from application.use_cases.EpicsUseCases import EpicUseCase
from application.use_cases.featuresUseCase import FeatureUseCase
from application.use_cases.InitiativeUseCases import InitiativeUseCase
from application.use_cases.UsersUseCases import UserUseCase
from application.use_cases.RolesUseCases import RoleUseCase
from application.use_cases.StatusUseCase import StatusUseCase

from infrastructure.repositories.EpicRepository import EpicRepository
from infrastructure.repositories.FeaturesRepository import FeatureRepository
from infrastructure.repositories.InitiativeRepository import InitiativeRepository
from infrastructure.repositories.UsersRepository import UserRepository
from infrastructure.repositories.RolesRepository import RolesRepository
from infrastructure.repositories.StatusRepository import StatusRepository


def get_epic_use_case() -> EpicUseCase:

    repository = EpicRepository()

    return EpicUseCase(repository)


def get_feature_use_case() -> FeatureUseCase:

    repository = FeatureRepository()

    return FeatureUseCase(repository)


def get_initiative_use_case() -> InitiativeUseCase:

    repository = InitiativeRepository()

    return InitiativeUseCase(repository)

def get_user_use_case() -> UserUseCase:
    repository = UserRepository()
    return UserUseCase(repository)



def get_role_use_case() -> RoleUseCase:
    repository = RolesRepository()
    return RoleUseCase(repository)



def get_status_use_case() -> StatusUseCase:
    repository = StatusRepository()
    return StatusUseCase(repository)
