from domain.entities.RolesModels import RoleCreate, RoleUpdate
from domain.interfaces.IrolesRepository import IRolesRepository


class RoleUseCase:

    def __init__(
        self,
        repository: IRolesRepository
    ):
        self.repository = repository

    def create_role(self, role: RoleCreate, creator_id: int):
        return self.repository.insert_role(role, creator_id)

    def update_role(self, role: RoleUpdate, modificator_id: int):
        return self.repository.update_role(role, modificator_id)

    def list_roles(
        self,
        page_number: int,
        rows_per_page: int
    ):
        return self.repository.list_roles(
            page_number=page_number,
            rows_per_page=rows_per_page
        )