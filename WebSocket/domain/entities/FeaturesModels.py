from pydantic import BaseModel
from datetime import datetime, date
from typing import Optional, List


class FeatureBase(BaseModel):
    featureId: int
    featureSummary: str
    featureDescription: str
<<<<<<< HEAD
    featureAcceptanceCriteria: str
=======
    featuresAcceptanceCriteria: str
>>>>>>> d1b2562 (Agrega main.py y todos los routers)
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
<<<<<<< HEAD
    featureAcceptanceCriteria: str
=======
    featuresAcceptanceCriteria: str
>>>>>>> d1b2562 (Agrega main.py y todos los routers)
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
<<<<<<< HEAD
    featureAcceptanceCriteria: Optional[str] = None
=======
    featuresAcceptanceCriteria: Optional[str] = None
>>>>>>> d1b2562 (Agrega main.py y todos los routers)
    featureOwner: Optional[int] = None
    featureParentLink: Optional[int] = None
    featurePriority: Optional[int] = None
    featureStartDate: Optional[date] = None
    featureDueDate: Optional[date] = None
    featureStatus: Optional[int] = None
    featureModificationDate: Optional[datetime] = None
    featureModificatorId: int


class LtsFeatures(BaseModel):
<<<<<<< HEAD
    features: List[FeatureBase]
=======
    features: List[FeatureBase]
>>>>>>> d1b2562 (Agrega main.py y todos los routers)
