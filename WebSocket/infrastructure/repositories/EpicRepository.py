from infrastructure.database.connection import get_connection
from Foro1.WebSocket.domain.entities.EpicModels import EpicCreate, EpicUpdate


class EpicRepository:

    def insert_epic(self, epic: EpicCreate):
        conn = get_connection()
        cursor = conn.cursor()

        o_Numero = 0
        o_MensajeTecnico = ""
        o_MensajeUsuario = ""

        cursor.execute("""
            EXEC [SQM_GENERAL].[USP_Epics]
                @i_epicName = ?,
                @i_epicSummary = ?,
                @i_epicDescription = ?,
                @i_epicOwner = ?,
                @i_epicParentLink = ?,
                @i_epicPriority = ?,
                @i_epicStartDate = ?,
                @i_epicDueDate = ?,
                @i_epicCreatorId = ?,
                @i_epicStatus = ?,
                @w_Accion = 'I',
                @o_Numero = ? OUTPUT,
                @o_MensajeTecnico = ? OUTPUT,
                @o_MensajeUsuario = ? OUTPUT
        """, (
            epic.epicName,
            epic.epicSummary,
            epic.epicDescription,
            epic.epicOwner,
            epic.epicParentLink,
            epic.epicPriority,
            epic.epicStartDate,
            epic.epicDueDate,
            epic.epicCreatorId,
            epic.epicStatus,
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
            "message": result[1] if result else o_MensajeUsuario
        }

    def update_epic(self, epic: EpicUpdate):
        conn = get_connection()
        cursor = conn.cursor()

        o_Numero = 0
        o_MensajeTecnico = ""
        o_MensajeUsuario = ""

        cursor.execute("""
            EXEC [SQM_GENERAL].[USP_Epics]
                @i_epicId = ?,
                @i_epicName = ?,
                @i_epicSummary = ?,
                @i_epicDescription = ?,
                @i_epicOwner = ?,
                @i_epicParentLink = ?,
                @i_epicPriority = ?,
                @i_epicStartDate = ?,
                @i_epicDueDate = ?,
                @i_epicModificatorId = ?,
                @i_epicStatus = ?,
                @w_Accion = 'U',
                @o_Numero = ? OUTPUT,
                @o_MensajeTecnico = ? OUTPUT,
                @o_MensajeUsuario = ? OUTPUT
        """, (
            epic.epicId,
            epic.epicName,
            epic.epicSummary,
            epic.epicDescription,
            epic.epicOwner,
            epic.epicParentLink,
            epic.epicPriority,
            epic.epicStartDate,
            epic.epicDueDate,
            epic.epicModificatorId,
            epic.epicStatus,
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
            "message": result[1] if result else o_MensajeUsuario
        }

    def list_epics(self):
        """
        Lista todas las épicas (Acción 'S').
        """
        conn = get_connection()
        cursor = conn.cursor()

        o_Numero = 0
        o_MensajeTecnico = ""
        o_MensajeUsuario = ""

        cursor.execute("""
            EXEC [SQM_GENERAL].[USP_Epics]
                @w_Accion = 'S',
                @o_Numero = ? OUTPUT,
                @o_MensajeTecnico = ? OUTPUT,
                @o_MensajeUsuario = ? OUTPUT
        """, (
            o_Numero,
            o_MensajeTecnico,
            o_MensajeUsuario
        ))

        columns = [col[0] for col in cursor.description]
        data = [dict(zip(columns, row)) for row in cursor.fetchall()]

        conn.commit()
        cursor.close()
        conn.close()

        return {
            "status_code": o_Numero,
            "message": o_MensajeUsuario,
            "data": data
        }
