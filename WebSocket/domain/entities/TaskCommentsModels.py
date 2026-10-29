from pydantic import BaseModel, Field
from datetime import datetime
from typing import Optional, List


class TaskCommentBase(BaseModel):
    taskCommentId: int
    taskCommentParentLink: int
    taskCommentOwner: int
    taskCommentText: str
    taskCommentCreationDate: datetime
    taskCommentCreatorId: int
    taskCommentModificationDate: Optional[datetime] = None
    taskCommentModificatorId: Optional[int] = None
    taskCommentStatus: bool


class TaskCommentCreate(BaseModel):
    taskCommentParentLink: int = Field(gt=0)
    taskCommentOwner: int = Field(gt=0)
    taskCommentText: str = Field(min_length=1, max_length=4000)
    taskCommentCreatorId: int = Field(gt=0)


class TaskCommentUpdate(BaseModel):
    taskCommentId: int = Field(gt=0)
    taskCommentParentLink: int = Field(gt=0)
    taskCommentOwner: int = Field(gt=0)
    taskCommentText: str = Field(min_length=1, max_length=4000)
    taskCommentModificatorId: int = Field(gt=0)
    taskCommentStatus: bool


class LtsTaskComments(BaseModel):
    taskComments: List[TaskCommentBase]
