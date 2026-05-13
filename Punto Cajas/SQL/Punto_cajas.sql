CREATE DATABASE punto_cajas_db;
USE punto_cajas_db;

CREATE TABLE TipoDocumento (
  id_documento INT NOT NULL AUTO_INCREMENT,
  descripcion_tipo VARCHAR(45) NOT NULL,
  PRIMARY KEY (id_documento)
);

CREATE TABLE Rol (
  id_rol INT NOT NULL AUTO_INCREMENT,
  detalle_rol VARCHAR(45) NOT NULL,
  PRIMARY KEY (id_rol)
);

CREATE TABLE TiposDocCon (
  id_doc_con INT NOT NULL AUTO_INCREMENT,
  codigo_con INT NOT NULL,
  numero_actual INT NOT NULL,
  PRIMARY KEY (id_doc_con)
);

CREATE TABLE Catalogo (
  id_catalogo INT NOT NULL AUTO_INCREMENT,
  stock_actual VARCHAR(45) NOT NULL,
  url VARCHAR(45) NULL,
  PRIMARY KEY (id_catalogo)
);

CREATE TABLE MedioPago (
  id_medio_pago INT NOT NULL AUTO_INCREMENT,
  seleccionar_pago VARCHAR(45) NOT NULL,
  PRIMARY KEY (id_medio_pago)
);

CREATE TABLE Usuario (
  id_usuario INT NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(45) NOT NULL,
  apellido VARCHAR(45) NOT NULL,
  identificacion_usuario VARCHAR(45) NOT NULL,
  direccion VARCHAR(45) NULL,
  telefono VARCHAR(45) NULL,
  correo VARCHAR(45) NOT NULL,
  clave VARCHAR(45) NOT NULL,
  TipoDocumento_id_documento INT NOT NULL,
  Rol_id_rol INT NOT NULL,
  PRIMARY KEY (id_usuario),
  CONSTRAINT fk_Usuario_TipoDocumento FOREIGN KEY (TipoDocumento_id_documento) REFERENCES TipoDocumento (id_documento),
  CONSTRAINT fk_Usuario_Rol FOREIGN KEY (Rol_id_rol) REFERENCES Rol (id_rol)
);

CREATE TABLE Producto (
  id_producto INT NOT NULL AUTO_INCREMENT,
  descripcion VARCHAR(45) NOT NULL,
  precio FLOAT NOT NULL,
  Catalogo_id_catalogo INT NOT NULL,
  PRIMARY KEY (id_producto),
  CONSTRAINT fk_Producto_Catalogo FOREIGN KEY (Catalogo_id_catalogo) REFERENCES Catalogo (id_catalogo)
);

CREATE TABLE CotizacionCabecera (
  id_cotizacion INT NOT NULL AUTO_INCREMENT,
  fecha DATE NOT NULL,
  valor_unitario DECIMAL(10,2) NOT NULL,
  iva DECIMAL(10,2) NOT NULL,
  subtotal DECIMAL(10,2) NOT NULL,
  total DECIMAL(10,2) NOT NULL,
  Usuario_id_usuario INT NOT NULL,
  TiposDocCon_id_doc_con INT NOT NULL,
  PRIMARY KEY (id_cotizacion),
  CONSTRAINT fk_Cotizacion_Usuario FOREIGN KEY (Usuario_id_usuario) REFERENCES Usuario (id_usuario),
  CONSTRAINT fk_Cotizacion_TiposDocCon FOREIGN KEY (TiposDocCon_id_doc_con) REFERENCES TiposDocCon (id_doc_con)
);

CREATE TABLE DetalleCotizacion (
  id_detalle INT NOT NULL AUTO_INCREMENT,
  cantidad INT NOT NULL,
  alto DECIMAL(10,2) NOT NULL,
  largo DECIMAL(10,2) NOT NULL,
  ancho DECIMAL(10,2) NOT NULL,
  color VARCHAR(45) NULL,
  acabado VARCHAR(45) NULL,
  descripcion_uso_caja VARCHAR(45) NULL,
  CotizacionCabecera_id_cotizacion INT NOT NULL,
  PRIMARY KEY (id_detalle),
  CONSTRAINT fk_DetalleCot_Cabecera FOREIGN KEY (CotizacionCabecera_id_cotizacion) REFERENCES CotizacionCabecera (id_cotizacion)
);

CREATE TABLE PedidoCabecera (
  id_pedido INT NOT NULL AUTO_INCREMENT,
  fecha DATE NOT NULL,
  direccion_envio VARCHAR(45) NOT NULL,
  total FLOAT NOT NULL,
  estado_pedido VARCHAR(45) NOT NULL,
  CotizacionCabecera_id_cotizacion INT NOT NULL,
  PRIMARY KEY (id_pedido),
  CONSTRAINT fk_Pedido_Cotizacion FOREIGN KEY (CotizacionCabecera_id_cotizacion) REFERENCES CotizacionCabecera (id_cotizacion)
);


CREATE TABLE FacturaCabecera (
  id_factura INT NOT NULL AUTO_INCREMENT,
  numero_factura INT NOT NULL,
  total DECIMAL(10,2) NOT NULL,
  PedidoCabecera_id_pedido INT NOT NULL,
  PedidoCabecera_CotizacionCabecera_id_cotizacion INT NOT NULL, 
  PRIMARY KEY (id_factura),
  CONSTRAINT fk_Factura_Pedido FOREIGN KEY (PedidoCabecera_id_pedido) 
    REFERENCES PedidoCabecera (id_pedido),
  CONSTRAINT fk_Factura_Cotizacion FOREIGN KEY (PedidoCabecera_CotizacionCabecera_id_cotizacion) 
    REFERENCES CotizacionCabecera (id_cotizacion) 
);


CREATE TABLE PedidoDetalle (
  id_pedido_detalle INT NOT NULL AUTO_INCREMENT,
  cantidad INT NOT NULL,
  subtotal DECIMAL(10,2) NOT NULL,
  PedidoCabecera_id_pedido INT NOT NULL,
  PedidoCabecera_CotizacionCabecera_id_cotizacion INT NOT NULL,
  PRIMARY KEY (id_pedido_detalle),
  CONSTRAINT fk_PedidoDetalle_Pedido FOREIGN KEY (PedidoCabecera_id_pedido) 
    REFERENCES PedidoCabecera (id_pedido),
  CONSTRAINT fk_PedidoDetalle_Cotizacion FOREIGN KEY (PedidoCabecera_CotizacionCabecera_id_cotizacion) 
    REFERENCES CotizacionCabecera (id_cotizacion)
);
CREATE TABLE DetalleFactura (
  id_detalle_factura INT NOT NULL AUTO_INCREMENT,
  cantidad INT NOT NULL,
  valor_unitario DECIMAL(10,2) NOT NULL,
  subtotal DECIMAL(10,2) NOT NULL,
  FacturaCabecera_id_factura INT NOT NULL,
  Producto_id_producto INT NOT NULL,
  PRIMARY KEY (id_detalle_factura),
  CONSTRAINT fk_DetalleFactura_Factura FOREIGN KEY (FacturaCabecera_id_factura) REFERENCES FacturaCabecera (id_factura),
  CONSTRAINT fk_DetalleFactura_Producto FOREIGN KEY (Producto_id_producto) REFERENCES Producto (id_producto)
);

CREATE TABLE Pago (
  id_pago INT NOT NULL AUTO_INCREMENT,
  monto DECIMAL(10,2) NOT NULL,
  fecha DATE NOT NULL,
  total DECIMAL(10,2) NOT NULL,
  referencia_pago VARCHAR(45) NULL,
  FacturaCabecera_id_factura INT NOT NULL,
  MedioPago_id_medio_pago INT NOT NULL,
  PRIMARY KEY (id_pago),
  CONSTRAINT fk_Pago_Factura FOREIGN KEY (FacturaCabecera_id_factura) REFERENCES FacturaCabecera (id_factura),
  CONSTRAINT fk_Pago_MedioPago FOREIGN KEY (MedioPago_id_medio_pago) REFERENCES MedioPago (id_medio_pago)
);
