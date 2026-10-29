from fastapi import APIRouter
from fastapi.responses import JSONResponse
from domain.entities.ActivityTypesModels import ActivityTypeCreate, ActivityTypeUpdate
from infrastructure.repositories.CatalogsRepository import CatalogsRepository

router = APIRouter(prefix="/activity-types", tags=["Activity Types"])
repository = CatalogsRepository()


@router.get("/")
def list_activity_types():
    result = repository.list_activity_types()
    return JSONResponse(status_code=result.get("status_code", 200), content=result)


@router.post("/")
def insert_activity_type(item: ActivityTypeCreate):
    result = repository.insert_activity_type(item)
    return JSONResponse(status_code=result.get("status_code", 200), content=result)


@router.put("/")
def update_activity_type(item: ActivityTypeUpdate):
    result = repository.update_activity_type(item)
    return JSONResponse(status_code=result.get("status_code", 200), content=result)