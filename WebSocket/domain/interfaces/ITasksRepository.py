from abc import ABC, abstractmethod

from domain.entities.TasksModels import TaskCreate, TaskUpdate
from domain.shared.operationResult import OperationResult
from domain.shared.queryResult import QueryResult


class ITasksRepository(ABC):

    @abstractmethod
    def insert_task(
        self,
        task: TaskCreate,
        creator_id: int
    ) -> OperationResult:
        """
        Registra una tarea.
        """
        raise NotImplementedError

    @abstractmethod
    def update_task(
        self,
        task: TaskUpdate,
        modificator_id: int
    ) -> OperationResult:
        """
        Actualiza una tarea existente.
        """
        raise NotImplementedError

    @abstractmethod
    def list_tasks(
        self,
        page_number: int,
        rows_per_page: int
    ) -> QueryResult:
        """
        Obtiene las tareas paginadas.
        """
        raise NotImplementedError
