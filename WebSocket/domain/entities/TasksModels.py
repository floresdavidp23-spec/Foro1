from pydantic import BaseModel, Field, model_validator
from datetime import date, datetime
from typing import Optional, List


class TaskBase(BaseModel):
    taskId: int
    taskSummary: str
    taskDescription: str
    taskOwner: int
    taskParentLink: int
    taskOriginalEstimate: Optional[float] = None
    taskCompletedWork: Optional[float] = None
    taskRemaningWork: Optional[float] = None
    taskStartDate: Optional[date] = None
    taskCompletedDate: Optional[date] = None
    taskDueDate: Optional[date] = None
    taskActivityType: Optional[int] = None
    taskCreationDate: datetime
    taskCreatorId: int
    taskModificationDate: Optional[datetime] = None
    taskModificatorId: Optional[int] = None
    taskStatus: int


class TaskCreate(BaseModel):
    taskSummary: str = Field(min_length=1, max_length=500)
    taskDescription: str = Field(min_length=1, max_length=2000)
    taskOwner: int = Field(gt=0)
    taskParentLink: int = Field(gt=0)
    taskOriginalEstimate: Optional[int] = Field(default=None, ge=0)
    taskCompletedWork: Optional[int] = Field(default=None, ge=0)
    taskRemaningWork: Optional[int] = Field(default=None, ge=0)
    taskStartDate: Optional[date] = None
    taskCompletedDate: Optional[date] = None
    taskDueDate: Optional[date] = None
    taskActivityType: Optional[int] = Field(default=None, gt=0)
    taskCreatorId: int = Field(gt=0)
    taskStatus: int = Field(ge=0)

    @model_validator(mode="after")
    def validar_fechas(self):
        if self.taskStartDate and self.taskDueDate and self.taskStartDate > self.taskDueDate:
            raise ValueError("La fecha de inicio no puede ser posterior al vencimiento.")
        if self.taskStartDate and self.taskCompletedDate and self.taskCompletedDate < self.taskStartDate:
            raise ValueError("La fecha de finalizacion no puede ser anterior al inicio.")
        return self


class TaskUpdate(BaseModel):
    taskId: int = Field(gt=0)
    taskSummary: str = Field(min_length=1, max_length=500)
    taskDescription: str = Field(min_length=1, max_length=2000)
    taskOwner: int = Field(gt=0)
    taskParentLink: int = Field(gt=0)
    taskOriginalEstimate: Optional[int] = Field(default=None, ge=0)
    taskCompletedWork: Optional[int] = Field(default=None, ge=0)
    taskRemaningWork: Optional[int] = Field(default=None, ge=0)
    taskStartDate: Optional[date] = None
    taskCompletedDate: Optional[date] = None
    taskDueDate: Optional[date] = None
    taskActivityType: Optional[int] = Field(default=None, gt=0)
    taskModificatorId: int = Field(gt=0)
    taskStatus: int = Field(ge=0)

    @model_validator(mode="after")
    def validar_fechas(self):
        if self.taskStartDate and self.taskDueDate and self.taskStartDate > self.taskDueDate:
            raise ValueError("La fecha de inicio no puede ser posterior al vencimiento.")
        if self.taskStartDate and self.taskCompletedDate and self.taskCompletedDate < self.taskStartDate:
            raise ValueError("La fecha de finalizacion no puede ser anterior al inicio.")
        return self


class LtsTasks(BaseModel):
    tasks: List[TaskBase]
