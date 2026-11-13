import logging
from typing import Annotated

from fastapi import APIRouter
from fastapi import Depends
from fastapi import HTTPException
from fastapi import Query

from application.use_cases.InitiativeUseCases import InitiativeUseCase
from domain.entities.InitiativesModels import InitiativeCreate, InitiativeUpdate

from infrastructure.repositories.InitiativeRepository import InitiativeRepository
from presentation.security import get_current_user

from presentation.states.generic_states import (
    OperationResponse,
    QueryResponse
)


router = APIRouter(
    prefix="/websocket/initiatives",
    tags=["Initiatives"]
)
logger = logging.getLogger(__name__)


def get_initiative_use_case() -> InitiativeUseCase:
    return InitiativeUseCase(
        InitiativeRepository()
    )


InitiativeUseCaseDep = Annotated[
    InitiativeUseCase,
    Depends(get_initiative_use_case)
]
CurrentUserDep = Annotated[dict[str, int | str], Depends(get_current_user)]


@router.post(
    "/create",
    response_model=OperationResponse,
    status_code=201
)
def create_initiative(
    initiative: InitiativeCreate,
    use_case: InitiativeUseCaseDep,
    current_user: CurrentUserDep
):

    result = use_case.create_initiative(initiative, int(current_user["sub"]))

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
def update_initiative(
    initiative: InitiativeUpdate,
    use_case: InitiativeUseCaseDep,
    current_user: CurrentUserDep
):

    result = use_case.update_initiative(initiative, int(current_user["sub"]))

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
def list_initiatives(
    use_case: InitiativeUseCaseDep,
    current_user: CurrentUserDep,
    page_number: Annotated[int, Query(ge=1)] = 1,
    rows_per_page: Annotated[int, Query(ge=1, le=100)] = 10
):

    result = use_case.list_initiatives(
        page_number=page_number,
        rows_per_page=rows_per_page
    )

    if result.status_code >= 400:
        raise HTTPException(
            status_code=result.status_code,
            detail=result.message_user
        )

    return result