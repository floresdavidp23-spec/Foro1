import logging
from typing import Annotated

from fastapi import APIRouter, Depends, HTTPException, Query

from application.use_cases.PrioritiesUseCase import PriorityUseCase
from domain.entities.PrioritiesModels import PriorityCreate, PriorityUpdate
from infrastructure.repositories.PrioritiesRepository import PrioritiesRepository
from presentation.security import get_current_user
from presentation.states.generic_states import OperationResponse, QueryResponse


router = APIRouter(prefix="/websocket/priorities", tags=["Priorities"])
logger = logging.getLogger(__name__)


def get_priority_use_case() -> PriorityUseCase:
    return PriorityUseCase(PrioritiesRepository())


PriorityUseCaseDep = Annotated[PriorityUseCase, Depends(get_priority_use_case)]
CurrentUserDep = Annotated[dict[str, int | str], Depends(get_current_user)]


@router.post("/create", response_model=OperationResponse, status_code=201)
def create_priority(
    priority: PriorityCreate,
    use_case: PriorityUseCaseDep,
    current_user: CurrentUserDep
):
    result = use_case.create_priority(priority, int(current_user["sub"]))
    if result.status_code >= 400:
        raise HTTPException(status_code=result.status_code, detail=result.message_user)
    return result


@router.put("/update", response_model=OperationResponse)
def update_priority(
    priority: PriorityUpdate,
    use_case: PriorityUseCaseDep,
    current_user: CurrentUserDep
):
    result = use_case.update_priority(priority, int(current_user["sub"]))
    if result.status_code >= 400:
        raise HTTPException(status_code=result.status_code, detail=result.message_user)
    return result


@router.get("/list", response_model=QueryResponse)
def list_priorities(
    use_case: PriorityUseCaseDep,
    current_user: CurrentUserDep,
    page_number: Annotated[int, Query(ge=1)] = 1,
    rows_per_page: Annotated[int, Query(ge=1, le=100)] = 10
):
    result = use_case.list_priorities(page_number, rows_per_page)
    if result.status_code >= 400:
        raise HTTPException(status_code=result.status_code, detail=result.message_user)
    return result
