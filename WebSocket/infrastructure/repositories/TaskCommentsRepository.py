from domain.entities.TaskCommentsModels import TaskCommentCreate, TaskCommentUpdate
from infrastructure.repositories.SqlHelper import execute_sp, respuesta_lista


class TaskCommentsRepository:

    def insert_task_comment(self, comment: TaskCommentCreate) -> Dict[str, Any]:
        execute_sp(""" EXEC [SQM_GENERAL].[USP_TaskComments] @i_taskCommentParentLink = ?, @i_taskCommentOwner = ?, @i_taskCommentText = ?, @i_taskCommentCreatorId = ?, @w_Accion = 'I' """, (
            comment.taskCommentParentLink,
            comment.taskCommentOwner,
            comment.taskCommentText,
            comment.taskCommentCreatorId,
        ))
        return {"status_code": 201, "message": "COMENTARIO REGISTRADO CORRECTAMENTE"}

    def update_task_comment(self, comment: TaskCommentUpdate) -> Dict[str, Any]:
        execute_sp(""" EXEC [SQM_GENERAL].[USP_TaskComments] @i_taskCommentId = ?, @i_taskCommentParentLink = ?, @i_taskCommentOwner = ?, @i_taskCommentText = ?, @i_taskCommentModificatorId = ?, @i_taskCommentStatus = ?, @w_Accion = 'U' """, (
            comment.taskCommentId,
            comment.taskCommentParentLink,
            comment.taskCommentOwner,
            comment.taskCommentText,
            comment.taskCommentModificatorId,
            comment.taskCommentStatus,
        ))
        return {"status_code": 200, "message": "COMENTARIO ACTUALIZADO CORRECTAMENTE"}

    def list_task_comments(self, page: int = 1, rows: int = 10) -> Dict[str, Any]:
        data = execute_sp(""" EXEC [SQM_GENERAL].[USP_TaskComments] @i_PageNumber = ?, @i_RowsPerPage = ?, @w_Accion = 'S' """, (page, rows), fetch=True)
        return respuesta_lista(data, "COMENTARIOS LISTADOS CORRECTAMENTE")