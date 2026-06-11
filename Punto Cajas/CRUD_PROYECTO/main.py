from conexion import conectar 
from menu import mostrar_menu_principal, mostrar_submenu
from crud_cotizacion_cabecera import (
    crear_cotizacion, ver_cotizacion, actualizar_cotizacion, eliminar_cotizacion
)
from crud_pedido_cabecera import(
    crear_pedido_c, ver_cotizacion_p, actualizar_pedido_c, eliminar_pedido_c
)
from crud_pedido_detalle import(
    crear_pedido_d, ver_pedidos_d, eliminar_pedido_d, actualizar_pedido_d
)

def main(): 
    conexion = conectar()
    if conexion is None:
        return
        
    while True:
        mostrar_menu_principal()
        opcion_principal = input("Seleccione una opción: ")
        
        # ==========================================
        # SUBMENÚ: COTIZACIONES
        # ==========================================
        if opcion_principal == "1":
            while True:
                mostrar_submenu("Cotizaciones")
                opcion_sub = input("Seleccione una acción: ")
                if opcion_sub == "1":
                    crear_cotizacion(conexion)
                elif opcion_sub == "2":
                    ver_cotizacion(conexion)
                elif opcion_sub == "3":
                    actualizar_cotizacion(conexion)
                elif opcion_sub == "4":
                    eliminar_cotizacion(conexion)
                elif opcion_sub == "5":
                    break 
                else:
                    print("Opción inválida")

        # ==========================================
        # SUBMENÚ: PEDIDO CABECERA
        # ==========================================
        elif opcion_principal == "2":
            while True:
                mostrar_submenu("Pedido Cabecera")
                opcion_sub = input("Seleccione una acción: ")
                if opcion_sub == "1":
                    crear_pedido_c(conexion)
                elif opcion_sub == "2":
                    ver_cotizacion_p(conexion)
                elif opcion_sub == "3":
                    actualizar_pedido_c(conexion)
                elif opcion_sub == "4":
                    eliminar_pedido_c(conexion)
                elif opcion_sub == "5":
                    break
                else:
                    print("Opción inválida")

        # ==========================================
        # SUBMENÚ: PEDIDO DETALLE
        # ==========================================
        elif opcion_principal == "3":
            while True:
                mostrar_submenu("Pedido Detalle")
                opcion_sub = input("Seleccione una acción: ")
                if opcion_sub == "1":
                    crear_pedido_d(conexion)
                elif opcion_sub == "2":
                    ver_pedidos_d(conexion)
                elif opcion_sub == "3":
                    actualizar_pedido_d(conexion)
                elif opcion_sub == "4":
                    eliminar_pedido_d
                elif opcion_sub == "5":
                    break
                else:
                    print("Opción inválida")

        # ==========================================
        # SALIR DEL SISTEMA
        # ==========================================
        elif opcion_principal == "4":
            print("Saliendo del sistema... ¡Hasta luego!")
            break
            
        else:
            print("Opción inválida en el menú principal")

if __name__ == "__main__":
    main()