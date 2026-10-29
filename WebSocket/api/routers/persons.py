endPoint de persons.py

from fastapi import APIRouter, HTTPException, Query
from fastapi.responses import JSONResponse

from domain.entities.PersonModels import PersonCreate
from infrastructure.repositories.UsersRepository import UserRepository

router = APIRouter(prefix="/persons", tags=["Personas"])
repository = UserRepository()


@router.get("/", status_code=200)
def list_persons(
    page: int = Query(1, ge=1), 
    rows: int = Query(10, ge=1, le=100)
):
    """
    Lista las personas registradas en el sistema con paginación.
    """
    result = repository.list_users()  # O invocar el procedimiento correspondiente a personas
    return result


@router.post("/", status_code=201)
def create_person(person: PersonCreate):
    """
    Registra una nueva persona con sus datos de identidad (DNI, nombres, apellidos).
    """
    # Lógica de inserción de persona
    return JSONResponse(
        status_code=201, 
        content={"status_code": 201, "message": "PERSONA REGISTRADA CORRECTAMENTE", "data": person.model_dump()}
    )