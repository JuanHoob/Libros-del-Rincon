CREATE USER 'gerente'@'localhost' IDENTIFIED BY 'gerente123';
CREATE USER 'agenteventas'@'localhost' IDENTIFIED BY 'ventas123';

GRANT ALL PRIVILEGES ON libros_rincon.* TO 'gerente'@'localhost';

GRANT SELECT ON libros_rincon.Libros TO 'agenteventas'@'localhost';
GRANT SELECT ON libros_rincon.Clientes TO 'agenteventas'@'localhost';
GRANT SELECT ON libros_rincon.Pedidos TO 'agenteventas'@'localhost';
GRANT INSERT ON libros_rincon.Pedidos TO 'agenteventas'@'localhost';
