USE libros_rincon;

-- Informe diario de ventas por género
SELECT 
    l.genero,
    SUM(ip.cantidad * ip.precio_por_item) AS total_ventas
FROM 
    Pedidos p
JOIN 
    Items_Pedido ip ON p.id_pedido = ip.id_pedido
JOIN 
    Libros l ON ip.id_libro = l.id_libro
WHERE 
    p.fecha_pedido = CURDATE()
GROUP BY 
    l.genero;
