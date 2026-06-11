from conexion import conectar 
conexion = conectar ()
cursor = conexion.cursor()

cursor = conexion.cursor()
cursor.execute("""
    CREATE TABLE IF NOT EXISTS pedido_cabecera(
        id SERIAL PRIMARY KEY,
        fecha DATE NOT NULL,
        direccion_envio VARCHAR(100) NOT NULL,
        total FLOAT NOT NULL,
        estado_pedido VARCHAR(20) NOT NULL,
        id_cotizacion_cabecera INT,
        FOREIGN KEY (id_cotizacion_cabecera) REFERENCES cotizacion_cabecera(id)
    )
""")
conexion.commit()
print("La tabla pedido_cabecera fue creada")
cursor.close()
conexion.close()