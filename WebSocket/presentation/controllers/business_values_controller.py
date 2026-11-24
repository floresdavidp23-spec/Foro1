import logging
from typing import Annotated

from fastapi import APIRouter, Depends, HTTPException, Query

from application.use_cases.BusinessValuesUseCase import BusinessValueUseCase
from domain.entities.BusinessValuesModels import BusinessValueCreate, BusinessValueUpdate
from infrastructure.repositories.BusinessValuesRepository import BusinessValuesRepository
from presentation.security import get_current_user
from presentation.states.generic_states import OperationResponse, QueryResponse


router = APIRouter(prefix="/websocket/business-values", tags=["Business Values"])
logger = logging.getLogger(__name__)


def get_business_value_use_case() -> BusinessValueUseCase:
    return BusinessValueUseCase(BusinessValuesRepository())


BusinessValueUseCaseDep = Annotated[BusinessValueUseCase, Depends(get_business_value_use_case)]
CurrentUserDep = Annotated[dict[str, int | str], Depends(get_current_user)]


@router.post("/create", response_model=OperationResponse, status_code=201)
def create_business_value(
    business_value: BusinessValueCreate,
    use_case: BusinessValueUseCaseDep,
    current_user: CurrentUserDep
):
    result = use_case.create_business_value(business_value, int(current_user["sub"]))
    if result.status_code >= 400:
        raise HTTPException(status_code=result.status_code, detail=result.message_user)
    return result


@router.put("/update", response_model=OperationResponse)
def update_business_value(
    business_value: BusinessValueUpdate,
    use_case: BusinessValueUseCaseDep,
    current_user: CurrentUserDep
):
    result = use_case.update_business_value(business_value, int(current_user["sub"]))
    if result.status_code >= 400:
        raise HTTPException(status_code=result.status_code, detail=result.message_user)
    return result


@router.get("/list", response_model=QueryResponse)
def list_business_values(
    use_case: BusinessValueUseCaseDep,
    current_user: CurrentUserDep,
    page_number: Annotated[int, Query(ge=1)] = 1,
    rows_per_page: Annotated[int, Query(ge=1, le=100)] = 10
):
    result = use_case.list_business_values(page_number, rows_per_page)
    if result.status_code >= 400:
        raise HTTPException(status_code=result.status_code, detail=result.message_user)
    return result
