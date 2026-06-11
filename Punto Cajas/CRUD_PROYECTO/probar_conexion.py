#pip install "psycog[binary]"
import os
from dotenv import load_dotenv
import psycopg

load_dotenv()

try:
    conexion = psycopg.connect(
        host=os.getenv("DB_HOST"),
        dbname=os.getenv("DB_NAME"),
        user=os.getenv("DB_USER"),
        password=os.getenv("DB_PASSWORD"),
        port=os.getenv("DB_PORT")
    )
    print("Conexion exitosa a postgres")
    conexion.close()
except Exception as e:
    print(e)