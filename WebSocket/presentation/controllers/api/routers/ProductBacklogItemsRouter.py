from fastapi import APIRouter, Depends, Query, WebSocket
from starlette.concurrency import run_in_threadpool
from domain.entities.ProductBacklogItemsModels import PBICreate, PBIUpdate
from infrastructure.repositories.ProductBacklogItemsRepository import ProductBacklogItemsRepository
from infrastructure.websocket.ConnectionManager import ConnectionManager, serve_websocket

router = APIRouter(tags=["Product Backlog Items"])
manager = ConnectionManager()


def get_repository() -> ProductBacklogItemsRepository:
    return ProductBacklogItemsRepository()


@router.post("/api/pbis", status_code=201)
async def create_pbi(pbi: PBICreate, repo: ProductBacklogItemsRepository = Depends(get_repository)):
    result = await run_in_threadpool(repo.insert_pbi, pbi)
    await manager.broadcast("created", "pbi", pbi.model_dump())
    return result


@router.put("/api/pbis")
async def update_pbi(pbi: PBIUpdate, repo: ProductBacklogItemsRepository = Depends(get_repository)):
    result = await run_in_threadpool(repo.update_pbi, pbi)
    await manager.broadcast("updated", "pbi", pbi.model_dump())
    return result


@router.get("/api/pbis")
async def list_pbis(
    page: int = Query(1, ge=1),
    rows: int = Query(10, ge=1, le=100),
    repo: ProductBacklogItemsRepository = Depends(get_repository),
):
    return await run_in_threadpool(repo.list_pbis, page, rows)


@router.websocket("/ws/pbis")
async def ws_pbis(websocket: WebSocket, repo: ProductBacklogItemsRepository = Depends(get_repository)):
    await serve_websocket(websocket, manager, "pbi", repo.list_pbis)