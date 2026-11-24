from domain.entities.PrioritiesModels import PriorityCreate, PriorityUpdate
from domain.interfaces.IPrioritiesRepository import IPrioritiesRepository


class PriorityUseCase:

    def __init__(self, repository: IPrioritiesRepository):
        self.repository = repository

    def create_priority(self, priority: PriorityCreate, creator_id: int):
        return self.repository.insert_priority(priority, creator_id)

    def update_priority(self, priority: PriorityUpdate, modificator_id: int):
        return self.repository.update_priority(priority, modificator_id)

    def list_priorities(self, page_number: int, rows_per_page: int):
        return self.repository.list_priorities(
            page_number=page_number,
            rows_per_page=rows_per_page
        )
