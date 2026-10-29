from fastapi import APIRouter, Depends, Query, WebSocket
from starlette.concurrency import run_in_threadpool

from domain.entities.TasksModels import TaskCreate, TaskUpdate
from infrastructure.repositories.TasksRepository import TasksRepository
from infrastructure.websocket.ConnectionManager import ConnectionManager, serve_websocket

router = APIRouter(tags=["Tasks"])
manager = ConnectionManager()


def get_repository() -> TasksRepository:
    return TasksRepository()


@router.post("/api/tasks", status_code=201)
async def create_task(task: TaskCreate, repo: TasksRepository = Depends(get_repository)):
    result = await run_in_threadpool(repo.insert_task, task)
    await manager.broadcast("created", "task", task.model_dump())
    return result


@router.put("/api/tasks")
async def update_task(task: TaskUpdate, repo: TasksRepository = Depends(get_repository)):
    result = await run_in_threadpool(repo.update_task, task)
    await manager.broadcast("updated", "task", task.model_dump())
    return result


@router.get("/api/tasks")
async def list_tasks(
    page: int = Query(1, ge=1),
    rows: int = Query(10, ge=1, le=100),
    repo: TasksRepository = Depends(get_repository),
):
    return await run_in_threadpool(repo.list_tasks, page, rows)


@router.websocket("/ws/tasks")
async def ws_tasks(websocket: WebSocket, repo: TasksRepository = Depends(get_repository)):
    await serve_websocket(websocket, manager, "task", repo.list_tasks)