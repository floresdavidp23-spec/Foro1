from domain.entities.EpicModels import EpicCreate, EpicUpdate
from domain.interfaces.IepicsRepository import IEpicRepository


class EpicUseCase:

    def __init__(
        self,
        repository: IEpicRepository
    ):
        self.repository = repository

    def create_epic(self, epic: EpicCreate, creator_id: int):
        return self.repository.insert_epic(epic, creator_id)

    def update_epic(self, epic: EpicUpdate, modificator_id: int):
        return self.repository.update_epic(epic, modificator_id)

    def list_epics(
        self,
        page_number: int,
        rows_per_page: int
    ):
        return self.repository.list_epics(
            page_number=page_number,
            rows_per_page=rows_per_page
        )