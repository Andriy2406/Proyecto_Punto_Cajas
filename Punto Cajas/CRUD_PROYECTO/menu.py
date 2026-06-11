def mostrar_menu_principal():
    print("\n========== SGP - MENÚ PRINCIPAL ==========")
    print("1. Gestionar Cotizaciones")
    print("2. Gestionar Pedidos (Cabecera)")
    print("3. Gestionar Pedidos (Detalle)")
    print("4. Salir")

def mostrar_submenu(modulo_nombre):
    print(f"\n--- GESTIÓN DE {modulo_nombre.upper()} ---")
    print("1. Crear")
    print("2. Ver lista")
    print("3. Actualizar")
    print("4. Eliminar")
    print("5. Volver al menú principal")