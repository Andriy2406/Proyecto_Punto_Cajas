-- 1. Tablas Catálogo e Independientes
CREATE TABLE tipos_de_documentos (
  id_documento SERIAL PRIMARY KEY,
  descripcion_tipo VARCHAR(45) NOT NULL
);

CREATE TABLE roles (
  id_rol SERIAL PRIMARY KEY,
  detalle_rol VARCHAR(45) NOT NULL
);

CREATE TABLE tipos_doc_con (
  id_doc_con SERIAL PRIMARY KEY,
  codigo_con INT NOT NULL,
  numero_actual INT NOT NULL
);

CREATE TABLE catalogos (
  id_catalogo SERIAL PRIMARY KEY,
  stock_actual VARCHAR(45) NOT NULL,
  url VARCHAR(45) NULL
);

CREATE TABLE medios_de_pagos (
  id_medio_pago SERIAL PRIMARY KEY,
  seleccionar_pago VARCHAR(45) NOT NULL
);

CREATE TABLE permisos (
  id_permiso SERIAL PRIMARY KEY,
  nombre VARCHAR(100),
  descripcion VARCHAR(100)
);

CREATE TABLE rol_permisos (
  id_rol INT NOT NULL,
  id_permiso INT NOT NULL,
  CONSTRAINT fk_rol_permisos_roles FOREIGN KEY (id_rol) REFERENCES roles (id_rol),
  CONSTRAINT fk_rol_permisos_permisos FOREIGN KEY (id_permiso) REFERENCES permisos (id_permiso)
);

-- 2. Tablas Transaccionales y de Entidades Principales
CREATE TABLE usuarios (
  id_usuario SERIAL PRIMARY KEY,
  nombre VARCHAR(45) NOT NULL,
  apellido VARCHAR(45) NOT NULL,
  identificacion_usuario VARCHAR(45) NOT NULL,
  direccion VARCHAR(45) NULL,
  telefono VARCHAR(45) NULL,
  correo VARCHAR(45) NOT NULL,
  clave VARCHAR(45) NOT NULL,
  fecha_de_nacimiento DATE,
  fecha_de_vencimiento DATE,
  autorizacionDatos BOOLEAN,
  id_documento INT NOT NULL,
  id_rol INT NOT NULL,
  CONSTRAINT fk_usuario_tipo_de_documentos FOREIGN KEY (id_documento) REFERENCES tipos_de_documentos (id_documento),
  CONSTRAINT fk_usuario_roles FOREIGN KEY (id_rol) REFERENCES roles (id_rol)
);

CREATE TABLE productos (
  id_producto SERIAL PRIMARY KEY,
  descripcion VARCHAR(45) NOT NULL,
  precio REAL NOT NULL,
  id_catalogo INT NOT NULL,
  CONSTRAINT fk_producto_catalogo FOREIGN KEY (id_catalogo) REFERENCES catalogos (id_catalogo)
);

CREATE TABLE cotizaciones_cabeceras (
  id_cotizacion SERIAL PRIMARY KEY,
  fecha DATE NOT NULL,
  valor_unitario DECIMAL(10,2) NOT NULL,
  iva DECIMAL(10,2) NOT NULL,
  subtotal DECIMAL(10,2) NOT NULL,
  total DECIMAL(10,2) NOT NULL,
  id_usuario INT NOT NULL,
  id_doc_con INT NOT NULL,
  CONSTRAINT fk_cotizacion_usuario FOREIGN KEY (id_usuario) REFERENCES usuarios (id_usuario),
  CONSTRAINT fk_cotizacion_tipos_doc_con FOREIGN KEY (id_doc_con) REFERENCES tipos_doc_con (id_doc_con)
);

CREATE TABLE detalles_cotizaciones (
  id_detalle SERIAL PRIMARY KEY,
  cantidad INT NOT NULL,
  alto DECIMAL(10,2) NOT NULL,
  largo DECIMAL(10,2) NOT NULL,
  ancho DECIMAL(10,2) NOT NULL,
  color VARCHAR(45) NULL,
  acabado VARCHAR(45) NULL,
  descripcion_uso_caja VARCHAR(45) NULL,
  id_cotizacion INT NOT NULL,
  CONSTRAINT fk_detalle_cot_cabecera FOREIGN KEY (id_cotizacion) REFERENCES cotizaciones_cabeceras (id_cotizacion)
);

CREATE TABLE pedidos_cabeceras (
  id_pedido SERIAL PRIMARY KEY,
  fecha DATE NOT NULL,
  direccion_envio VARCHAR(45) NOT NULL,
  total REAL NOT NULL,
  estado_pedido VARCHAR(45) NOT NULL,
  id_cotizacion INT NOT NULL,
  CONSTRAINT fk_pedido_cotizacion FOREIGN KEY (id_cotizacion) REFERENCES cotizaciones_cabeceras (id_cotizacion)
);

CREATE TABLE facturas_cabeceras (
  id_factura SERIAL PRIMARY KEY,
  numero_factura INT NOT NULL,
  total DECIMAL(10,2) NOT NULL,
  id_pedido INT NOT NULL,
  id_cotizacion INT NOT NULL,  
  CONSTRAINT fk_factura_pedido FOREIGN KEY (id_pedido) REFERENCES pedidos_cabeceras (id_pedido),
  CONSTRAINT fk_factura_cotizacion FOREIGN KEY (id_cotizacion) REFERENCES cotizaciones_cabeceras (id_cotizacion)  
);

CREATE TABLE pedidos_detalles (
  id_pedido_detalle SERIAL PRIMARY KEY,
  cantidad INT NOT NULL,
  subtotal DECIMAL(10,2) NOT NULL,
  id_pedido INT NOT NULL,
  id_cotizacion INT NOT NULL,
  CONSTRAINT fk_pedido_detalle_Pedido FOREIGN KEY (id_pedido) REFERENCES pedidos_cabeceras (id_pedido),
  CONSTRAINT fk_pedido_detalle_cotizacion FOREIGN KEY (id_cotizacion) REFERENCES cotizaciones_cabeceras (id_cotizacion)
);

CREATE TABLE detalles_facturas (
  id_detalle_factura SERIAL PRIMARY KEY,
  cantidad INT NOT NULL,
  valor_unitario DECIMAL(10,2) NOT NULL,
  subtotal DECIMAL(10,2) NOT NULL,
  id_factura INT NOT NULL,
  id_producto INT NOT NULL,
  CONSTRAINT fk_detalle_factura_factura FOREIGN KEY (id_factura) REFERENCES facturas_cabeceras (id_factura),
  CONSTRAINT fk_detalle_factura_producto FOREIGN KEY (id_producto) REFERENCES productos (id_producto)
);

CREATE TABLE pagos (
  id_pago SERIAL PRIMARY KEY,
  monto DECIMAL(10,2) NOT NULL,
  fecha DATE NOT NULL,
  total DECIMAL(10,2) NOT NULL,
  referencia_pago VARCHAR(45) NULL,
  id_factura INT NOT NULL,
  id_medio_pago INT NOT NULL,
  CONSTRAINT fk_pago_factura FOREIGN KEY (id_factura) REFERENCES facturas_cabeceras (id_factura),
  CONSTRAINT fk_pago_medio_pago FOREIGN KEY (id_medio_pago) REFERENCES medios_de_pagos (id_medio_pago)
);


--- INSERCIÓN DE 10+ REGISTROS (Galácticos, Naruto y One Piece) ---

INSERT INTO tipos_de_documentos (descripcion_tipo) VALUES 
('Cedula de Ciudadania'), ('Pasaporte Shinobi'), ('Bounty Poster ID'), ('Tarjeta de Identidad Real'), ('Licencia de Conducir');

INSERT INTO roles (detalle_rol) VALUES 
('Presidente Club'), ('Hokage'), ('Rey de los Piratas'), ('Galáctico Estelar'), ('Capitán');

INSERT INTO tipos_doc_con (codigo_con, numero_actual) VALUES 
(101, 1500), (102, 2000), (103, 3000), (104, 4000), (105, 5000),
(106, 6000), (107, 7000), (108, 8000), (109, 9000), (110, 10000);

INSERT INTO catalogos (stock_actual, url) VALUES 
('50', 'www.madridgalacticos.com'), ('120', 'www.konahashop.com'), 
('80', 'www.thousandthousand.com'), ('15', 'www.championshop.es'), ('200', 'www.sharinganmarket.jp'),
('60', 'www.grandlineboxes.com'), ('90', 'www.santiagobernabeu.store'), ('110', 'www.hokagestore.org'), 
('40', 'www.strawhatmerch.com'), ('75', 'www.zidaneztore.com');

INSERT INTO medios_de_pagos (seleccionar_pago) VALUES 
('Tarjeta de Credito Bernabeu'), ('Beli Cash'), ('Ryo Coins'), ('Efectivo'), ('PayPal Galáctico'),
('Transferencia Konoha'), ('Bizum Real Madrid'), ('Crypto One Piece'), ('Cheque Zinedine'), ('Pago Movil Shinobi');

INSERT INTO permisos (nombre, descripcion) VALUES 
('CREAR_CAJA', 'Permiso para fabricar cajas de cartón'), ('GESTION_GALACTICA', 'Control total de fichajes estelares'),
('ACCESO_HOKAGE', 'Acceso a la torre principal de Konoha'), ('TESORO_PIRATA', 'Manejo de cofres de One Piece');

INSERT INTO rol_permisos (id_rol, id_permiso) VALUES 
(1, 2), (2, 3), (3, 4), (4, 1), (5, 4), (1, 1), (2, 1), (3, 1), (4, 2), (5, 3);

INSERT INTO usuarios (nombre, apellido, identificacion_usuario, direccion, telefono, correo, clave, fecha_de_nacimiento, fecha_de_vencimiento, autorizacionDatos, id_documento, id_rol) VALUES 
('Zinedine', 'Zidane', 'ZID5', 'Paseo de la Castellana 1', '5550001', 'zizou@realmadrid.es', 'calva123', '1972-06-23', '2030-01-01', TRUE, 1, 4),
('Naruto', 'Uzumaki', 'NAR7', 'Calle Ramen Ichiraku 10', '5550002', 'hokage@konoha.jp', 'rasengan99', '1999-10-10', '2030-01-01', TRUE, 2, 2),
('Monkey D.', 'Luffy', 'LUF1', 'Thousand Sunny Deck', '5550003', 'luffy@onepiece.com', 'meat1234', '2000-05-05', '2030-01-01', TRUE, 3, 3),
('Florentino', 'Perez', 'FLO1', 'Palacio ACS Madrid', '5550004', 'floren@realmadrid.es', 'fichajes', '1947-03-08', '2030-01-01', TRUE, 1, 1),
('Kakashi', 'Hatake', 'KAK6', 'Academia Ninja Konoha', '5550005', 'kakashi@sharingan.jp', 'book1234', '1984-09-15', '2030-01-01', TRUE, 2, 2),
('Roronoa', 'Zoro', 'ZOR3', 'Gimnasio Zoro Santoryu', '5550006', 'zoro@swordsman.com', 'espadas3', '1988-11-11', '2030-01-01', TRUE, 3, 5),
('David', 'Beckham', 'BEC7', 'Av. Concha Espina 23', '5550007', 'becks@galacticos.es', 'spiceboy', '1975-05-02', '2030-01-01', TRUE, 1, 4),
('Sasuke', 'Uchiha', 'SAS8', 'Valle del Fin', '5550008', 'sasuke@uchiha.jp', 'chidori', '1999-07-23', '2030-01-01', TRUE, 2, 2),
('Nami', 'Cat Burglar', 'NAM2', 'Navegacion Co', '5550009', 'nami@money.com', 'bellmeres', '2001-07-03', '2030-01-01', TRUE, 3, 5),
('Ronaldo', 'Nazario', 'RON9', 'Valdebebas Ciudad Real Madrid', '5550010', 'r9@fenomeno.es', 'gordito9', '1976-09-18', '2030-01-01', TRUE, 1, 4);

INSERT INTO productos (descripcion, precio, id_catalogo) VALUES 
('Caja Edicion Especial Real Madrid Champions', 45000, 1),
('Caja de Cartón para Pergaminos de Konoha', 15000, 2),
('Cofre Tesoro One Piece Madera de Roble', 95000, 3),
('Caja Autografiada por Zinedine Zidane', 120000, 4),
('Caja Estanca Logo de los Uchiha', 25000, 5),
('Caja Archivador Thousand Sunny', 30000, 6),
('Caja Premium Santiago Bernabeu', 50000, 7),
('Caja Mascara Anbu de Konoha', 35000, 8),
('Caja Sombrero de Paja', 40000, 9),
('Caja Galáctica R9', 85000, 10);

INSERT INTO cotizaciones_cabeceras (fecha, valor_unitario, iva, subtotal, total, id_usuario, id_doc_con) VALUES 
('2026-06-01', 45000, 8550, 45000, 53550, 1, 1),
('2026-06-02', 15000, 2850, 15000, 17850, 2, 2),
('2026-06-03', 95000, 18050, 95000, 113050, 3, 3),
('2026-06-04', 120000, 22800, 120000, 142800, 4, 4),
('2026-06-05', 25000, 4750, 25000, 29750, 5, 5),
('2026-06-06', 30000, 5700, 30000, 35700, 6, 6),
('2026-06-07', 50000, 9500, 50000, 59500, 7, 7),
('2026-06-08', 35000, 6650, 35000, 41650, 8, 8),
('2026-06-09', 40000, 7600, 40000, 47600, 9, 9),
('2026-06-10', 85000, 16150, 85000, 101150, 10, 10);

INSERT INTO detalles_cotizaciones (cantidad, alto, largo, ancho, color, acabado, descripcion_uso_caja, id_cotizacion) VALUES 
(2, 10.0, 20.0, 15.0, 'Blanco', 'Mate', 'Guardar camisetas del Madrid', 1),
(5, 5.0, 30.0, 10.0, 'Rojo', 'Brillante', 'Pergaminos de jutsu', 2),
(1, 40.0, 60.0, 40.0, 'Marron', 'Rústico', 'Monedas de oro piratas', 3),
(3, 15.0, 15.0, 15.0, 'Dorado', 'Lujo', 'Balones de oro', 4),
(4, 8.0, 12.0, 8.0, 'Negro', 'Opaco', 'Shurikens y Kunais', 5),
(2, 25.0, 35.0, 25.0, 'Azul', 'Impermeable', 'Mapas de navegación', 6),
(1, 20.0, 20.0, 20.0, 'Plata', 'Metalizado', 'Césped del Bernabeu', 7),
(6, 10.0, 15.0, 10.0, 'Blanco', 'Suave', 'Mascaras de ANBU', 8),
(3, 12.0, 12.0, 12.0, 'Amarillo', 'Paja', 'Sombreros coleccionables', 9),
(1, 30.0, 40.0, 30.0, 'Azul Rey', 'Especial', 'Memorable final de Champions', 10);

INSERT INTO pedidos_cabeceras (fecha, direccion_envio, total, estado_pedido, id_cotizacion) VALUES 
('2026-06-01', 'Paseo de la Castellana 1', 53550.0, 'Entregado', 1),
('2026-06-02', 'Torre del Hokage Konoha', 17850.0, 'En Proceso', 2),
('2026-06-03', 'Thousand Sunny Gran Line', 113050.0, 'Enviado', 3),
('2026-06-04', 'Palacio ACS Madrid', 142800.0, 'Entregado', 4),
('2026-06-05', 'Campo de Entrenamiento Uchiha', 29750.0, 'Pendiente', 5),
('2026-06-06', 'Arrecife de los Piratas', 35700.0, 'Entregado', 6),
('2026-06-07', 'Santiago Bernabeu VIP', 59500.0, 'Entregado', 7),
('2026-06-08', 'Aldea Oculta de la Hoja', 41650.0, 'En Proceso', 8),
('2026-06-09', 'East Blue Marina', 47600.0, 'Enviado', 9),
('2026-06-10', 'Ciudad Deportiva Valdebebas', 101150.0, 'Entregado', 10);

INSERT INTO facturas_cabeceras (numero_factura, total, id_pedido, id_cotizacion) VALUES 
(501, 53550.00, 1, 1),
(502, 17850.00, 2, 2),
(503, 113050.00, 3, 3),
(504, 142800.00, 4, 4),
(505, 29750.00, 5, 5),
(506, 35700.00, 6, 6),
(507, 59500.00, 7, 7),
(508, 41650.00, 8, 8),
(509, 47600.00, 9, 9),
(510, 101150.00, 10, 10);

INSERT INTO pedidos_detalles (cantidad, subtotal, id_pedido, id_cotizacion) VALUES 
(2, 45000, 1, 1),
(5, 15000, 2, 2),
(1, 95000, 3, 3),
(3, 120000, 4, 4),
(4, 25000, 5, 5),
(2, 30000, 6, 6),
(1, 50000, 7, 7),
(6, 35000, 8, 8),
(3, 40000, 9, 9),
(1, 85000, 10, 10);

INSERT INTO detalles_facturas (cantidad, valor_unitario, subtotal, id_factura, id_producto) VALUES 
(2, 22500, 45000, 1, 1),
(5, 3000, 15000, 2, 2),
(1, 95000, 95000, 3, 3),
(3, 40000, 120000, 4, 4),
(4, 6250, 25000, 5, 5),
(2, 15000, 30000, 6, 6),
(1, 50000, 50000, 7, 7),
(6, 5833, 35000, 8, 8),
(3, 13333, 40000, 9, 9),
(1, 85000, 85000, 10, 10);

INSERT INTO pagos (monto, fecha, total, referencia_pago, id_factura, id_medio_pago) VALUES 
(53550, '2026-06-01', 53550.00, 'REF-RM-01', 1, 1),
(17850, '2026-06-02', 17850.00, 'REF-KON-02', 2, 3),
(113050, '2026-06-03', 113050.00, 'REF-OP-03', 3, 2),
(142800, '2026-06-04', 142800.00, 'REF-RM-04', 4, 7),
(29750, '2026-06-05', 29750.00, 'REF-UCH-05', 5, 10),
(35700, '2026-06-06', 35700.00, 'REF-OP-06', 6, 8),
(59500, '2026-06-07', 59500.00, 'REF-RM-07', 7, 5),
(41650, '2026-06-08', 41650.00, 'REF-KON-08', 8, 6),
(47600, '2026-06-09', 47600.00, 'REF-OP-09', 9, 2),
(101150, '2026-06-10', 101150.00, 'REF-RM-10', 10, 1);