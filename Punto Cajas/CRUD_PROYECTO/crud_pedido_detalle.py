from validacion import validar_int, validar_float

def crear_pedido_d(conexion):
    id_pedido_cabecera = input("Ingrese el ID del pedido cabecera: ")
    id_cotizacion = input("Ingrese el ID de la cotización: ")
    cantida = input("Ingrese la cantidad: ")
    subtotal = input("Ingrese el subtotal: ")

    # Validamos los tipos de datos según tus funciones
    if not validar_int(id_pedido_cabecera) or not validar_int(id_cotizacion) or not validar_float(cantida) or not validar_float(subtotal):
        print("Datos no válidos")
        return

    cursor = conexion.cursor()

    cursor.execute("SELECT * FROM pedido_cabecera WHERE id = %s", (id_pedido_cabecera,))
    if not cursor.fetchone():
        print("El pedido cabecera no existe.")
        cursor.close()
        return

    cursor.execute("SELECT * FROM cotizacion_cabecera WHERE id = %s", (id_cotizacion,))
    if not cursor.fetchone():
        print("La cotización no existe.")
        cursor.close()
        return

    cursor.execute(
        """
        INSERT INTO pedido_detalle (cantida, subtotal, id_pedido_cabecera, id_cotizacion)
        VALUES (%s, %s, %s, %s)
        """,
        (cantida, subtotal, id_pedido_cabecera, id_cotizacion)
    )
    
    conexion.commit()
    cursor.close()
    print("Detalle de pedido registrado correctamente.")


def ver_pedidos_d(conexion):
    cursor = conexion.cursor()
    
    cursor.execute(
        """
        SELECT d.id, pc.direccion_envio, cc.total, d.cantida, d.subtotal 
        FROM pedido_detalle d
        INNER JOIN pedido_cabecera pc ON d.id_pedido_cabecera = pc.id
        INNER JOIN cotizacion_cabecera cc ON d.id_cotizacion = cc.id
        """
    )
    detalles = cursor.fetchall()

    print("========== LISTA DE DETALLES DE PEDIDOS =========".center(60))
    for d in detalles:
        print(f"ID Detalle: {d[0]} | Envío a: {d[1]} | Total Cotiz: ${d[2]} | Cantidad: {d[3]} | Subtotal: ${d[4]}")
        
    cursor.close()


def eliminar_pedido_d(conexion):
    id_detalle = input("Ingrese el ID del detalle de pedido a eliminar: ")
    
    if not validar_int(id_detalle):
        print("ID no válido.")
        return

    cursor = conexion.cursor()
    
    cursor.execute("SELECT * FROM pedido_detalle WHERE id = %s", (id_detalle,))
    if not cursor.fetchone():
        print("No existe ningún detalle de pedido con ese ID.")
        cursor.close()
        return

    cursor.execute("DELETE FROM pedido_detalle WHERE id = %s", (id_detalle,))
    conexion.commit()
    cursor.close()
    print("Detalle de pedido eliminado con éxito.")


def actualizar_pedido_d(conexion):
    id_detalle = input("Ingrese el ID del detalle de pedido a actualizar: ")
    id_pedido_cabecera = input("Ingrese el nuevo ID del pedido cabecera: ")
    id_cotizacion = input("Ingrese el nuevo ID de la cotización: ")
    cantida = input("Ingrese la nueva cantidad: ")
    subtotal = input("Ingrese el nuevo subtotal: ")

    if not validar_int(id_detalle) or not validar_int(id_pedido_cabecera) or not validar_int(id_cotizacion) or not validar_float(cantida) or not validar_float(subtotal):
        print("Datos no válidos")
        return

    cursor = conexion.cursor()

    cursor.execute("SELECT * FROM pedido_detalle WHERE id = %s", (id_detalle,))
    if not cursor.fetchone():
        print("No existe ningún detalle de pedido con ese ID.")
        cursor.close()
        return

    cursor.execute("SELECT * FROM pedido_cabecera WHERE id = %s", (id_pedido_cabecera,))
    if not cursor.fetchone():
        print("El nuevo pedido cabecera no existe.")
        cursor.close()
        return

    cursor.execute("SELECT * FROM cotizacion_cabecera WHERE id = %s", (id_cotizacion,))
    if not cursor.fetchone():
        print("La nueva cotización no existe.")
        cursor.close()
        return

    cursor.execute(
        """
        UPDATE pedido_detalle
        SET cantida = %s, subtotal = %s, id_pedido_cabecera = %s, id_cotizacion = %s
        WHERE id = %s
        """,
        (cantida, subtotal, id_pedido_cabecera, id_cotizacion, id_detalle)
    )
    
    conexion.commit()
    cursor.close()
    print("Detalle de pedido actualizado con éxito.")