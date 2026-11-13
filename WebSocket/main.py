from fastapi import FastAPI

from presentation.controllers.api.routers import ( epics,features,initiatives,activity_types,business_values,priorities,roles,status,users,)
from presentation.controllers.epics_controller import router as epics_router
from presentation.controllers.features_controller import router as features_router
from presentation.controllers.initiatives_controller import router as initiatives_router

app = FastAPI(
    title="Foro 1 - DB_SCRUM_PLANNING",
    version="1.0.0"
    )

app.include_router(epics.router)
app.include_router(features.router)
app.include_router(initiatives.router)
app.include_router(activity_types.router)
app.include_router(business_values.router)
app.include_router(priorities.router)
app.include_router(roles.router)
app.include_router(status.router)
app.include_router(users.router)