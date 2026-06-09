-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema punto_cajas
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema punto_cajas
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `punto_cajas` DEFAULT CHARACTER SET utf8 ;
USE `punto_cajas` ;

-- -----------------------------------------------------
-- Table `punto_cajas`.`TipoDocumento`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `punto_cajas`.`TipoDocumento` (
  `id_documento` INT NOT NULL AUTO_INCREMENT,
  `descriipcion_tipo` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_documento`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `punto_cajas`.`Rol`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `punto_cajas`.`Rol` (
  `id_rol` INT NOT NULL AUTO_INCREMENT,
  `detalle_rol` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_rol`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `punto_cajas`.`Usuario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `punto_cajas`.`Usuario` (
  `id_usuario` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  `apellido` VARCHAR(45) NOT NULL,
  `identificacion_usuario` VARCHAR(45) NOT NULL,
  `direccion` VARCHAR(45) NOT NULL,
  `telefono` VARCHAR(45) NOT NULL,
  `correo` VARCHAR(45) NOT NULL,
  `clave` VARCHAR(45) NOT NULL,
  `fecha_de_nacimiento` DATE NOT NULL,
  `fecha_de_vencimiento_clave` DATE NOT NULL,
  `autorizacion_datos` TINYINT NOT NULL,
  `TipoDocumento_id_documento` INT NOT NULL,
  `Rol_id_rol` INT NOT NULL,
  PRIMARY KEY (`id_usuario`),
  INDEX `fk_Usuario_TipoDocumento1_idx` (`TipoDocumento_id_documento` ASC)  ,
  INDEX `fk_Usuario_Rol1_idx` (`Rol_id_rol` ASC)  ,
  UNIQUE INDEX `correo_UNIQUE` (`correo` ASC)  ,
  CONSTRAINT `fk_Usuario_TipoDocumento1`
    FOREIGN KEY (`TipoDocumento_id_documento`)
    REFERENCES `punto_cajas`.`TipoDocumento` (`id_documento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Usuario_Rol1`
    FOREIGN KEY (`Rol_id_rol`)
    REFERENCES `punto_cajas`.`Rol` (`id_rol`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `punto_cajas`.`TiposDocCon`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `punto_cajas`.`TiposDocCon` (
  `id_doc_con` INT NOT NULL AUTO_INCREMENT,
  `codigo_con` INT NOT NULL,
  `numero_actual` INT NOT NULL,
  PRIMARY KEY (`id_doc_con`),
  UNIQUE INDEX `codigo_con_UNIQUE` (`codigo_con` ASC)  )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `punto_cajas`.`CotizacionCabecera`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `punto_cajas`.`CotizacionCabecera` (
  `id_cotizacion` INT NOT NULL AUTO_INCREMENT,
  `fecha` DATE NOT NULL,
  `valor_unitario` DECIMAL NOT NULL,
  `iva` DECIMAL NOT NULL,
  `subtotal` DECIMAL NOT NULL,
  `total` DECIMAL NOT NULL,
  `Usuario_id_usuario` INT NOT NULL,
  `TiposDocCon_id_doc_con` INT NOT NULL,
  PRIMARY KEY (`id_cotizacion`, `TiposDocCon_id_doc_con`),
  INDEX `fk_CotizacionCabecera_Usuario1_idx` (`Usuario_id_usuario` ASC)  ,
  INDEX `fk_CotizacionCabecera_TiposDocCon1_idx` (`TiposDocCon_id_doc_con` ASC)  ,
  CONSTRAINT `fk_CotizacionCabecera_Usuario1`
    FOREIGN KEY (`Usuario_id_usuario`)
    REFERENCES `punto_cajas`.`Usuario` (`id_usuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_CotizacionCabecera_TiposDocCon1`
    FOREIGN KEY (`TiposDocCon_id_doc_con`)
    REFERENCES `punto_cajas`.`TiposDocCon` (`id_doc_con`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `punto_cajas`.`DetalleCotizacion`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `punto_cajas`.`DetalleCotizacion` (
  `id_detalle` INT NOT NULL AUTO_INCREMENT,
  `cantidad` INT NOT NULL,
  `alto` DECIMAL NOT NULL,
  `largo` DECIMAL NOT NULL,
  `ancho` DECIMAL NOT NULL,
  `color` VARCHAR(45) NOT NULL,
  `acabado` VARCHAR(45) NOT NULL,
  `descripcion_uso_caja` VARCHAR(45) NOT NULL,
  `CotizacionCabecera_id_cotizacion` INT NOT NULL,
  PRIMARY KEY (`id_detalle`, `CotizacionCabecera_id_cotizacion`),
  INDEX `fk_DetalleCotizacion_CotizacionCabecera1_idx` (`CotizacionCabecera_id_cotizacion` ASC)  ,
  CONSTRAINT `fk_DetalleCotizacion_CotizacionCabecera1`
    FOREIGN KEY (`CotizacionCabecera_id_cotizacion`)
    REFERENCES `punto_cajas`.`CotizacionCabecera` (`id_cotizacion`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `punto_cajas`.`Catalogo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `punto_cajas`.`Catalogo` (
  `id_catalogo` INT NOT NULL AUTO_INCREMENT,
  `stock_actual` VARCHAR(45) NOT NULL,
  `url` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_catalogo`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `punto_cajas`.`Producto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `punto_cajas`.`Producto` (
  `id_producto` INT NOT NULL AUTO_INCREMENT,
  `descripcion` VARCHAR(45) NOT NULL,
  `precio` FLOAT NOT NULL,
  `Catalogo_id_catalogo` INT NOT NULL,
  PRIMARY KEY (`id_producto`),
  INDEX `fk_Producto_Catalogo1_idx` (`Catalogo_id_catalogo` ASC)  ,
  CONSTRAINT `fk_Producto_Catalogo1`
    FOREIGN KEY (`Catalogo_id_catalogo`)
    REFERENCES `punto_cajas`.`Catalogo` (`id_catalogo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `punto_cajas`.`PedidoCabecera`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `punto_cajas`.`PedidoCabecera` (
  `id_pedido` INT NOT NULL AUTO_INCREMENT,
  `fecha` DATE NOT NULL,
  `direccion_envio` VARCHAR(45) NOT NULL,
  `total` FLOAT NOT NULL,
  `estado_pedido` VARCHAR(45) NOT NULL,
  `CotizacionCabecera_id_cotizacion` INT NOT NULL,
  PRIMARY KEY (`id_pedido`, `CotizacionCabecera_id_cotizacion`),
  INDEX `fk_PedidoCabecera_CotizacionCabecera1_idx` (`CotizacionCabecera_id_cotizacion` ASC)  ,
  CONSTRAINT `fk_PedidoCabecera_CotizacionCabecera1`
    FOREIGN KEY (`CotizacionCabecera_id_cotizacion`)
    REFERENCES `punto_cajas`.`CotizacionCabecera` (`id_cotizacion`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `punto_cajas`.`FacturaCabecera`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `punto_cajas`.`FacturaCabecera` (
  `id_factura` INT NOT NULL AUTO_INCREMENT,
  `numero_factura` INT NOT NULL,
  `total` DECIMAL NOT NULL,
  `PedidoCabecera_id_pedido` INT NOT NULL,
  `PedidoCabecera_CotizacionCabecera_id_cotizacion` INT NOT NULL,
  PRIMARY KEY (`id_factura`),
  INDEX `fk_FacturaCabecera_PedidoCabecera1_idx` (`PedidoCabecera_id_pedido` ASC, `PedidoCabecera_CotizacionCabecera_id_cotizacion` ASC)  ,
  CONSTRAINT `fk_FacturaCabecera_PedidoCabecera1`
    FOREIGN KEY (`PedidoCabecera_id_pedido` , `PedidoCabecera_CotizacionCabecera_id_cotizacion`)
    REFERENCES `punto_cajas`.`PedidoCabecera` (`id_pedido` , `CotizacionCabecera_id_cotizacion`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `punto_cajas`.`DetalleFactura`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `punto_cajas`.`DetalleFactura` (
  `id_detalle_factura` INT NOT NULL AUTO_INCREMENT,
  `cantidad` INT NOT NULL,
  `valor_unitario` DECIMAL NOT NULL,
  `subtotal` DECIMAL NOT NULL,
  `FacturaCabecera_id_factura` INT NOT NULL,
  `Producto_id_producto` INT NOT NULL,
  PRIMARY KEY (`id_detalle_factura`, `FacturaCabecera_id_factura`),
  INDEX `fk_DetalleFactura_FacturaCabecera1_idx` (`FacturaCabecera_id_factura` ASC)  ,
  INDEX `fk_DetalleFactura_Producto1_idx` (`Producto_id_producto` ASC)  ,
  CONSTRAINT `fk_DetalleFactura_FacturaCabecera1`
    FOREIGN KEY (`FacturaCabecera_id_factura`)
    REFERENCES `punto_cajas`.`FacturaCabecera` (`id_factura`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_DetalleFactura_Producto1`
    FOREIGN KEY (`Producto_id_producto`)
    REFERENCES `punto_cajas`.`Producto` (`id_producto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `punto_cajas`.`MedioPago`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `punto_cajas`.`MedioPago` (
  `id_medio_pago` INT NOT NULL AUTO_INCREMENT,
  `seleccionar_pago` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_medio_pago`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `punto_cajas`.`Pago`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `punto_cajas`.`Pago` (
  `id_pago` INT NOT NULL AUTO_INCREMENT,
  `monto` DECIMAL NOT NULL,
  `fecha` DATE NOT NULL,
  `total` DECIMAL NOT NULL,
  `referencia_pago` VARCHAR(45) NOT NULL,
  `FacturaCabecera_id_factura` INT NOT NULL,
  `MedioPago_id_medio_pago` INT NOT NULL,
  PRIMARY KEY (`id_pago`),
  INDEX `fk_Pago_FacturaCabecera1_idx` (`FacturaCabecera_id_factura` ASC)  ,
  INDEX `fk_Pago_MedioPago1_idx` (`MedioPago_id_medio_pago` ASC)  ,
  CONSTRAINT `fk_Pago_FacturaCabecera1`
    FOREIGN KEY (`FacturaCabecera_id_factura`)
    REFERENCES `punto_cajas`.`FacturaCabecera` (`id_factura`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Pago_MedioPago1`
    FOREIGN KEY (`MedioPago_id_medio_pago`)
    REFERENCES `punto_cajas`.`MedioPago` (`id_medio_pago`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `punto_cajas`.`PedidoDetalle`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `punto_cajas`.`PedidoDetalle` (
  `id_pedido_detalle` INT NOT NULL AUTO_INCREMENT,
  `cantidad` INT NOT NULL,
  `subtotal` DECIMAL NOT NULL,
  `PedidoCabecera_id_pedido` INT NOT NULL,
  `PedidoCabecera_CotizacionCabecera_id_cotizacion` INT NOT NULL,
  PRIMARY KEY (`id_pedido_detalle`, `PedidoCabecera_id_pedido`, `PedidoCabecera_CotizacionCabecera_id_cotizacion`),
  INDEX `fk_PedidoDetalle_PedidoCabecera1_idx` (`PedidoCabecera_id_pedido` ASC, `PedidoCabecera_CotizacionCabecera_id_cotizacion` ASC)  ,
  CONSTRAINT `fk_PedidoDetalle_PedidoCabecera1`
    FOREIGN KEY (`PedidoCabecera_id_pedido` , `PedidoCabecera_CotizacionCabecera_id_cotizacion`)
    REFERENCES `punto_cajas`.`PedidoCabecera` (`id_pedido` , `CotizacionCabecera_id_cotizacion`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `punto_cajas`.`Permiso`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `punto_cajas`.`Permiso` (
  `id_permiso` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(100) NOT NULL,
  `descripcion` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id_permiso`),
  UNIQUE INDEX `idPermiso_UNIQUE` (`id_permiso` ASC)  )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `punto_cajas`.`Rol_permisos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `punto_cajas`.`Rol_permisos` (
  `Rol_id_rol` INT NOT NULL,
  `Permiso_id_permiso` INT NOT NULL,
  INDEX `fk_Rol_has_Permiso_Permiso1_idx` (`Permiso_id_permiso` ASC)  ,
  INDEX `fk_Rol_has_Permiso_Rol1_idx` (`Rol_id_rol` ASC)  ,
  PRIMARY KEY (`Rol_id_rol`, `Permiso_id_permiso`),
  CONSTRAINT `fk_Rol_has_Permiso_Rol1`
    FOREIGN KEY (`Rol_id_rol`)
    REFERENCES `punto_cajas`.`Rol` (`id_rol`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Rol_has_Permiso_Permiso1`
    FOREIGN KEY (`Permiso_id_permiso`)
    REFERENCES `punto_cajas`.`Permiso` (`id_permiso`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;



SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
