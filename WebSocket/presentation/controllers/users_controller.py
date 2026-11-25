from fastapi import APIRouter, Depends, HTTPException

from application.use_cases.UsersUseCases import UserUseCase
from domain.entities.UserModels import UserCreate, UserLogin, UserUpdate
from presentation.dependencies.dependencies import get_user_use_case
from presentation.security import CurrentUserDep, create_access_token
from presentation.states.generic_states import (
    OperationResponse,
    QueryResponse,
    TokenResponse,
)

router = APIRouter(
    prefix="/websocket/users",
    tags=["Users"]
)


@router.post("/login", response_model=TokenResponse)
def login(
    user: UserLogin,
    use_case: UserUseCase = Depends(get_user_use_case)
):
    result = use_case.authenticate_user(user)
    if result.status_code >= 400:
        raise HTTPException(
            status_code=result.status_code,
            detail=result.message
        )

    user_data = result.data[0] if isinstance(result.data, list) and result.data else result.data
    user_id = user_data.get("UserID") or user_data.get("id")
    access_token = create_access_token(data={"sub": str(user_id)})

    return TokenResponse(
        access_token=access_token,
        token_type="bearer"
    )


@router.post("/create", response_model=OperationResponse)
def create_user(
    user: UserCreate,
    current_user: CurrentUserDep,
    use_case: UserUseCase = Depends(get_user_use_case)
):
    creator_id = int(current_user["sub"])
    result = use_case.create_user(user, creator_id)
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
def update_user(
    user: UserUpdate,
    current_user: CurrentUserDep,
    use_case: UserUseCase = Depends(get_user_use_case)
):
    modificator_id = int(current_user["sub"])
    result = use_case.update_user(user, modificator_id)
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
def list_users(
    current_user: CurrentUserDep,
    page_number: int = 1,
    rows_per_page: int = 10,
    use_case: UserUseCase = Depends(get_user_use_case)
):
    result = use_case.list_users(
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