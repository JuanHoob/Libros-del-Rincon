EXPLAIN
SELECT DISTINCT c.nombre, c.apellido
FROM Clientes c
JOIN Pedidos p ON c.id_cliente = p.id_cliente
JOIN Items_Pedido ip ON p.id_pedido = ip.id_pedido
JOIN Libros l ON ip.id_libro = l.id_libro
WHERE l.genero = 'Ciencia Ficción'
  AND p.fecha_pedido >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH);

-- Recomendación:
-- CREATE INDEX idx_genero ON Libros(genero);
-- CREATE INDEX idx_fecha ON Pedidos(fecha_pedido);
