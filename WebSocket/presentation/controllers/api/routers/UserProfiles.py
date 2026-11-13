endpoint user_profiles.py

from fastapi import APIRouter, HTTPException
from fastapi.responses import JSONResponse

from domain.entities.UserProfileModels import UserProfileCreate
from infrastructure.repositories.UsersRepository import UserRepository

router = APIRouter(prefix="/user-profiles", tags=["Perfil de Usuario"])
repository = UserRepository()


@router.post("/register", status_code=201)
def create_user_profile(profile: UserProfileCreate):
    """
    Endpoint maestro que registra de forma transaccional tanto a la persona (personData)
    como a su cuenta de usuario asociada (userData).
    """
    # 1. Registrar usuario usando userData y personData
    result = repository.insert_user(profile.userData)
    
    if result.get("status_code") not in [200, 201]:
        raise HTTPException(
            status_code=result.get("status_code", 400),
            detail=result.get("message", "Error al crear el perfil de usuario")
        )
        
    return JSONResponse(
        status_code=201,
        content={
            "status_code": 201,
            "message": "PERFIL DE USUARIO CREADO CORRECTAMENTE",
            "data": profile.model_dump()
        }
    )