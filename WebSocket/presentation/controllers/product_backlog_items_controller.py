import logging
from typing import Annotated

from fastapi import APIRouter, Depends, HTTPException, Query

from application.use_cases.ProductBacklogItemsUseCase import ProductBacklogItemsUseCase
from domain.entities.ProductBacklogItemsModels import PBICreate, PBIUpdate
from infrastructure.repositories.ProductBacklogItemsRepository import ProductBacklogItemsRepository
from presentation.security import get_current_user
from presentation.states.generic_states import OperationResponse, QueryResponse


router = APIRouter(prefix="/websocket/product-backlog-items", tags=["Product Backlog Items"])
logger = logging.getLogger(__name__)


def get_product_backlog_items_use_case() -> ProductBacklogItemsUseCase:
    return ProductBacklogItemsUseCase(ProductBacklogItemsRepository())


ProductBacklogItemsUseCaseDep = Annotated[
    ProductBacklogItemsUseCase,
    Depends(get_product_backlog_items_use_case)
]
CurrentUserDep = Annotated[dict[str, int | str], Depends(get_current_user)]


@router.post("/create", response_model=OperationResponse, status_code=201)
def create_pbi(
    pbi: PBICreate,
    use_case: ProductBacklogItemsUseCaseDep,
    current_user: CurrentUserDep
):
    result = use_case.create_pbi(pbi, int(current_user["sub"]))
    if result.status_code >= 400:
        raise HTTPException(status_code=result.status_code, detail=result.message_user)
    return result


@router.put("/update", response_model=OperationResponse)
def update_pbi(
    pbi: PBIUpdate,
    use_case: ProductBacklogItemsUseCaseDep,
    current_user: CurrentUserDep
):
    result = use_case.update_pbi(pbi, int(current_user["sub"]))
    if result.status_code >= 400:
        raise HTTPException(status_code=result.status_code, detail=result.message_user)
    return result


@router.get("/list", response_model=QueryResponse)
def list_pbis(
    use_case: ProductBacklogItemsUseCaseDep,
    current_user: CurrentUserDep,
    page_number: Annotated[int, Query(ge=1)] = 1,
    rows_per_page: Annotated[int, Query(ge=1, le=100)] = 10
):
    result = use_case.list_pbis(page_number, rows_per_page)
    if result.status_code >= 400:
        raise HTTPException(status_code=result.status_code, detail=result.message_user)
    return result
