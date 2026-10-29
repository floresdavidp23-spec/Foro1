from fastapi import APIRouter, HTTPException, Query
from fastapi.responses import JSONResponse
from domain.entities.StatusModels import StatusCreate, StatusUpdate
from infrastructure.repositories.StatusRepository import StatusRepository

router = APIRouter(prefix="/status", tags=["Estados"])
repository = StatusRepository()


@router.get("/", status_code=200)
def list_statuses(page: int = Query(1, ge=1), rows: int = Query(10, ge=1, le=100)):
    result = repository.list_statuses(page_number=page, rows_per_page=rows)
    return result


@router.post("/", status_code=201)
def create_status(status: StatusCreate):
    result = repository.insert_status(status)
    if result.get("status_code") not in [200, 201]:
        raise HTTPException(
            status_code=result.get("status_code", 400), 
            detail=result.get("message", "Error al crear el estado")
        )
    return JSONResponse(status_code=result.get("status_code", 201), content=result)


@router.put("/", status_code=200)
def update_status(status: StatusUpdate):
    result = repository.update_status(status)
    if result.get("status_code") not in [200, 201]:
        raise HTTPException(
            status_code=result.get("status_code", 400), 
            detail=result.get("message", "Error al actualizar el estado")
        )
    return JSONResponse(status_code=result.get("status_code", 200), content=result)