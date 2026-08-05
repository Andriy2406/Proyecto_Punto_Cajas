-- Creación de Tablas
CREATE TABLE TipoDocumento (
  id_documento SERIAL PRIMARY KEY,
  descripcion_tipo VARCHAR(45) NOT NULL
);

CREATE TABLE Rol (
  id_rol SERIAL PRIMARY KEY,
  detalle_rol VARCHAR(45) NOT NULL
);

CREATE TABLE TiposDocCon (
  id_doc_con SERIAL PRIMARY KEY,
  codigo_con INT NOT NULL,
  numero_actual INT NOT NULL
);

CREATE TABLE Catalogo (
  id_catalogo SERIAL PRIMARY KEY,
  url VARCHAR(45) NULL
);

CREATE TABLE MedioPago (
  id_medio_pago SERIAL PRIMARY KEY,
  seleccionar_pago VARCHAR(45) NOT NULL
);

CREATE TABLE Usuario (
  id_usuario SERIAL PRIMARY KEY,
  nombre VARCHAR(45) NOT NULL,
  apellido VARCHAR(45) NOT NULL,
  identificacion_usuario VARCHAR(45) NOT NULL,
  direccion VARCHAR(45) NULL,
  telefono VARCHAR(45) NULL,
  correo VARCHAR(45) NOT NULL,
  clave VARCHAR(45) NOT NULL,
  TipoDocumento_id_documento INT NOT NULL,
  Rol_id_rol INT NOT NULL,
  CONSTRAINT fk_Usuario_TipoDocumento FOREIGN KEY (TipoDocumento_id_documento) REFERENCES TipoDocumento (id_documento),
  CONSTRAINT fk_Usuario_Rol FOREIGN KEY (Rol_id_rol) REFERENCES Rol (id_rol)
);

CREATE TABLE Producto (
  id_producto SERIAL PRIMARY KEY,
  descripcion VARCHAR(45) NOT NULL,
  precio REAL NOT NULL,
  Catalogo_id_catalogo INT NOT NULL,
  CONSTRAINT fk_Producto_Catalogo FOREIGN KEY (Catalogo_id_catalogo) REFERENCES Catalogo (id_catalogo)
);

CREATE TABLE CotizacionCabecera (
  id_cotizacion SERIAL PRIMARY KEY,
  fecha DATE NOT NULL,
  valor_unitario DECIMAL(10,2) NOT NULL,
  iva DECIMAL(10,2) NOT NULL,
  subtotal DECIMAL(10,2) NOT NULL,
  total DECIMAL(10,2) NOT NULL,
  Usuario_id_usuario INT NOT NULL,
  TiposDocCon_id_doc_con INT NOT NULL,
  CONSTRAINT fk_Cotizacion_Usuario FOREIGN KEY (Usuario_id_usuario) REFERENCES Usuario (id_usuario),
  CONSTRAINT fk_Cotizacion_TiposDocCon FOREIGN KEY (TiposDocCon_id_doc_con) REFERENCES TiposDocCon (id_doc_con)
);

CREATE TABLE DetalleCotizacion (
  id_detalle SERIAL PRIMARY KEY,
  cantidad INT NOT NULL,
  alto DECIMAL(10,2) NOT NULL,
  largo DECIMAL(10,2) NOT NULL,
  ancho DECIMAL(10,2) NOT NULL,
  color VARCHAR(45) NULL,
  acabado VARCHAR(45) NULL,
  descripcion_uso_caja VARCHAR(45) NULL,
  CotizacionCabecera_id_cotizacion INT NOT NULL,
  CONSTRAINT fk_DetalleCot_Cabecera FOREIGN KEY (CotizacionCabecera_id_cotizacion) REFERENCES CotizacionCabecera (id_cotizacion)
);

CREATE TABLE PedidoCabecera (
  id_pedido SERIAL PRIMARY KEY,
  fecha DATE NOT NULL,
  direccion_envio VARCHAR(45) NOT NULL,
  total REAL NOT NULL,
  estado_pedido VARCHAR(45) NOT NULL,
  CotizacionCabecera_id_cotizacion INT NOT NULL,
  CONSTRAINT fk_Pedido_Cotizacion FOREIGN KEY (CotizacionCabecera_id_cotizacion) REFERENCES CotizacionCabecera (id_cotizacion)
);

CREATE TABLE FacturaCabecera (
  id_factura SERIAL PRIMARY KEY,
  numero_factura INT NOT NULL,
  total DECIMAL(10,2) NOT NULL,
  PedidoCabecera_id_pedido INT NOT NULL,
  PedidoCabecera_CotizacionCabecera_id_cotizacion INT NOT NULL,  
  CONSTRAINT fk_Factura_Pedido FOREIGN KEY (PedidoCabecera_id_pedido)  
    REFERENCES PedidoCabecera (id_pedido),
  CONSTRAINT fk_Factura_Cotizacion FOREIGN KEY (PedidoCabecera_CotizacionCabecera_id_cotizacion)  
    REFERENCES CotizacionCabecera (id_cotizacion)  
);

CREATE TABLE PedidoDetalle (
  id_pedido_detalle SERIAL PRIMARY KEY,
  cantidad INT NOT NULL,
  subtotal DECIMAL(10,2) NOT NULL,
  PedidoCabecera_id_pedido INT NOT NULL,
  PedidoCabecera_CotizacionCabecera_id_cotizacion INT NOT NULL,
  CONSTRAINT fk_PedidoDetalle_Pedido FOREIGN KEY (PedidoCabecera_id_pedido)  
    REFERENCES PedidoCabecera (id_pedido),
  CONSTRAINT fk_PedidoDetalle_Cotizacion FOREIGN KEY (PedidoCabecera_CotizacionCabecera_id_cotizacion)  
    REFERENCES CotizacionCabecera (id_cotizacion)
);

CREATE TABLE DetalleFactura (
  id_detalle_factura SERIAL PRIMARY KEY,
  cantidad INT NOT NULL,
  valor_unitario DECIMAL(10,2) NOT NULL,
  subtotal DECIMAL(10,2) NOT NULL,
  FacturaCabecera_id_factura INT NOT NULL,
  Producto_id_producto INT NOT NULL,
  CONSTRAINT fk_DetalleFactura_Factura FOREIGN KEY (FacturaCabecera_id_factura) REFERENCES FacturaCabecera (id_factura),
  CONSTRAINT fk_DetalleFactura_Producto FOREIGN KEY (Producto_id_producto) REFERENCES Producto (id_producto)
);

CREATE TABLE Pago (
  id_pago SERIAL PRIMARY KEY,
  monto DECIMAL(10,2) NOT NULL,
  fecha DATE NOT NULL,
  total DECIMAL(10,2) NOT NULL,
  referencia_pago VARCHAR(45) NULL,
  FacturaCabecera_id_factura INT NOT NULL,
  MedioPago_id_medio_pago INT NOT NULL,
  CONSTRAINT fk_Pago_Factura FOREIGN KEY (FacturaCabecera_id_factura) REFERENCES FacturaCabecera (id_factura),
  CONSTRAINT fk_Pago_MedioPago FOREIGN KEY (MedioPago_id_medio_pago) REFERENCES MedioPago (id_medio_pago)
);


--- SCRIPTS DE INSERCIÓN ---

INSERT INTO tipodocumento (descripcion_tipo)
VALUES ('cedula'),
('Tarjeta de identidad'),
('Pasaporte'),
('Cedula extranjera');

INSERT INTO rol (detalle_rol)
VALUES ('Administrador'),
('Cliente');

INSERT INTO tiposdoccon (codigo_con, numero_actual)
VALUES (101, 1001),
(102, 1002),
(103, 1003),
(104, 1004),
(105, 1005);

INSERT INTO mediopago (seleccionar_pago)
VALUES ('tarjeta de credito'),
('tarjeta de debito'),
('pse');

INSERT INTO catalogo (url)
VALUES ('www.google.drive');

INSERT INTO usuario (nombre, apellido, identificacion_usuario, direccion, telefono, correo, clave, TipoDocumento_id_documento, Rol_id_rol)
VALUES
('Andres', 'Gomez', '85948394', 'cra 7 G 58-50', '315694850', 'amiguito@gmail.com', 'amiguito1234', 3, 2),
('Dylan', 'Guzman', '45654347', 'cra 4 K 17-59', '315694850', 'amiguito@gmail.com', 'amiguito1234', 4, 2),
('Andriy', 'Castillo', '65657575', 'cra 86 K 87-59', '315694850', 'amiguito@gmail.com', 'amiguito1234', 1, 2),
('Arley', 'Giraldo', '375354657', 'cra 89 K 27-59', '315694850', 'amiguito@gmail.com', 'amiguito1234', 1, 2);

INSERT INTO producto (descripcion, precio, catalogo_id_catalogo)
VALUES ('caja para archivo', 5500, 1),
('caja para gallos', 5000, 1),
('caja para mudanza', 6000, 1);

INSERT INTO cotizacioncabecera (fecha, valor_unitario, iva, subtotal, total, Usuario_id_usuario, TiposDocCon_id_doc_con)
VALUES ('2026-04-10', 50000, 9500, 50000, 59500, 1, 2),
('2026-04-11', 120000, 22800, 120000, 142800, 2, 2),
('2026-04-12', 75000, 14250, 75000, 89250, 3, 2);

INSERT INTO detallecotizacion (cantidad, alto, largo, ancho, color, acabado, descripcion_uso_caja, CotizacionCabecera_id_cotizacion)
VALUES (10, 10.5, 5.5, 5.5, 'rojo', 'pizza', 'para empacar pizzas', 1),
(15, 20.5, 10.5, 9.5, 'verde', 'gallos', 'para empacar gallos', 2),
(20, 15.5, 7.5, 4.5, 'azul', 'computadores', 'para empacar computadores', 3);

INSERT INTO pedidocabecera (fecha, direccion_envio, total, estado_pedido, CotizacionCabecera_id_cotizacion)
VALUES ('2026-04-10', 'cra 7 G 58-50', 59500, 'entregado', 1),
('2026-04-11', 'cra 4 K 17-59', 142800, 'en proceso', 2),
('2026-04-12', 'cra 86 K 87-59', 89250, 'entregado', 3);

INSERT INTO facturacabecera (numero_factura, total, PedidoCabecera_id_pedido, PedidoCabecera_CotizacionCabecera_id_cotizacion)
VALUES (10, 59500, 1, 1),
(11, 142800, 2, 2),
(12, 89250, 3, 3);

INSERT INTO pedidodetalle (cantidad, subtotal, PedidoCabecera_id_pedido, PedidoCabecera_CotizacionCabecera_id_cotizacion)
VALUES (10, 50000, 1, 1),
(15, 120000, 2, 2),
(20, 75000, 3, 3);

INSERT INTO detallefactura (cantidad, valor_unitario, subtotal, FacturaCabecera_id_factura, Producto_id_producto)
VALUES (10, 50000, 50000, 1, 1),
(15, 25000, 25000, 2, 2),
(12, 100000, 100000, 3, 3);

INSERT INTO pago (monto, fecha, total, referencia_pago, FacturaCabecera_id_factura, MedioPago_id_medio_pago)
VALUES (50000, '2026-04-13', 50000, '1', 1, 3),
(10000, '2026-04-10', 10000, '2', 1, 1),
(20000, '2026-04-05', 20000, '3', 2, 2);