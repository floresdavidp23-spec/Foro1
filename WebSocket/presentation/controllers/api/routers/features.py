from fastapi import APIRouter
from fastapi.responses import JSONResponse
from Foro1.WebSocket.domain.entities.FeaturesModels import FeatureCreate, FeatureUpdate
from infrastructure.repositories.FeaturesRepository import FeatureRepository

router = APIRouter(prefix="/features", tags=["Features"])
repository = FeatureRepository()


@router.get("/")
def list_features():
    return repository.list_features()


@router.post("/")
def insert_feature(feature: FeatureCreate):
    result = repository.insert_feature(feature)
    return JSONResponse(status_code=result["status_code"], content=result)


@router.put("/")
def update_feature(feature: FeatureUpdate):
    result = repository.update_feature(feature)
    return JSONResponse(status_code=result["status_code"], content=result)