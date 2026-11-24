import logging
from typing import Annotated

from fastapi import APIRouter, Depends, HTTPException, Query

from application.use_cases.TasksUseCase import TaskUseCase
from domain.entities.TasksModels import TaskCreate, TaskUpdate
from infrastructure.repositories.TasksRepository import TasksRepository
from presentation.security import get_current_user
from presentation.states.generic_states import OperationResponse, QueryResponse


router = APIRouter(prefix="/websocket/tasks", tags=["Tasks"])
logger = logging.getLogger(__name__)


def get_task_use_case() -> TaskUseCase:
    return TaskUseCase(TasksRepository())


TaskUseCaseDep = Annotated[TaskUseCase, Depends(get_task_use_case)]
CurrentUserDep = Annotated[dict[str, int | str], Depends(get_current_user)]


@router.post("/create", response_model=OperationResponse, status_code=201)
def create_task(
    task: TaskCreate,
    use_case: TaskUseCaseDep,
    current_user: CurrentUserDep
):
    result = use_case.create_task(task, int(current_user["sub"]))
    if result.status_code >= 400:
        raise HTTPException(status_code=result.status_code, detail=result.message_user)
    return result


@router.put("/update", response_model=OperationResponse)
def update_task(
    task: TaskUpdate,
    use_case: TaskUseCaseDep,
    current_user: CurrentUserDep
):
    result = use_case.update_task(task, int(current_user["sub"]))
    if result.status_code >= 400:
        raise HTTPException(status_code=result.status_code, detail=result.message_user)
    return result


@router.get("/list", response_model=QueryResponse)
def list_tasks(
    use_case: TaskUseCaseDep,
    current_user: CurrentUserDep,
    page_number: Annotated[int, Query(ge=1)] = 1,
    rows_per_page: Annotated[int, Query(ge=1, le=100)] = 10
):
    result = use_case.list_tasks(page_number, rows_per_page)
    if result.status_code >= 400:
        raise HTTPException(status_code=result.status_code, detail=result.message_user)
    return result
