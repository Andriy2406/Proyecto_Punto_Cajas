from conexion import conectar 
conexion = conectar ()
cursor = conexion.cursor()

cursor = conexion.cursor()
cursor.execute("""
    CREATE TABLE IF NOT EXISTS cotizacion_cabecera (
        id SERIAL PRIMARY KEY,
        fecha DATE NOT NULL,
        valor_unitario FLOAT NOT NULL,
        iva FLOAT NOT NULL,
        subtotal FLOAT NOT NULL,
        total FLOAT NOT NULL
    )
""")
conexion.commit()
print("La tabla cotizacion_cabecera fue creada")
cursor.close()
conexion.close()