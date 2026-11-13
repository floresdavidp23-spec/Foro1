from domain.entities.InitiativesModels import InitiativeCreate, InitiativeUpdate
from domain.interfaces.IInitiativesRepository import IInitiativeRepository


class InitiativeUseCase:

    def __init__(
        self,
        repository: IInitiativeRepository
    ):
        self.repository = repository

    def create_initiative(self, initiative: InitiativeCreate, creator_id: int):
        return self.repository.insert_initiative(initiative, creator_id)

    def update_initiative(self, initiative: InitiativeUpdate, modificator_id: int):
        return self.repository.update_initiative(initiative, modificator_id)

    def list_initiatives(
        self,
        page_number: int,
        rows_per_page: int
    ):
        return self.repository.list_initiatives(
            page_number=page_number,
            rows_per_page=rows_per_page
        )