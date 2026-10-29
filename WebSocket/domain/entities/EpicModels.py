from pydantic import BaseModel
from datetime import datetime, date
from typing import Optional, List

class EpicBase(BaseModel):
    epicId: int
    epicName: str
    epicSummary: str
    epicDescription: str
    epicOwner: int
    epicParentLink: Optional[int] = None
    epicPriority: Optional[int] = None
    epicStartDate: Optional[date] = None
    epicDueDate: Optional[date] = None
    epicCreationDate: datetime
    epicCreatorId: int
    epicModificationDate: Optional[datetime] = None
    epicModificatorId: Optional[int] = None
    epicStatus: int


class EpicCreate(BaseModel):
    epicName: str
    epicSummary: str
    epicDescription: str
    epicOwner: int
    epicParentLink: Optional[int] = None
    epicPriority: Optional[int] = None
    epicStartDate: Optional[date] = None
    epicDueDate: Optional[date] = None
    epicCreatorId: int
    epicStatus: int


class EpicUpdate(BaseModel):
    epicId: int
    epicName: Optional[str] = None
    epicSummary: Optional[str] = None
    epicDescription: Optional[str] = None
    epicOwner: Optional[int] = None
    epicParentLink: Optional[int] = None
    epicPriority: Optional[int] = None
    epicStartDate: Optional[date] = None
    epicDueDate: Optional[date] = None
    epicStatus: Optional[int] = None
    epicModificationDate: Optional[datetime] = None
    epicModificatorId: int


class LtsEpics(BaseModel):
    epics: List[EpicBase]
