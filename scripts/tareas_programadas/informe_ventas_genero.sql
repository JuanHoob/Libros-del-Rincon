USE libros_rincon;

SELECT 
    CURDATE() AS fecha_informe,
    l.genero,
    SUM(ip.cantidad * ip.precio_por_item) AS total_ventas
FROM 
    Items_Pedido ip
JOIN 
    Libros l ON ip.id_libro = l.id_libro
JOIN 
    Pedidos p ON ip.id_pedido = p.id_pedido
WHERE 
    p.fecha_pedido = CURDATE()
GROUP BY 
    l.genero;