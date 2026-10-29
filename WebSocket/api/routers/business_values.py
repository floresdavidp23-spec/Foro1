from fastapi import APIRouter
from fastapi.responses import JSONResponse
from domain.entities.BusinessValuesModels import BusinessValueCreate, BusinessValueUpdate
from infrastructure.repositories.CatalogsRepository import CatalogsRepository

router = APIRouter(prefix="/business-values", tags=["Business Values"])
repository = CatalogsRepository()


@router.get("/")
def list_business_values():
    result = repository.list_business_values()
    return JSONResponse(status_code=result.get("status_code", 200), content=result)


@router.post("/")
def insert_business_value(item: BusinessValueCreate):
    result = repository.insert_business_value(item)
    return JSONResponse(status_code=result.get("status_code", 200), content=result)


@router.put("/")
def update_business_value(item: BusinessValueUpdate):
    result = repository.update_business_value(item)
    return JSONResponse(status_code=result.get("status_code", 200), content=result)