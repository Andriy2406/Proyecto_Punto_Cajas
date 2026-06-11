from validacion import validar_float, validar_int
# cuando es fecha se importa el datetime para una mejor solucion
from datetime import datetime

def crear_cotizacion(conexion):
    fecha = input("Ingrese la fecha de la cotizacion(AAAA-MM-DD): ")
    valor_unitario = input("Ingrese el valor unitario del producto: ")
    iva = input("Ingrese el IVA del producto: ")
    subtotal = input("Ingrese el subtotal sin IVA: ")
    total = input("Ingrese el total de la cotizacion: ")

    if not validar_float(valor_unitario) or not validar_float(iva) or not validar_float(subtotal) or not validar_float(total):
        print("Datos no validos")
        return

    # Validación del formato de la fecha
    try:
        # Esto verifica que el texto cumpla con el formato Año-Mes-Día
        fecha_validada = datetime.strptime(fecha, "%Y-%m-%d").date()
    except ValueError:
        print("Formato de fecha incorrecto. Debe ser AAAA-MM-DD")
        return
    
    cursor = conexion.cursor()

    cursor.execute(
        "INSERT INTO cotizacion_cabecera (fecha, valor_unitario, iva, subtotal, total) VALUES (%s, %s, %s, %s, %s )", (fecha_validada, valor_unitario, iva, subtotal, total)
    )
    conexion.commit()
    print("Cotizacion creada")

def ver_cotizacion(conexion):
    cursor = conexion.cursor()
    cursor.execute("SELECT * FROM cotizacion_cabecera")
    cotizacion_cabecera = cursor.fetchall()
    print("==========LISTA DE COTIZACIONES==========".center(50))
    for cotizaciones in  cotizacion_cabecera:
        print(f"ID: {cotizaciones[0]} | Fecha: {cotizaciones[1]} | Valor Unitario: {cotizaciones[2]} | IVA: {cotizaciones[3]} | Subtotal: {cotizaciones[4]} | Total: {cotizaciones[5]}")

def eliminar_cotizacion(conexion):
    id_cotizacion = input("ID de la cotizacion a eliminar: ")
    cursor = conexion.cursor()
    cursor.execute("DELETE FROM cotizacion_cabecera WHERE id = %s", (id_cotizacion,))
    conexion.commit()
    print("Cotizacion eliminada")

def actualizar_cotizacion(conexion):
    id_cotizacion = input("ID de la cotizacion a actualizar: ")
    fecha = input("Ingrese la nueva fecha de la cotizacion(AAAA-MM-DD): ")
    valor_unitario = input("Ingrese el nuevo valor unitario del producto: ")
    iva = input("Ingrese el IVA del producto: ")
    subtotal = input("Ingrese el subtotal sin IVA: ")
    total = input("Ingrese el total de la cotizacion: ")

    if not validar_int(id_cotizacion) or not validar_float(valor_unitario) or not validar_float(iva) or not validar_float(subtotal) or not validar_float(total):
        print("Datos no validos")
        return

    # Validación del formato de la fecha
    try:
        # Esto verifica que el texto cumpla con el formato Año-Mes-Día
        fecha_validada = datetime.strptime(fecha, "%Y-%m-%d").date()
    except ValueError:
        print("Formato de fecha incorrecto. Debe ser AAAA-MM-DD")
        return
    
    cursor = conexion.cursor()

    cursor.execute(
        "SELECT * FROM cotizacion_cabecera WHERE id = %s", (id_cotizacion,)
    )
    cotizacion_cabecera = cursor.fetchone()

    if not cotizacion_cabecera:
        print("No existe ninguna cotizacion con ese ID")
        return
    
    cursor.execute(
        """
        UPDATE cotizacion_cabecera
        SET fecha = %s, valor_unitario = %s, iva = %s, subtotal = %s, total = %s
        WHERE id = %s
        """,
        (fecha_validada, valor_unitario, iva, subtotal, total, id_cotizacion)
    )

    conexion.commit()
    print("Cotizacion actualizada con exito")