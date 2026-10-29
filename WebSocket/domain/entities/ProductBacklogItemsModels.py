from pydantic import BaseModel, Field, model_validator
from datetime import date, datetime
from typing import Optional, List


class PBIBase(BaseModel):
    PBIId: int
    PBISummary: str
    PBIDescription: str
    PBIsAcceptanceCriteria: str  # la columna real lleva una "s" extra
    PBIOwner: int
    PBIParentLink: int
    PBIStoryPoint: Optional[int] = None
    PBIStartDate: Optional[date] = None
    PBIDueDate: Optional[date] = None
    PBIPriority: Optional[int] = None
    PBICreationDate: datetime
    PBICreatorId: int
    PBIModificationDate: Optional[datetime] = None
    PBIModificatorId: Optional[int] = None
    PBIStatus: int


class PBICreate(BaseModel):
    PBISummary: str = Field(min_length=1, max_length=500)
    PBIDescription: str = Field(min_length=1, max_length=2000)
    PBIAcceptanceCriteria: str = Field(min_length=1, max_length=4000)
    PBIOwner: int = Field(gt=0)
    PBIParentLink: int = Field(gt=0)
    PBIStoryPoint: Optional[int] = Field(default=None, ge=0)
    PBIStartDate: Optional[date] = None
    PBIDueDate: Optional[date] = None
    PBIPriority: Optional[int] = Field(default=None, gt=0)
    PBICreatorId: int = Field(gt=0)
    PBIStatus: int = Field(ge=0)

    @model_validator(mode="after")
    def validar_fechas(self):
        if self.PBIStartDate and self.PBIDueDate and self.PBIStartDate > self.PBIDueDate:
            raise ValueError("La fecha de inicio no puede ser posterior a la fecha de vencimiento.")
        return self


class PBIUpdate(BaseModel):
    PBIId: int = Field(gt=0)
    PBISummary: str = Field(min_length=1, max_length=500)
    PBIDescription: str = Field(min_length=1, max_length=2000)
    PBIAcceptanceCriteria: str = Field(min_length=1, max_length=4000)
    PBIOwner: int = Field(gt=0)
    PBIParentLink: int = Field(gt=0)
    PBIStoryPoint: Optional[int] = Field(default=None, ge=0)
    PBIStartDate: Optional[date] = None
    PBIDueDate: Optional[date] = None
    PBIPriority: Optional[int] = Field(default=None, gt=0)
    PBIModificatorId: int = Field(gt=0)
    PBIStatus: int = Field(ge=0)

    @model_validator(mode="after")
    def validar_fechas(self):
        if self.PBIStartDate and self.PBIDueDate and self.PBIStartDate > self.PBIDueDate:
            raise ValueError("La fecha de inicio no puede ser posterior a la fecha de vencimiento.")
        return self


class LtsPBI(BaseModel):
    pbis: List[PBIBase]
