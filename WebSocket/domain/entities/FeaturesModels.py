from pydantic import BaseModel
from datetime import datetime, date
from typing import Optional, List


class FeatureBase(BaseModel):
    featureId: int
    featureSummary: str
    featureDescription: str
    featureAcceptanceCriteria: str
    featureOwner: int
    featureParentLink: int
    featurePriority: Optional[int] = None
    featureStartDate: Optional[date] = None
    featureDueDate: Optional[date] = None
    featureCreationDate: datetime
    featureCreatorId: int
    featureModificationDate: Optional[datetime] = None
    featureModificatorId: Optional[int] = None
    featureStatus: int


class FeatureCreate(BaseModel):
    featureSummary: str
    featureDescription: str
    featureAcceptanceCriteria: str
    featureOwner: int
    featureParentLink: int
    featurePriority: Optional[int] = None
    featureStartDate: Optional[date] = None
    featureDueDate: Optional[date] = None
    featureCreatorId: int
    featureStatus: int


class FeatureUpdate(BaseModel):
    featureId: int
    featureSummary: Optional[str] = None
    featureDescription: Optional[str] = None
    featureAcceptanceCriteria: Optional[str] = None
    featureOwner: Optional[int] = None
    featureParentLink: Optional[int] = None
    featurePriority: Optional[int] = None
    featureStartDate: Optional[date] = None
    featureDueDate: Optional[date] = None
    featureStatus: Optional[int] = None
    featureModificationDate: Optional[datetime] = None
    featureModificatorId: int


class LtsFeatures(BaseModel):
    features: List[FeatureBase]
