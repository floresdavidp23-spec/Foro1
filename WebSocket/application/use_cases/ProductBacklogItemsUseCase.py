from domain.entities.ProductBacklogItemsModels import PBICreate, PBIUpdate
from domain.interfaces.IProductBacklogItemsRepository import IProductBacklogItemsRepository


class ProductBacklogItemsUseCase:

    def __init__(self, repository: IProductBacklogItemsRepository):
        self.repository = repository

    def create_pbi(self, pbi: PBICreate, creator_id: int):
        return self.repository.insert_pbi(pbi, creator_id)

    def update_pbi(self, pbi: PBIUpdate, modificator_id: int):
        return self.repository.update_pbi(pbi, modificator_id)

    def list_pbis(self, page_number: int, rows_per_page: int):
        return self.repository.list_pbis(
            page_number=page_number,
            rows_per_page=rows_per_page
        )
