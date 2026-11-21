from fastapi import APIRouter, Depends, HTTPException

from application.use_cases.StatusUseCase import StatusUseCase
from domain.entities.StatusModels import StatusCreate, StatusUpdate
from presentation.dependencies.dependencies import get_status_use_case
from presentation.security import CurrentUserDep
from presentation.states.generic_states import OperationResponse, QueryResponse

router = APIRouter(
    prefix="/websocket/status",
    tags=["Status"]
)


@router.post("/create", response_model=OperationResponse)
def create_status(
    status: StatusCreate,
    current_user: CurrentUserDep,
    use_case: StatusUseCase = Depends(get_status_use_case)
):
    creator_id = int(current_user["sub"])
    result = use_case.create_status(status, creator_id)
    if result.status_code >= 400:
        raise HTTPException(
            status_code=result.status_code,
            detail=result.message
        )

    return OperationResponse(
        status_code=result.status_code,
        message=result.message
    )


@router.put("/update", response_model=OperationResponse)
def update_status(
    status: StatusUpdate,
    current_user: CurrentUserDep,
    use_case: StatusUseCase = Depends(get_status_use_case)
):
    modificator_id = int(current_user["sub"])
    result = use_case.update_status(status, modificator_id)
    if result.status_code >= 400:
        raise HTTPException(
            status_code=result.status_code,
            detail=result.message
        )

    return OperationResponse(
        status_code=result.status_code,
        message=result.message
    )


@router.get("/list", response_model=QueryResponse)
def list_statuses(
    current_user: CurrentUserDep,
    page_number: int = 1,
    rows_per_page: int = 10,
    use_case: StatusUseCase = Depends(get_status_use_case)
):
    result = use_case.list_statuses(
        page_number=page_number,
        rows_per_page=rows_per_page
    )
    if result.status_code >= 400:
        raise HTTPException(
            status_code=result.status_code,
            detail=result.message
        )

    return QueryResponse(
        status_code=result.status_code,
        message=result.message,
        data=result.data
    )