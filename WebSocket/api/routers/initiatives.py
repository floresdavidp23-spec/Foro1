from fastapi import APIRouter
from fastapi.responses import JSONResponse
from Foro1.WebSocket.domain.entities.InitiativeModels import InitiativeCreate, InitiativeUpdate
from infrastructure.repositories.IntiativeRepository import InitiativeRepository

router = APIRouter(prefix="/initiatives", tags=["Initiatives"])
repository = InitiativeRepository()


@router.get("/")
def list_initiatives():
    return repository.list_initiatives()


@router.post("/")
def insert_initiative(initiative: InitiativeCreate):
    result = repository.insert_initiative(initiative)
    return JSONResponse(status_code=result["status_code"], content=result)


@router.put("/")
def update_initiative(initiative: InitiativeUpdate):
    result = repository.update_initiative(initiative)
    return JSONResponse(status_code=result["status_code"], content=result)