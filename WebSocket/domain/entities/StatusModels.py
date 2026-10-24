from pydantic import BaseModel, field_validator
from datetime import datetime
from typing import Optional, List


class StatusBase(BaseModel):
    statusId: int
    statusName: str
    statusCreationDate: datetime
    statusCreatorId: int
    statusModificationDate: Optional[datetime] = None
    statusModificatorId: Optional[int] = None
    statusEnable: bool


class StatusCreate(BaseModel):
    statusName: str
    statusCreatorId: int
    statusEnable: bool = True

    @field_validator("statusName")
    @classmethod
    def validate_name(cls, value: str) -> str:
        value = value.strip()

        if not value:
            raise ValueError("El nombre del estado es obligatorio")

        if len(value) > 80:
            raise ValueError(
                "El nombre del estado no puede exceder 80 caracteres"
            )

        return value


class StatusUpdate(BaseModel):
    statusId: int
    statusName: Optional[str] = None
    statusModificatorId: int
    statusEnable: Optional[bool] = None
    statusModificationDate: Optional[datetime] = None

    @field_validator("statusName")
    @classmethod
    def validate_name(
        cls, value: Optional[str]
    ) -> Optional[str]:
        if value is None:
            return value

        value = value.strip()

        if not value:
            raise ValueError(
                "El nombre del estado no puede estar vacío"
            )

        if len(value) > 80:
            raise ValueError(
                "El nombre del estado no puede exceder 80 caracteres"
            )

        return value


class LtsStatus(BaseModel):
    statuses: List[StatusBase]
