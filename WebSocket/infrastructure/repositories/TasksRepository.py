from domain.entities.TasksModels import TaskCreate, TaskUpdate
from infrastructure.repositories.SqlHelper import execute_sp, respuesta_lista


class TasksRepository:

    def insert_task(self, task: TaskCreate) -> Dict[str, Any]:
        execute_sp(""" EXEC [SQM_GENERAL].[USP_Tasks] @i_taskSummary = ?, @i_taskDescription = ?, @i_taskOwner = ?, @i_taskParentLink = ?, @i_taskOriginalEstimate = ?, @i_taskCompletedWork = ?, @i_taskRemaningWork = ?, @i_taskStartDate = ?, @i_taskCompletedDate = ?, @i_taskDueDate = ?, @i_taskActivityType = ?, @i_taskCreatorId = ?, @i_taskStatus = ?, @w_Accion = 'I' """, (
            task.taskSummary,
            task.taskDescription,
            task.taskOwner,
            task.taskParentLink,
            task.taskOriginalEstimate,
            task.taskCompletedWork,
            task.taskRemaningWork,
            task.taskStartDate,
            task.taskCompletedDate,
            task.taskDueDate,
            task.taskActivityType,
            task.taskCreatorId,
            task.taskStatus,
        ))
        return {"status_code": 201, "message": "TAREA REGISTRADA CORRECTAMENTE"}

    def update_task(self, task: TaskUpdate) -> Dict[str, Any]:
        execute_sp(""" EXEC [SQM_GENERAL].[USP_Tasks] @i_taskId = ?, @i_taskSummary = ?, @i_taskDescription = ?, @i_taskOwner = ?, @i_taskParentLink = ?, @i_taskOriginalEstimate = ?, @i_taskCompletedWork = ?, @i_taskRemaningWork = ?, @i_taskStartDate = ?, @i_taskCompletedDate = ?, @i_taskDueDate = ?, @i_taskActivityType = ?, @i_taskModificatorId = ?, @i_taskStatus = ?, @w_Accion = 'U' """, (
            task.taskId,
            task.taskSummary,
            task.taskDescription,
            task.taskOwner,
            task.taskParentLink,
            task.taskOriginalEstimate,
            task.taskCompletedWork,
            task.taskRemaningWork,
            task.taskStartDate,
            task.taskCompletedDate,
            task.taskDueDate,
            task.taskActivityType,
            task.taskModificatorId,
            task.taskStatus,
        ))
        return {"status_code": 200, "message": "TAREA ACTUALIZADA CORRECTAMENTE"}

    def list_tasks(self, page: int = 1, rows: int = 10) -> Dict[str, Any]:
        data = execute_sp(""" EXEC [SQM_GENERAL].[USP_Tasks] @i_PageNumber = ?, @i_RowsPerPage = ?, @w_Accion = 'S' """, (page, rows), fetch=True)
        return respuesta_lista(data, "TAREAS LISTADAS CORRECTAMENTE")