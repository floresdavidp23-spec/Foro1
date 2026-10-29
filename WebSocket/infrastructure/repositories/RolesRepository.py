from infrastructure.database.connection import get_connection
from domain.entities.RolesModels import RoleCreate, RoleUpdate

class RolesRepository:
    def insert_role(self, role: RoleCreate):
        """
        Inserta un nuevo rol invocando [SQM_SECURITY].[USP_Roles] con @w_Accion = 'I'.
        """
        conn = get_connection()
        cursor = conn.cursor()

        o_Numero = 0
        o_MensajeTecnico = ""
        o_MensajeUsuario = ""

        cursor.execute("""
            EXEC [SQM_SECURITY].[USP_Roles]
                @i_rolName = ?,
                @i_rolCreatorId = ?,
                @w_Accion = 'I',
                @o_Numero = ? OUTPUT,
                @o_MensajeTecnico = ? OUTPUT,
                @o_MensajeUsuario = ? OUTPUT
        """, (
            role.rolName,
            role.rolCreatorId,
            o_Numero,
            o_MensajeTecnico,
            o_MensajeUsuario
        ))

        result = cursor.fetchone()
        conn.commit()
        cursor.close()
        conn.close()

        return {
            "status_code": result[0] if result else o_Numero,
            "message": result[2] if result and len(result) > 2 else o_MensajeUsuario
        }

    def update_role(self, role: RoleUpdate):
        """
        Actualiza un rol existente invocando [SQM_SECURITY].[USP_Roles] con @w_Accion = 'U'.
        """
        conn = get_connection()
        cursor = conn.cursor()

        o_Numero = 0
        o_MensajeTecnico = ""
        o_MensajeUsuario = ""

        cursor.execute("""
            EXEC [SQM_SECURITY].[USP_Roles]
                @i_rolId = ?,
                @i_rolName = ?,
                @i_rolModificatorId = ?,
                @i_rolEnable = ?,
                @w_Accion = 'U',
                @o_Numero = ? OUTPUT,
                @o_MensajeTecnico = ? OUTPUT,
                @o_MensajeUsuario = ? OUTPUT
        """, (
            role.rolId,
            role.rolName,
            role.rolModificatorId,
            role.rolEnable,
            o_Numero,
            o_MensajeTecnico,
            o_MensajeUsuario
        ))

        result = cursor.fetchone()
        conn.commit()
        cursor.close()
        conn.close()

        return {
            "status_code": result[0] if result else o_Numero,
            "message": result[2] if result and len(result) > 2 else o_MensajeUsuario
        }

    def list_roles(self, page_number: int = 1, rows_per_page: int = 10):
        """
        Lista roles con paginación invocando [SQM_SECURITY].[USP_Roles] con @w_Accion = 'S'.
        """
        conn = get_connection()
        cursor = conn.cursor()

        o_Numero = 0
        o_MensajeTecnico = ""
        o_MensajeUsuario = ""

        cursor.execute("""
            EXEC [SQM_SECURITY].[USP_Roles]
                @i_PageNumber = ?,
                @i_RowsPerPage = ?,
                @w_Accion = 'S',
                @o_Numero = ? OUTPUT,
                @o_MensajeTecnico = ? OUTPUT,
                @o_MensajeUsuario = ? OUTPUT
        """, (page_number, rows_per_page, o_Numero, o_MensajeTecnico, o_MensajeUsuario))

        columns = [col[0] for col in cursor.description] if cursor.description else []
        data = [dict(zip(columns, row)) for row in cursor.fetchall()]

        conn.commit()
        cursor.close()
        conn.close()

        return {
            "status_code": o_Numero,
            "message": o_MensajeUsuario,
            "data": data
        }
