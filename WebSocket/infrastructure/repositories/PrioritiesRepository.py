from typing import Tuple, List, Dict, Any, Optional
from infrastructure.database.connection import get_db_connection

class PrioritiesRepository:

@staticmethod
    def execute_usp_priorities(
        accion: str,
        priority_id: Optional[int] = None,
        priority_name: Optional[str] = None,
        creator_id: Optional[int] = None,
        modificator_id: Optional[int] = None,
        enable: Optional[bool] = None,
        page_number: int = 1,
        rows_per_page: int = 10
    ) -> Tuple[int, str, str, List[Dict[str, Any]]]:
        
        conn = get_db_connection()
        cursor = conn.cursor()
        records = []
        
        sql = 
            DECLARE @o_Numero INT, @o_MensajeTecnico VARCHAR(500), @o_MensajeUsuario VARCHAR(500);
            EXEC SQM_CATALOGS.USP_Priorities
                @i_priorityId = ?,
                @i_priorityName = ?,
                @i_priorityCreatorId = ?,
                @i_priorityModificatorId = ?,
                @i_priorityEnable = ?,
                @i_PageNumber = ?,
                @i_RowsPerPage = ?,
                @w_Accion = ?,
                @o_Numero = @o_Numero OUTPUT,
                @o_MensajeTecnico = @o_MensajeTecnico OUTPUT,
                @o_MensajeUsuario = @o_MensajeUsuario OUTPUT;
            SELECT @o_Numero AS o_Numero, @o_MensajeUsuario AS o_MensajeUsuario, @o_MensajeTecnico AS o_MensajeTecnico;
        
        
        cursor.execute(sql, (
            priority_id, priority_name, creator_id,
            modificator_id, enable, page_number, rows_per_page, accion
        ))

        if cursor.description:
            columns = [column[0] for column in cursor.description]
            for row in cursor.fetchall():
                records.append(dict(zip(columns, row)))

        cursor.nextset()
        out_row = cursor.fetchone()
        
        o_numero = out_row[0] if out_row else 500
        o_mensaje_usuario = out_row[1] if out_row else "Error desconocido"
        o_mensaje_tecnico = out_row[2] if out_row else ""

        cursor.close()
        conn.close()
        return o_numero, o_mensaje_usuario, o_mensaje_tecnico, records
