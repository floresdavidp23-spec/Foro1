from typing import Any, Dict, List, Tuple
from infrastructure.database.connection import get_connection


def execute_sp(query: str, params: Tuple = (), fetch: bool = False) -> List[Dict[str, Any]]:
    with get_connection() as conn:
        cursor = conn.cursor()
        cursor.execute(query, params)
        if fetch:
            if not cursor.description:
                conn.commit()
                return []
            columns = [col[0] for col in cursor.description]
            rows = [dict(zip(columns, row)) for row in cursor.fetchall()]
            conn.commit()
            return rows
        conn.commit()
        return []


def respuesta_lista(data: List[Dict[str, Any]], message: str) -> Dict[str, Any]:
    return {
        "status_code": 200,
        "message": message,
        "data": data,
    }