from domain.entities.BusinessValuesModels import BusinessValueCreate, BusinessValueUpdate
from domain.interfaces.IBusinessValuesRepository import IBusinessValuesRepository


class BusinessValueUseCase:

    def __init__(self, repository: IBusinessValuesRepository):
        self.repository = repository

    def create_business_value(self, business_value: BusinessValueCreate, creator_id: int):
        return self.repository.insert_business_value(business_value, creator_id)

    def update_business_value(self, business_value: BusinessValueUpdate, modificator_id: int):
        return self.repository.update_business_value(business_value, modificator_id)

    def list_business_values(self, page_number: int, rows_per_page: int):
        return self.repository.list_business_values(
            page_number=page_number,
            rows_per_page=rows_per_page
        )
