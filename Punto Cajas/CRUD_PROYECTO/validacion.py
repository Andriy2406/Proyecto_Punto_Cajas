def validar_texto(texto):
    return texto.strip() != ""

def validar_int(numero):
    try:
        int(numero) 
        return True
    except ValueError:
        return False

def validar_float(numero):
    try:
        float(numero)
        return True
    except ValueError:
        return False