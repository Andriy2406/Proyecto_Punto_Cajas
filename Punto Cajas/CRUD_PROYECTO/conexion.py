#se importan los componentes .env
import os
from dotenv import load_dotenv
import psycopg

load_dotenv()

def conectar():
    try:
        conexion = psycopg.connect(
        host=os.getenv("DB_HOST"),
        dbname=os.getenv("DB_NAME"),
        user=os.getenv("DB_USER"),
        password=os.getenv("DB_PASSWORD"),
        port=os.getenv("DB_PORT")
    )
    
        return conexion
    except Exception as e:
          print("Error de conexion", e)
          return None