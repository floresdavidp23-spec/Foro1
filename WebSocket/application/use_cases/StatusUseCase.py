from domain.entities.StatusModels import StatusCreate, StatusUpdate
from domain.interfaces.IstatusRepository import IStatusRepository


class StatusUseCase:

    def __init__(
        self,
        repository: IStatusRepository
    ):
        self.repository = repository

    def create_status(self, status: StatusCreate, creator_id: int):
        return self.repository.insert_status(status, creator_id)

    def update_status(self, status: StatusUpdate, modificator_id: int):
        return self.repository.update_status(status, modificator_id)

    def list_statuses(
        self,
        page_number: int,
        rows_per_page: int
    ):
        return self.repository.list_statuses(
            page_number=page_number,
            rows_per_page=rows_per_page
        )