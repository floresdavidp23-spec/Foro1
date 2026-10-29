from fastapi import APIRouter, HTTPException, Query
from fastapi.responses import JSONResponse
from domain.entities.UserModels import UserCreate, UserUpdate
from infrastructure.repositories.UsersRepository import UserRepository

router = APIRouter(prefix="/users", tags=["Usuarios"])
repository = UserRepository()


@router.get("/", status_code=200)
def list_users(page: int = Query(1, ge=1), rows: int = Query(10, ge=1, le=100)):
    result = repository.list_users(page_number=page, rows_per_page=rows)
    return result


@router.post("/", status_code=201)
def create_user(user: UserCreate):
    result = repository.insert_user(user)
    if result.get("status_code") not in [200, 201]:
        raise HTTPException(
            status_code=result.get("status_code", 400), 
            detail=result.get("message", "Error al crear el usuario")
        )
    return JSONResponse(status_code=result.get("status_code", 201), content=result)


@router.put("/", status_code=200)
def update_user(user: UserUpdate):
    result = repository.update_user(user)
    if result.get("status_code") not in [200, 201]:
        raise HTTPException(
            status_code=result.get("status_code", 400), 
            detail=result.get("message", "Error al actualizar el usuario")
        )
    return JSONResponse(status_code=result.get("status_code", 200), content=result)