from pydantic import BaseModel, field_validator
from datetime import datetime
from typing import Optional, List


class RoleBase(BaseModel):
    rolId: int
    rolName: str
    rolCreationDate: datetime
    rolCreatorId: int
    rolModificationDate: Optional[datetime] = None
    rolModificatorId: Optional[int] = None
    rolEnable: bool


class RoleCreate(BaseModel):
    rolName: str
    rolCreatorId: int
    rolEnable: bool = True

    @field_validator("rolName")
    @classmethod
    def validate_name(cls, value: str) -> str:
        value = value.strip()

        if not value:
            raise ValueError("El nombre del rol es obligatorio")

        if len(value) > 80:
            raise ValueError("El nombre del rol no puede exceder 80 caracteres")

        return value


class RoleUpdate(BaseModel):
    rolId: int
    rolName: Optional[str] = None
    rolModificatorId: int
    rolEnable: Optional[bool] = None
    rolModificationDate: Optional[datetime] = None

    @field_validator("rolName")
    @classmethod
    def validate_name(cls, value: Optional[str]) -> Optional[str]:
        if value is None:
            return value

        value = value.strip()

        if not value:
            raise ValueError("El nombre del rol no puede estar vacío")

        if len(value) > 80:
            raise ValueError("El nombre del rol no puede exceder 80 caracteres")

        return value


class LtsRoles(BaseModel):
    roles: List[RoleBase]
