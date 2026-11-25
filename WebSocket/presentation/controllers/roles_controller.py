from fastapi import APIRouter, Depends, HTTPException

from application.use_cases.RolesUseCases import RoleUseCase
from domain.entities.RolesModels import RoleCreate, RoleUpdate
from presentation.dependencies.dependencies import get_role_use_case
from presentation.security import CurrentUserDep
from presentation.states.generic_states import OperationResponse, QueryResponse

router = APIRouter(
    prefix="/websocket/roles",
    tags=["Roles"]
)


@router.post("/create", response_model=OperationResponse)
def create_role(
    role: RoleCreate,
    current_user: CurrentUserDep,
    use_case: RoleUseCase = Depends(get_role_use_case)
):
    creator_id = int(current_user["sub"])
    result = use_case.create_role(role, creator_id)
    if result.status_code >= 400:
        raise HTTPException(
            status_code=result.status_code,
            detail=result.message_user
        )

    return OperationResponse(
        status_code=result.status_code,
        message=result.message_user
    )


@router.put("/update", response_model=OperationResponse)
def update_role(
    role: RoleUpdate,
    current_user: CurrentUserDep,
    use_case: RoleUseCase = Depends(get_role_use_case)
):
    modificator_id = int(current_user["sub"])
    result = use_case.update_role(role, modificator_id)
    if result.status_code >= 400:
        raise HTTPException(
            status_code=result.status_code,
            detail=result.message_user
        )

    return OperationResponse(
        status_code=result.status_code,
        message=result.message_user
    )


@router.get("/list", response_model=QueryResponse)
def list_roles(
    current_user: CurrentUserDep,
    page_number: int = 1,
    rows_per_page: int = 10,
    use_case: RoleUseCase = Depends(get_role_use_case)
):
    result = use_case.list_roles(
        page_number=page_number,
        rows_per_page=rows_per_page
    )
    if result.status_code >= 400:
        raise HTTPException(
            status_code=result.status_code,
            detail=result.message_user
        )

    return QueryResponse(
        status_code=result.status_code,
        message=result.message_user,
        data=result.data
    )