CREATE DATABASE punto_cajas_db;
USE punto_cajas_db;

CREATE TABLE TipoDocumento (
  idDocumento INT NOT NULL AUTO_INCREMENT,
  descripcionTipo VARCHAR(45) NOT NULL,
  PRIMARY KEY (idDocumento)
);

CREATE TABLE Rol (
  idRol INT NOT NULL AUTO_INCREMENT,
  detalleRol VARCHAR(45) NOT NULL,
  PRIMARY KEY (idRol)
);

CREATE TABLE TiposDocCon (
  idDocCon INT NOT NULL AUTO_INCREMENT,
  codigoCon INT NOT NULL,
  numeroActual INT NOT NULL,
  PRIMARY KEY (idDocCon)
);

CREATE TABLE Catalogo (
  idCatalogo INT NOT NULL AUTO_INCREMENT,
  stockActual VARCHAR(45) NOT NULL,
  url VARCHAR(45) NULL,
  PRIMARY KEY (idCatalogo)
);

CREATE TABLE MedioPago (
  idMedioPago INT NOT NULL AUTO_INCREMENT,
  seleccionarPago VARCHAR(45) NOT NULL,
  PRIMARY KEY (idMedioPago)
);

CREATE TABLE Permiso (
  idPermiso INT NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(100),
  descripcion VARCHAR(100),
  PRIMARY KEY (idPermiso)
);

CREATE TABLE RolPermisos (
  idRol INT NOT NULL,
  idPermiso INT NOT NULL,
  CONSTRAINT fk_RolPermisos_Rol FOREIGN KEY (idRol) REFERENCES Rol (idRol),
  CONSTRAINT fk_RolPermisos_Permiso FOREIGN KEY (idPermiso) REFERENCES Permiso (idPermiso)
);
  
  
  

CREATE TABLE Usuario (
  idUsuario INT NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(45) NOT NULL,
  apellido VARCHAR(45) NOT NULL,
  identificacionUsuario VARCHAR(45) NOT NULL,
  direccion VARCHAR(45) NULL,
  telefono VARCHAR(45) NULL,
  correo VARCHAR(45) NOT NULL,
  clave VARCHAR(45) NOT NULL,
  fechaDeNacimiento DATE,
  fechaDeVencimiento DATE,
  autorizacionDatos TINYINT,
  idDocumento INT NOT NULL,
  idRol INT NOT NULL,
  PRIMARY KEY (idUsuario),
  CONSTRAINT fk_Usuario_TipoDocumento FOREIGN KEY (idDocumento) REFERENCES TipoDocumento (idDocumento),
  CONSTRAINT fk_Usuario_Rol FOREIGN KEY (idRol) REFERENCES Rol (idRol)
);

CREATE TABLE Producto (
  idProducto INT NOT NULL AUTO_INCREMENT,
  descripcion VARCHAR(45) NOT NULL,
  precio FLOAT NOT NULL,
  idCatalogo INT NOT NULL,
  PRIMARY KEY (idProducto),
  CONSTRAINT fk_Producto_Catalogo FOREIGN KEY (idCatalogo) REFERENCES Catalogo (idCatalogo)
);

CREATE TABLE CotizacionCabecera (
  idCotizacion INT NOT NULL AUTO_INCREMENT,
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


