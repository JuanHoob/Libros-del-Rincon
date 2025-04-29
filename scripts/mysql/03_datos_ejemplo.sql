-- Inserción de datos en la tabla Libros
INSERT INTO Libros (titulo, autor, genero, precio, cantidad_en_stock) VALUES
('1984', 'George Orwell', 'Ciencia Ficción', 9.99, 20),
('El Principito', 'Antoine de Saint-Exupéry', 'Fábula', 7.50, 15),
('Cien Años de Soledad', 'Gabriel García Márquez', 'Realismo Mágico', 12.00, 10),
('Dune', 'Frank Herbert', 'Ciencia Ficción', 14.25, 8),
('La Odisea', 'Homero', 'Clásico', 11.00, 5),
('Crónica de una Muerte Anunciada', 'Gabriel García Márquez', 'Drama', 8.50, 12),
('Neuromante', 'William Gibson', 'Ciencia Ficción', 10.00, 7),
('Don Quijote', 'Miguel de Cervantes', 'Clásico', 13.00, 9),
('Fahrenheit 451', 'Ray Bradbury', 'Ciencia Ficción', 9.25, 11),
('Rayuela', 'Julio Cortázar', 'Experimental', 10.75, 6);

-- Inserción de datos en la tabla Clientes
INSERT INTO Clientes (nombre, apellido, email, telefono) VALUES
('Ana', 'Pérez', 'ana.perez@example.com', '600111222'),
('Luis', 'Gómez', 'luis.gomez@example.com', '600222333'),
('María', 'López', 'maria.lopez@example.com', '600333444'),
('Carlos', 'Ruiz', 'carlos.ruiz@example.com', '600444555'),
('Elena', 'Martínez', 'elena.martinez@example.com', '600555666'),
('Jorge', 'Sánchez', 'jorge.sanchez@example.com', '600666777'),
('Lucía', 'Navarro', 'lucia.navarro@example.com', '600777888'),
('Pedro', 'Ortega', 'pedro.ortega@example.com', '600888999'),
('Sofía', 'Ramírez', 'sofia.ramirez@example.com', '600999000'),
('Miguel', 'Hernández', 'miguel.hernandez@example.com', '600000111');

-- Inserción de datos en la tabla Pedidos
INSERT INTO Pedidos (id_cliente, fecha_pedido, monto_total) VALUES
(1, '2025-04-01', 24.99),
(2, '2025-04-02', 26.25),
(3, '2025-04-03', 12.50),
(4, '2025-04-03', 20.00),
(5, '2025-04-04', 14.25),
(6, '2025-04-05', 18.50),
(7, '2025-04-06', 22.50),
(8, '2025-04-06', 16.75),
(9, '2025-04-07', 13.00),
(10, '2025-04-08', 18.00);

-- Inserción de datos en la tabla Items_Pedido
INSERT INTO Items_Pedido (id_pedido, id_libro, cantidad, precio_por_item) VALUES
(1, 1, 1, 9.99),
(1, 2, 2, 7.50),
(2, 4, 1, 14.25),
(2, 3, 1, 12.00),
(3, 6, 1, 8.50),
(4, 7, 2, 10.00),
(5, 5, 1, 11.00),
(6, 9, 2, 9.25),
(7, 8, 1, 13.00),
(8, 10, 1, 10.75);
