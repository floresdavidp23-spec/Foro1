from domain.entities.TaskCommentsModels import TaskCommentCreate, TaskCommentUpdate
from domain.interfaces.ITaskCommentsRepository import ITaskCommentsRepository


class TaskCommentUseCase:

    def __init__(self, repository: ITaskCommentsRepository):
        self.repository = repository

    def create_task_comment(self, comment: TaskCommentCreate, creator_id: int):
        return self.repository.insert_task_comment(comment, creator_id)

    def update_task_comment(self, comment: TaskCommentUpdate, modificator_id: int):
        return self.repository.update_task_comment(comment, modificator_id)

    def list_task_comments(self, page_number: int, rows_per_page: int):
        return self.repository.list_task_comments(
            page_number=page_number,
            rows_per_page=rows_per_page
        )
