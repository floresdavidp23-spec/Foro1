from fastapi import APIRouter
from fastapi.responses import JSONResponse
from Foro1.WebSocket.domain.entities.EpicModels import EpicCreate, EpicUpdate
from infrastructure.repositories.EpicRepository import EpicRepository

router = APIRouter(prefix="/epics", tags=["Epics"])
repository = EpicRepository()


@router.get("/")
def list_epics():
    return repository.list_epics()


@router.post("/")
def insert_epic(epic: EpicCreate):
    result = repository.insert_epic(epic)
    return JSONResponse(status_code=result["status_code"], content=result)


@router.put("/")
def update_epic(epic: EpicUpdate):
    result = repository.update_epic(epic)
    return JSONResponse(status_code=result["status_code"], content=result)