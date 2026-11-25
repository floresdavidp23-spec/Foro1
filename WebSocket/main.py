from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from presentation.controllers.activity_types_controller import router as activity_types_router
from presentation.controllers.business_values_controller import router as business_values_router
from presentation.controllers.epics_controller import router as epics_router
from presentation.controllers.features_controller import router as features_router
from presentation.controllers.initiatives_controller import router as initiatives_router
from presentation.controllers.priorities_controller import router as priorities_router
from presentation.controllers.product_backlog_items_controller import router as pbi_router
from presentation.controllers.roles_controller import router as roles_router
from presentation.controllers.status_controller import router as status_router
from presentation.controllers.task_comments_controller import router as task_comments_router
from presentation.controllers.tasks_controller import router as tasks_router
from presentation.controllers.users_controller import router as users_router

app = FastAPI(
    title="Foro 1 - DB_SCRUM_PLANNING",
    version="1.0.0"
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "http://localhost:5173",
        "http://127.0.0.1:5173",
    ],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(users_router)
app.include_router(roles_router)
app.include_router(status_router)
app.include_router(epics_router)
app.include_router(features_router)
app.include_router(initiatives_router)
app.include_router(activity_types_router)
app.include_router(business_values_router)
app.include_router(priorities_router)
app.include_router(pbi_router)
app.include_router(tasks_router)
app.include_router(task_comments_router)