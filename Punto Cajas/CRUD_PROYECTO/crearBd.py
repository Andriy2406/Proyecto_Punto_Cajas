# primero instalar 
# pip install psycopg[binary]
import psycopg

try:
    conexion = psycopg.connect(
        host="localhost",
        user="postgres",
        password="1234",
        port=5432
    )

#Codigo para crear base de datos
    conexion.autocommit = True
    cursor = conexion.cursor()
    #Crear la BD
    cursor.execute("CREATE DATABASE punto_cajas") #query para crear  la BD libreria
    print("Base de datos creada")
    conexion.close()
except Exception as e:
    print(e)