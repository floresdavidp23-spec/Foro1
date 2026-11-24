from domain.entities.TasksModels import TaskCreate, TaskUpdate
from domain.interfaces.ITasksRepository import ITasksRepository


class TaskUseCase:

    def __init__(self, repository: ITasksRepository):
        self.repository = repository

    def create_task(self, task: TaskCreate, creator_id: int):
        return self.repository.insert_task(task, creator_id)

    def update_task(self, task: TaskUpdate, modificator_id: int):
        return self.repository.update_task(task, modificator_id)

    def list_tasks(self, page_number: int, rows_per_page: int):
        return self.repository.list_tasks(
            page_number=page_number,
            rows_per_page=rows_per_page
        )
