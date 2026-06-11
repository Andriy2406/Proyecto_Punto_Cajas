from validacion import validar_texto, validar_int, validar_float
from datetime import datetime 

def crear_pedido_c(conexion):
    id_cotizacion_cabecera = input("Ingrese el ID de la cotizacion a buscar: ")
    fecha = input("Ingrese la fecha del pedido cabecera: ")
    direccion = input("Ingrese la dirección del envio: ")
    total = input("Ingrese el total del pedido cabecera: ")
    estado = input("Ingrese el estado del pedido cabecera: ")

    if not validar_int(id_cotizacion_cabecera) or not validar_texto(direccion) or not validar_float(total) or not validar_texto(estado):
        print("Datos no validos")
        return
    
    try:
        # Esto verifica que el texto cumpla con el formato Año-Mes-Día
        fecha_validada = datetime.strptime(fecha, "%Y-%m-%d").date()
    except ValueError:
        print("Formato de fecha incorrecto. Debe ser AAAA-MM-DD")
        return

    cursor = conexion.cursor()
    cursor.execute("SELECT * FROM cotizacion_cabecera WHERE id = %s", (id_cotizacion_cabecera,))

    cotizacion = cursor.fetchone()

    if not cotizacion:
        print("La cotización no exite.")
        return

    cursor.execute("SELECT * FROM pedido_cabecera WHERE id_cotizacion_cabecera = %s", (id_cotizacion_cabecera,))

    pedido = cursor.fetchone()

    if pedido:
        print("El pedido esta asociado con otra cotización.")
        return
    
    cursor.execute(
        """
        INSERT INTO pedido_cabecera
        (fecha, direccion_envio, total, estado_pedido, id_cotizacion_cabecera) 
        VALUES (%s, %s, %s, %s, %s)
        """,
        (fecha_validada, direccion, total, estado, id_cotizacion_cabecera)
    )

    conexion.commit()

    print("Pedido asociado correctamente.")

def ver_cotizacion_p(conexion):
    cursor = conexion.cursor()

    cursor.execute(
        """
        SELECT p.id, c.fecha, p.direccion_envio, p.estado_pedido, c.valor_unitario, c.iva, c.subtotal, c.total
        FROM pedido_cabecera p
        INNER JOIN cotizacion_cabecera c
        ON p.id_cotizacion_cabecera = c.id
        """
    )

    pedido = cursor.fetchall()

    print("========== LISTA DE PEDIDOS CABECERA =========".center(50))

    for p in pedido:
        print(f"ID: {p[0]} | Fecha: {p[1]} | Dirección envio: {p[2]} | Estado pedido: {p[3]} | Valor unitario: {p[4]} | IVA: {p[5]} | Subtotal: {p[6]} | Total: {p[7]}")

def eliminar_pedido_c(conexion):
    id_pedido_c = input("ID del pedido cabecera a eliminar: ")
    cursor = conexion.cursor()
    cursor.execute("DELETE FROM pedido_cabecera WHERE id = %s", (id_pedido_c,))
    conexion.commit()
    print("Pedido cabecera eliminado")

def actualizar_pedido_c(conexion):
    id_pedido = input("Ingrese el ID del pedido cabecera a actualizar: ")
    id_cotizacion_cabecera = input("Ingrese el ID de la cotizacion a actualizar: ")
    fecha = input("Ingrese la fecha del pedido a actualizar: ")
    direccion = input("Ingrese la dirección del envio a actualizar: ")
    total = input("Ingrese el total del pedido cabecera: ")
    estado = input("Ingrese el estado del pedido cabecera: ")

    if not validar_int(id_pedido) or not validar_int(id_cotizacion_cabecera) or not validar_texto(direccion) or not validar_float(total) or not validar_texto(estado):
        print("Datos no validos")
        return
    
    try:
        # Esto verifica que el texto cumpla con el formato Año-Mes-Día
        fecha_validada = datetime.strptime(fecha, "%Y-%m-%d").date()
    except ValueError:
        print("Formato de fecha incorrecto. Debe ser AAAA-MM-DD")
        return
    
    cursor = conexion.cursor()

    cursor.execute(
        """
        SELECT * FROM pedido_cabecera WHERE id = %s
        """, (id_pedido,)
    )
    pedido_cabecera = cursor.fetchone()

    if not pedido_cabecera:
        print("No existe nigun pedido cabecera con ese ID")
        cursor.close()
        return

    cursor.execute(
        """
        UPDATE pedido_cabecera
        SET fecha = %s, direccion_envio = %s, total = %s, estado_pedido = %s, id_cotizacion_cabecera = %s
        WHERE id = %s
        """,
        (fecha_validada, direccion, total, estado, id_cotizacion_cabecera, id_pedido)
    )

    conexion.commit()
    print("Pedido cabecera actualizada con exito")