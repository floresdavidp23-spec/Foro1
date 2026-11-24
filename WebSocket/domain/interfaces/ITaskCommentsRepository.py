from abc import ABC, abstractmethod

from domain.entities.TaskCommentsModels import TaskCommentCreate, TaskCommentUpdate
from domain.shared.operationResult import OperationResult
from domain.shared.queryResult import QueryResult


class ITaskCommentsRepository(ABC):

    @abstractmethod
    def insert_task_comment(
        self,
        comment: TaskCommentCreate,
        creator_id: int
    ) -> OperationResult:
        """
        Registra un comentario de tarea.
        """
        raise NotImplementedError

    @abstractmethod
    def update_task_comment(
        self,
        comment: TaskCommentUpdate,
        modificator_id: int
    ) -> OperationResult:
        """
        Actualiza un comentario de tarea existente.
        """
        raise NotImplementedError

    @abstractmethod
    def list_task_comments(
        self,
        page_number: int,
        rows_per_page: int
    ) -> QueryResult:
        """
        Obtiene los comentarios de tareas paginados.
        """
        raise NotImplementedError
