import logging
from typing import Annotated

from fastapi import APIRouter
from fastapi import Depends
from fastapi import HTTPException
from fastapi import Query

from application.use_cases.EpicsUseCases import EpicUseCase
from domain.entities.EpicModels import EpicCreate, EpicUpdate

from infrastructure.repositories.EpicRepository import EpicRepository
from presentation.security import get_current_user

from presentation.states.generic_states import (
    OperationResponse,
    QueryResponse
)


router = APIRouter(
    prefix="/websocket/epics",
    tags=["Epics"]
)
logger = logging.getLogger(__name__)


def get_epic_use_case() -> EpicUseCase:
    return EpicUseCase(
        EpicRepository()
    )


EpicUseCaseDep = Annotated[
    EpicUseCase,
    Depends(get_epic_use_case)
]
CurrentUserDep = Annotated[dict[str, int | str], Depends(get_current_user)]


@router.post(
    "/create",
    response_model=OperationResponse,
    status_code=201
)
def create_epic(
    epic: EpicCreate,
    use_case: EpicUseCaseDep,
    current_user: CurrentUserDep
):

    result = use_case.create_epic(epic, int(current_user["sub"]))

    if result.status_code >= 400:
        raise HTTPException(
            status_code=result.status_code,
            detail=result.message_user
        )

    return result


@router.put(
    "/update",
    response_model=OperationResponse
)
def update_epic(
    epic: EpicUpdate,
    use_case: EpicUseCaseDep,
    current_user: CurrentUserDep
):

    result = use_case.update_epic(epic, int(current_user["sub"]))

    if result.status_code >= 400:
        raise HTTPException(
            status_code=result.status_code,
            detail=result.message_user
        )

    return result


@router.get(
    "/list",
    response_model=QueryResponse
)
def list_epics(
    use_case: EpicUseCaseDep,
    current_user: CurrentUserDep,
    page_number: Annotated[int, Query(ge=1)] = 1,
    rows_per_page: Annotated[int, Query(ge=1, le=100)] = 10
):

    result = use_case.list_epics(
        page_number=page_number,
        rows_per_page=rows_per_page
    )

    if result.status_code >= 400:
        raise HTTPException(
            status_code=result.status_code,
            detail=result.message_user
        )

    return result