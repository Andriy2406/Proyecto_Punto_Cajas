CREATE DATABASE punto_cajas_db;
USE punto_cajas_db;

CREATE TABLE tipos_de_documentos (
  id_documento INT NOT NULL AUTO_INCREMENT,
  descripcion_tipo VARCHAR(45) NOT NULL,
  PRIMARY KEY (id_documento)
);

CREATE TABLE roles (
  id_rol INT NOT NULL AUTO_INCREMENT,
  detalle_rol VARCHAR(45) NOT NULL,
  PRIMARY KEY (id_rol)
);

CREATE TABLE tipos_doc_con (
  id_doc_con INT NOT NULL AUTO_INCREMENT,
  codigo_con INT NOT NULL,
  numero_actual INT NOT NULL,
  PRIMARY KEY (id_doc_con)
);

CREATE TABLE catalogos (
  id_catalogo INT NOT NULL AUTO_INCREMENT,
  stock_actual VARCHAR(45) NOT NULL,
  url VARCHAR(45) NULL,
  PRIMARY KEY (id_catalogo)
);

CREATE TABLE medios_de_pagos (
  id_medio_pago INT NOT NULL AUTO_INCREMENT,
  seleccionar_pago VARCHAR(45) NOT NULL,
  PRIMARY KEY (id_medio_pago)
);

CREATE TABLE permisos (
  id_permiso INT NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(100),
  descripcion VARCHAR(100),
  PRIMARY KEY (id_permiso)
);

CREATE TABLE rol_permisos (
  id_rol INT NOT NULL,
  id_permiso INT NOT NULL,
  CONSTRAINT fk_rol_permisos_roles FOREIGN KEY (id_rol) REFERENCES roles (id_rol),
  CONSTRAINT fk_rol_permisos_permisos FOREIGN KEY (id_permiso) REFERENCES permisos (id_permiso)
);
  
  
  

CREATE TABLE usuarios (
  id_usuario INT NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(45) NOT NULL,
  apellido VARCHAR(45) NOT NULL,
  identificacion_usuario VARCHAR(45) NOT NULL,
  direccion VARCHAR(45) NULL,
  telefono VARCHAR(45) NULL,
  correo VARCHAR(45) NOT NULL,
  clave VARCHAR(45) NOT NULL,
  fecha_de_nacimiento DATE,
  fecha_de_vencimiento DATE,
  autorizacionDatos TINYINT,
  id_documento INT NOT NULL,
  id_rol INT NOT NULL,
  PRIMARY KEY (id_usuario),
  CONSTRAINT fk_usuario_tipo_de_documentos FOREIGN KEY (id_documento) REFERENCES tipos_de_documentos (idDocumento),
  CONSTRAINT fk_usuario_roles FOREIGN KEY (id_rol) REFERENCES roles (id_rol)
);

CREATE TABLE productos (
  id_producto INT NOT NULL AUTO_INCREMENT,
  descripcion VARCHAR(45) NOT NULL,
  precio FLOAT NOT NULL,
  id_catalogo INT NOT NULL,
  PRIMARY KEY (id_producto),
  CONSTRAINT fk_producto_catalogo FOREIGN KEY (id_catalogo) REFERENCES catalogos (id_catalogo)
);

CREATE TABLE cotizaciones_cabeceras (
  id_cotizacion INT NOT NULL AUTO_INCREMENT,
  fecha DATE NOT NULL,
  valorUnitario DECIMAL(10,2) NOT NULL,
  iva DECIMAL(10,2) NOT NULL,
  subtotal DECIMAL(10,2) NOT NULL,
  total DECIMAL(10,2) NOT NULL,
  idUsuario INT NOT NULL,
  idDocCon INT NOT NULL,
  PRIMARY KEY (idCotizacion),
  CONSTRAINT fk_Cotizacion_Usuario FOREIGN KEY (idUsuario) REFERENCES Usuario (idUsuario),
  CONSTRAINT fk_Cotizacion_TiposDocCon FOREIGN KEY (idDocCon) REFERENCES TiposDocCon (idDocCon)
);

CREATE TABLE DetalleCotizacion (
  idDetalle INT NOT NULL AUTO_INCREMENT,
  cantidad INT NOT NULL,
  alto DECIMAL(10,2) NOT NULL,
  largo DECIMAL(10,2) NOT NULL,
  ancho DECIMAL(10,2) NOT NULL,
  color VARCHAR(45) NULL,
  acabado VARCHAR(45) NULL,
  descripcionUsoCaja VARCHAR(45) NULL,
  idCotizacion INT NOT NULL,
  PRIMARY KEY (idDetalle),
  CONSTRAINT fk_DetalleCot_Cabecera FOREIGN KEY (idCotizacion) REFERENCES CotizacionCabecera (idCotizacion)
);

CREATE TABLE PedidoCabecera (
  idPedido INT NOT NULL AUTO_INCREMENT,
  fecha DATE NOT NULL,
  direccionEnvio VARCHAR(45) NOT NULL,
  total FLOAT NOT NULL,
  estadoPedido VARCHAR(45) NOT NULL,
  idCotizacion INT NOT NULL,
  PRIMARY KEY (idPedido),
  CONSTRAINT fk_Pedido_Cotizacion FOREIGN KEY (idCotizacion) REFERENCES CotizacionCabecera (idCotizacion)
);


CREATE TABLE FacturaCabecera (
  idFactura INT NOT NULL AUTO_INCREMENT,
  numeroFactura INT NOT NULL,
  total DECIMAL(10,2) NOT NULL,
  idPedido INT NOT NULL,
  idCotizacion INT NOT NULL, 
  PRIMARY KEY (idFactura),
  CONSTRAINT fk_Factura_Pedido FOREIGN KEY (idPedido) 
    REFERENCES PedidoCabecera (idPedido),
  CONSTRAINT fk_Factura_Cotizacion FOREIGN KEY (idCotizacion) 
    REFERENCES CotizacionCabecera (idCotizacion) 
);


CREATE TABLE PedidoDetalle (
  idPedidoDetalle INT NOT NULL AUTO_INCREMENT,
  cantidad INT NOT NULL,
  subtotal DECIMAL(10,2) NOT NULL,
  idPedido INT NOT NULL,
  idCotizacion INT NOT NULL,
  PRIMARY KEY (idPedidoDetalle),
  CONSTRAINT fk_PedidoDetalle_Pedido FOREIGN KEY (idPedido) 
    REFERENCES PedidoCabecera (idPedido),
  CONSTRAINT fk_PedidoDetalle_Cotizacion FOREIGN KEY (idCotizacion) 
    REFERENCES CotizacionCabecera (idCotizacion)
);
CREATE TABLE DetalleFactura (
  idDetalleFactura INT NOT NULL AUTO_INCREMENT,
  cantidad INT NOT NULL,
  valorUnitario DECIMAL(10,2) NOT NULL,
  subtotal DECIMAL(10,2) NOT NULL,
  idFactura INT NOT NULL,
  idProducto INT NOT NULL,
  PRIMARY KEY (idDetalleFactura),
  CONSTRAINT fk_DetalleFactura_Factura FOREIGN KEY (idFactura) REFERENCES FacturaCabecera (idFactura),
  CONSTRAINT fk_DetalleFactura_Producto FOREIGN KEY (idProducto) REFERENCES Producto (idProducto)
);

CREATE TABLE Pago (
  idPago INT NOT NULL AUTO_INCREMENT,
  monto DECIMAL(10,2) NOT NULL,
  fecha DATE NOT NULL,
  total DECIMAL(10,2) NOT NULL,
  referenciaPago VARCHAR(45) NULL,
  idFactura INT NOT NULL,
  idMedioPago INT NOT NULL,
  PRIMARY KEY (idPago),
  CONSTRAINT fk_Pago_Factura FOREIGN KEY (idFactura) REFERENCES FacturaCabecera (idFactura),
  CONSTRAINT fk_Pago_MedioPago FOREIGN KEY (idMedioPago) REFERENCES MedioPago (idMedioPago)
);


