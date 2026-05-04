function mostrarFormulario(){
    // 1. Obtener el valor seleccionado 
    const seleccion = document.getElementById("metodo-pago").value;

    // 2. Ocultar todos los formularios primero
    const formularios = document.querySelectorAll(".metodo-detalle");

    formularios.forEach(function(form){
        form.style.display = 'none';
    });

    // 3. MOstrar solo el formulatio correspondiente
    if (seleccion !== ""){
        const formularioMostrar = document.getElementById("form-" + seleccion);

        if (formularioMostrar){
            formularioMostrar.style.display = "block";
        }
    }
}