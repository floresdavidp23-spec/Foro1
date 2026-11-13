from fastapi import APIRouter
from fastapi.responses import JSONResponse

from domain.entities.PrioritiesModels import PriorityCreate, PriorityUpdate
from infrastructure.repositories.CatalogsRepository import CatalogsRepository

router = APIRouter(prefix="/priorities", tags=["Priorities"])
repository = CatalogsRepository()


@router.get("/")
def list_priorities():
    result = repository.list_priorities()
    return JSONResponse(status_code=result.get("status_code", 200), content=result)


@router.post("/")
def insert_priority(item: PriorityCreate):
    result = repository.insert_priority(item)
    return JSONResponse(status_code=result.get("status_code", 200), content=result)


@router.put("/")
def update_priority(item: PriorityUpdate):
    result = repository.update_priority(item)
    return JSONResponse(status_code=result.get("status_code", 200), content=result)