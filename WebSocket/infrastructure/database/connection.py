import pyodbc

def get_connection():
    return pyodbc.connect(
        "DRIVER={ODBC Driver 17 for SQL Server};"
        "SERVER=localhost;"
        "DATABASE=DB_SCRUM_PLANNING;"
        "Trusted_Connection=yes;"
    )

get_db_connection = get_connection