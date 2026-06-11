from conexion import conectar 
conexion = conectar ()
cursor = conexion.cursor()

cursor = conexion.cursor()
cursor.execute("""
    CREATE TABLE IF NOT EXISTS pedido_detalle (
        id SERIAL PRIMARY KEY,
        cantida FLOAT NOT NULL,
        subtotal FLOAT NOT NULL,
        id_pedido_cabecera INT,
        id_cotizacion INT,
        FOREIGN KEY (id_pedido_cabecera) REFERENCES pedido_cabecera(id),
        FOREIGN KEY (id_cotizacion) REFERENCES cotizacion_cabecera(id)
    )
""")
conexion.commit()
print("La tabla pedido_detalle fue creada")
cursor.close()
conexion.close()