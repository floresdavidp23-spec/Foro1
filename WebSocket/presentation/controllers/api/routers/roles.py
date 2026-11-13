from fastapi import APIRouter, HTTPException, Query
from fastapi.responses import JSONResponse
from domain.entities.RolesModels import RoleCreate, RoleUpdate
from infrastructure.repositories.RolesRepository import RolesRepository

router = APIRouter(prefix="/roles", tags=["Roles"])
repository = RolesRepository()


@router.get("/")
def list_roles(page: int = Query(1, ge=1), rows: int = Query(10, ge=1, le=100)):
    result = repository.list_roles(page_number=page, rows_per_page=rows)
    return result


@router.post("/")
def create_role(role: RoleCreate):
    result = repository.insert_role(role)
    if result.get("status_code") not in [200, 201]:
        raise HTTPException(
            status_code=result.get("status_code", 400), 
            detail=result.get("message", "Error al crear el rol")
        )
    return JSONResponse(status_code=result.get("status_code", 201), content=result)


@router.put("/")
def update_role(role: RoleUpdate):
    result = repository.update_role(role)
    if result.get("status_code") not in [200, 201]:
        raise HTTPException(
            status_code=result.get("status_code", 400), 
            detail=result.get("message", "Error al actualizar el rol")
        )
    return JSONResponse(status_code=result.get("status_code", 200), content=result)