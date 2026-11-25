import logging

from infrastructure.database.connection import get_connection
from domain.shared.operationResult import OperationResult
from domain.shared.queryResult import QueryResult

logger = logging.getLogger(__name__)

class BaseRepository:
    #Metodo para ejecutar POST (INSERT) o PUT (UPDATE)
    @staticmethod
    def execute_operation(query: str, params: tuple = ()) -> OperationResult:
        try:
            with get_connection() as conn:
                cursor = conn.cursor()
                cursor.execute(query, params)
                result = cursor.fetchone()
                conn.commit()

                if result is None:
                    return OperationResult(
                        status_code=500,
                        message_user="No se recibió respuesta del procedimiento almacenado.",
                        message_tech="fetchone() retornó None."
                    )

                return OperationResult(
                    status_code=result[0],
                    message_user=result[1],
                    message_tech=result[2]
                )

        except Exception:
            logger.exception("Database operation failed")
            return OperationResult(
                status_code=500,
                message_user="No fue posible completar la operación.",
                message_tech=None
            )
        
    #Metodo para ejecutar GET (SELECT)
    @staticmethod
    def execute_query(
        query: str,
        params: tuple = ()
    ) -> QueryResult:

        try:
            with get_connection() as conn:
                cursor = conn.cursor()
                cursor.execute(query, params)

                # Saltar resultados intermedios sin columnas (ej. mensajes o conteos de filas afectadas en el SP)
                while cursor.description is None:
                    if not cursor.nextset():
                        return QueryResult(
                            status_code=500,
                            message_user="El procedimiento no retornó datos.",
                            message_tech="cursor.description fue None en todos los resultsets.",
                            data=[]
                        )

                columns = [col[0] for col in cursor.description]
                data = [
                    dict(zip(columns, row))
                    for row in cursor.fetchall()
                ]

                # Buscar el siguiente resultset con el estado (status_code, message_user, message_tech)
                while cursor.nextset():
                    if cursor.description is not None:
                        operation = cursor.fetchone()
                        if operation:
                            return QueryResult(
                                status_code=operation[0],
                                message_user=operation[1],
                                message_tech=operation[2],
                                data=data
                            )

                # Si el SP devolvió un solo SELECT que ya trae status_code y message_user en la fila:
                if data and "status_code" in data[0]:
                    return QueryResult(
                        status_code=data[0]["status_code"],
                        message_user=data[0].get("message_user", "Operación exitosa"),
                        message_tech=data[0].get("message_tech"),
                        data=data
                    )

                return QueryResult(
                    status_code=200 if data else 401,
                    message_user="Consulta exitosa." if data else "Credenciales incorrectas o sin datos.",
                    message_tech="El procedimiento retornó un único resultset.",
                    data=data
                )

        except Exception:
            logger.exception("Database query failed")
            return QueryResult(
                status_code=500,
                message_user="No fue posible consultar la información.",
                message_tech=None,
                data=[]
            )
    