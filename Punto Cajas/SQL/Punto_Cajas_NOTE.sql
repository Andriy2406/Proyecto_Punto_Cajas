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
  `idDocumento` INT NOT NULL AUTO_INCREMENT,
  `descripcionTipo` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idDocumento`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `punto_cajas`.`Rol`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `punto_cajas`.`Rol` (
  `idRol` INT NOT NULL AUTO_INCREMENT,
  `detalleRol` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idRol`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `punto_cajas`.`Usuario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `punto_cajas`.`Usuario` (
  `idUsuario` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  `apellido` VARCHAR(45) NOT NULL,
  `identificacionUsuario` VARCHAR(45) NOT NULL,
  `direccion` VARCHAR(45) NOT NULL,
  `telefono` VARCHAR(45) NOT NULL,
  `correo` VARCHAR(45) NOT NULL,
  `clave` VARCHAR(45) NOT NULL,
  `fechaDeNacimiento` DATE NOT NULL,
  `fechaDeVencimientoClave` DATE NOT NULL,
  `autorizacionDatos` TINYINT NOT NULL,
  `idDocumento` INT NOT NULL,
  `idRol` INT NOT NULL,
  PRIMARY KEY (`id_usuario`),
  INDEX `fk_Usuario_TipoDocumento1_idx` (`idDocumento` ASC)  ,
  INDEX `fk_Usuario_Rol1_idx` (`idRol` ASC)  ,
  UNIQUE INDEX `correo_UNIQUE` (`correo` ASC)  ,
  CONSTRAINT `fk_Usuario_TipoDocumento1`
    FOREIGN KEY (`idDocumento`)
    REFERENCES `punto_cajas`.`TipoDocumento` (`idDocumento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Usuario_Rol1`
    FOREIGN KEY (`idRol`)
    REFERENCES `punto_cajas`.`Rol` (`idRol`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `punto_cajas`.`TiposDocCon`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `punto_cajas`.`TiposDocCon` (
  `idDocCon` INT NOT NULL AUTO_INCREMENT,
  `codigoCon` INT NOT NULL,
  `numeroActual` INT NOT NULL,
  PRIMARY KEY (`idDocCon`),
  UNIQUE INDEX `codigo_con_UNIQUE` (`codigoCon` ASC)  )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `punto_cajas`.`CotizacionCabecera`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `punto_cajas`.`CotizacionCabecera` (
  `idCotizacion` INT NOT NULL AUTO_INCREMENT,
  `fecha` DATE NOT NULL,
  `valorUnitario` DECIMAL NOT NULL,
  `iva` DECIMAL NOT NULL,
  `subtotal` DECIMAL NOT NULL,
  `total` DECIMAL NOT NULL,
  `idUsuario` INT NOT NULL,
  `idDocCon` INT NOT NULL,
  PRIMARY KEY (`idCotizacion`, `idDocCon`),
  INDEX `fk_CotizacionCabecera_Usuario1_idx` (`idUsuario` ASC)  ,
  INDEX `fk_CotizacionCabecera_TiposDocCon1_idx` (`idDocCon` ASC)  ,
  CONSTRAINT `fk_CotizacionCabecera_Usuario1`
    FOREIGN KEY (`idUsuario`)
    REFERENCES `punto_cajas`.`Usuario` (`id_usuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_CotizacionCabecera_TiposDocCon1`
    FOREIGN KEY (`idDocCon`)
    REFERENCES `punto_cajas`.`TiposDocCon` (`idDocCon`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `punto_cajas`.`DetalleCotizacion`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `punto_cajas`.`DetalleCotizacion` (
  `idDetalle` INT NOT NULL AUTO_INCREMENT,
  `cantidad` INT NOT NULL,
  `alto` DECIMAL NOT NULL,
  `largo` DECIMAL NOT NULL,
  `ancho` DECIMAL NOT NULL,
  `color` VARCHAR(45) NOT NULL,
  `acabado` VARCHAR(45) NOT NULL,
  `descripcionUsoCaja` VARCHAR(45) NOT NULL,
  `idCotizacion` INT NOT NULL,
  PRIMARY KEY (`idDetalle`, `idCotizacion`),
  INDEX `fk_DetalleCotizacion_CotizacionCabecera1_idx` (`idCotizacion` ASC)  ,
  CONSTRAINT `fk_DetalleCotizacion_CotizacionCabecera1`
    FOREIGN KEY (`idCotizacion`)
    REFERENCES `punto_cajas`.`CotizacionCabecera` (`idCotizacion`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `punto_cajas`.`Catalogo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `punto_cajas`.`Catalogo` (
  `idCatalogo` INT NOT NULL AUTO_INCREMENT,
  `stockActual` VARCHAR(45) NOT NULL,
  `url` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idCatalogo`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `punto_cajas`.`Producto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `punto_cajas`.`Producto` (
  `idProducto` INT NOT NULL AUTO_INCREMENT,
  `descripcion` VARCHAR(45) NOT NULL,
  `precio` FLOAT NOT NULL,
  `idCatalogo` INT NOT NULL,
  PRIMARY KEY (`idProducto`),
  INDEX `fk_Producto_Catalogo1_idx` (`idCatalogo` ASC)  ,
  CONSTRAINT `fk_Producto_Catalogo1`
    FOREIGN KEY (`idCatalogo`)
    REFERENCES `punto_cajas`.`Catalogo` (`idCatalogo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `punto_cajas`.`PedidoCabecera`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `punto_cajas`.`PedidoCabecera` (
  `idPedido` INT NOT NULL AUTO_INCREMENT,
  `fecha` DATE NOT NULL,
  `direccionEnvio` VARCHAR(45) NOT NULL,
  `total` FLOAT NOT NULL,
  `estadoPedido` VARCHAR(45) NOT NULL,
  `idCotizacion` INT NOT NULL,
  PRIMARY KEY (`idPedido`, `idCotizacion`),
  INDEX `fk_PedidoCabecera_CotizacionCabecera1_idx` (`idCotizacion` ASC)  ,
  CONSTRAINT `fk_PedidoCabecera_CotizacionCabecera1`
    FOREIGN KEY (`idCotizacion`)
    REFERENCES `punto_cajas`.`CotizacionCabecera` (`idCotizacion`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `punto_cajas`.`FacturaCabecera`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `punto_cajas`.`FacturaCabecera` (
  `idFactura` INT NOT NULL AUTO_INCREMENT,
  `numeroFactura` INT NOT NULL,
  `total` DECIMAL NOT NULL,
  `idPedido` INT NOT NULL,
  `idCotizacion` INT NOT NULL,
  PRIMARY KEY (`idFactura`),
  INDEX `fk_FacturaCabecera_PedidoCabecera1_idx` (`idPedido` ASC, `idCotizacion` ASC)  ,
  CONSTRAINT `fk_FacturaCabecera_PedidoCabecera1`
    FOREIGN KEY (`idPedido` , `idCotizacion`)
    REFERENCES `punto_cajas`.`PedidoCabecera` (`idPedido` , `idCotizacion`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `punto_cajas`.`DetalleFactura`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `punto_cajas`.`DetalleFactura` (
  `idDetalleFactura` INT NOT NULL AUTO_INCREMENT,
  `cantidad` INT NOT NULL,
  `valorUnitario` DECIMAL NOT NULL,
  `subtotal` DECIMAL NOT NULL,
  `idFactura` INT NOT NULL,
  `idProducto` INT NOT NULL,
  PRIMARY KEY (`idDetalleFactura`, `idFactura`),
  INDEX `fk_DetalleFactura_FacturaCabecera1_idx` (`idFactura` ASC)  ,
  INDEX `fk_DetalleFactura_Producto1_idx` (`idProducto` ASC)  ,
  CONSTRAINT `fk_DetalleFactura_FacturaCabecera1`
    FOREIGN KEY (`idFactura`)
    REFERENCES `punto_cajas`.`FacturaCabecera` (`idFactura`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_DetalleFactura_Producto1`
    FOREIGN KEY (`idProducto`)
    REFERENCES `punto_cajas`.`Producto` (`idProducto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `punto_cajas`.`MedioPago`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `punto_cajas`.`MedioPago` (
  `idMedioPago` INT NOT NULL AUTO_INCREMENT,
  `seleccionarPago` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idMedioPago`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `punto_cajas`.`Pago`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `punto_cajas`.`Pago` (
  `idPago` INT NOT NULL AUTO_INCREMENT,
  `monto` DECIMAL NOT NULL,
  `fecha` DATE NOT NULL,
  `total` DECIMAL NOT NULL,
  `referenciaPago` VARCHAR(45) NOT NULL,
  `idFactura` INT NOT NULL,
  `idMedioPago` INT NOT NULL,
  PRIMARY KEY (`idPago`),
  INDEX `fk_Pago_FacturaCabecera1_idx` (`idFactura` ASC)  ,
  INDEX `fk_Pago_MedioPago1_idx` (`idMedioPago` ASC)  ,
  CONSTRAINT `fk_Pago_FacturaCabecera1`
    FOREIGN KEY (`idFactura`)
    REFERENCES `punto_cajas`.`FacturaCabecera` (`idFactura`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Pago_MedioPago1`
    FOREIGN KEY (`idMedioPago`)
    REFERENCES `punto_cajas`.`MedioPago` (`idMedioPago`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `punto_cajas`.`PedidoDetalle`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `punto_cajas`.`PedidoDetalle` (
  `idPedidoDetalle` INT NOT NULL AUTO_INCREMENT,
  `cantidad` INT NOT NULL,
  `subtotal` DECIMAL NOT NULL,
  `idPedido` INT NOT NULL,
  `idCotizacion` INT NOT NULL,
  PRIMARY KEY (`idPedidoDetalle`, `idPedido`, `idCotizacion`),
  INDEX `fk_PedidoDetalle_PedidoCabecera1_idx` (`idPedido` ASC, `idCotizacion` ASC)  ,
  CONSTRAINT `fk_PedidoDetalle_PedidoCabecera1`
    FOREIGN KEY (`idPedido` , `idCotizacion`)
    REFERENCES `punto_cajas`.`PedidoCabecera` (`idPedido` , `idCotizacion`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `punto_cajas`.`Permiso`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `punto_cajas`.`Permiso` (
  `idPermiso` INT NOT NULL AUTO_INCREMENT,
  `descripcion` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`idPermiso`),
  UNIQUE INDEX `idPermiso_UNIQUE` (`idPermiso` ASC)  )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `punto_cajas`.`Rol_permisos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `punto_cajas`.`Rol_permisos` (
  `idRol` INT NOT NULL,
  `idPermiso` INT NOT NULL,
  INDEX `fk_Rol_has_Permiso_Permiso1_idx` (`idPermiso` ASC)  ,
  INDEX `fk_Rol_has_Permiso_Rol1_idx` (`idRol` ASC)  ,
  PRIMARY KEY (`idRol`, `idPermiso`),
  CONSTRAINT `fk_Rol_has_Permiso_Rol1`
    FOREIGN KEY (`idRol`)
    REFERENCES `punto_cajas`.`Rol` (`idRol`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Rol_has_Permiso_Permiso1`
    FOREIGN KEY (`idPermiso`)
    REFERENCES `punto_cajas`.`Permiso` (`idPermiso`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
