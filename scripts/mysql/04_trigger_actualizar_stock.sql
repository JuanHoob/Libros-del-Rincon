DELIMITER $$

CREATE TRIGGER actualizar_stock
AFTER INSERT ON Items_Pedido
FOR EACH ROW
BEGIN
  UPDATE Libros
  SET cantidad_en_stock = cantidad_en_stock - NEW.cantidad
  WHERE id_libro = NEW.id_libro;
END $$

DELIMITER ;
