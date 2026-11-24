from domain.entities.ActivityTypesModels import ActivityTypeCreate, ActivityTypeUpdate
from domain.interfaces.IActivityTypesRepository import IActivityTypesRepository


class ActivityTypeUseCase:

    def __init__(self, repository: IActivityTypesRepository):
        self.repository = repository

    def create_activity_type(self, activity_type: ActivityTypeCreate, creator_id: int):
        return self.repository.insert_activity_type(activity_type, creator_id)

    def update_activity_type(self, activity_type: ActivityTypeUpdate, modificator_id: int):
        return self.repository.update_activity_type(activity_type, modificator_id)

    def list_activity_types(self, page_number: int, rows_per_page: int):
        return self.repository.list_activity_types(
            page_number=page_number,
            rows_per_page=rows_per_page
        )
