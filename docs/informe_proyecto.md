# Informe Final - Base de Datos Libros del Rincón

## Índice

1. [Introducción](https://chatgpt.com/c/6810a049-8ed8-8013-b063-f7b7456af58a#introduccion)
2. [Modelo Entidad-Relación](https://chatgpt.com/c/6810a049-8ed8-8013-b063-f7b7456af58a#modelo-entidad-relacion)
3. [Diseño del esquema relacional](https://chatgpt.com/c/6810a049-8ed8-8013-b063-f7b7456af58a#diseno-del-esquema-relacional)
4. [Ingesta de datos](https://chatgpt.com/c/6810a049-8ed8-8013-b063-f7b7456af58a#ingesta-de-datos)
5. [Triggers](https://chatgpt.com/c/6810a049-8ed8-8013-b063-f7b7456af58a#triggers)
6. [Consultas SQL y optimización](https://chatgpt.com/c/6810a049-8ed8-8013-b063-f7b7456af58a#consultas-sql-y-optimizacion)
7. [Capturas de pantalla](https://chatgpt.com/c/6810a049-8ed8-8013-b063-f7b7456af58a#capturas-de-pantalla)
8. [Conclusiones](https://chatgpt.com/c/6810a049-8ed8-8013-b063-f7b7456af58a#conclusiones)

## Introduccion

Este proyecto consiste en el diseño e implementación de una base de datos relacional para una librería ficticia denominada "Libros del Rincón". Se ha trabajado sobre MySQL como sistema gestor por su fiabilidad y facilidad de mantenimiento, especialmente en contextos empresariales pequeños.

## Modelo Entidad-Relacion

Se han definido las siguientes entidades: Libros, Clientes, Pedidos y una relación de descomposición entre Pedidos y Libros mediante Items_Pedido.

La imagen con el diagrama ER se encuentra en:

```
![Modelo ER](capturas/diagrama_ER_libros.png)
```

## Diseno del esquema relacional

Se ha implementado el siguiente esquema en SQL:

```sql
CREATE TABLE Libros (
    id_libro INT PRIMARY KEY AUTO_INCREMENT,
    titulo VARCHAR(255),
    autor VARCHAR(255),
    genero VARCHAR(100),
    precio DECIMAL(6,2),
    cantidad_en_stock INT
);

CREATE TABLE Clientes (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100),
    apellido VARCHAR(100),
    email VARCHAR(255),
    telefono VARCHAR(20)
);

CREATE TABLE Pedidos (
    id_pedido INT PRIMARY KEY AUTO_INCREMENT,
    id_cliente INT,
    fecha_pedido DATE,
    monto_total DECIMAL(8,2),
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente)
);

CREATE TABLE Items_Pedido (
    id_pedido INT,
    id_libro INT,
    cantidad INT,
    precio_por_item DECIMAL(6,2),
    PRIMARY KEY (id_pedido, id_libro),
    FOREIGN KEY (id_pedido) REFERENCES Pedidos(id_pedido),
    FOREIGN KEY (id_libro) REFERENCES Libros(id_libro)
);
```

Justificación de diseño:

* Claves primarias autoincrementales donde corresponde.
* Claves compuestas para relaciones N:M (en `Items_Pedido`).
* Integridad referencial garantizada mediante claves foráneas.
* Tipos de datos apropiados a cada campo.

## Ingesta de datos

Se insertaron los datos respetando las dependencias entre tablas. Se insertaron primero clientes y libros, luego pedidos y finalmente los items de pedidos.

Se tuvo en cuenta la restricción de claves ajenas para evitar errores como:

```
Cannot add or update a child row: a foreign key constraint fails...
```

## Triggers

Se implementó un trigger para actualizar el stock cada vez que se inserta un item en un pedido:

```sql
DELIMITER //
CREATE TRIGGER items_pedido_actualizar_stock
AFTER INSERT ON Items_Pedido
FOR EACH ROW
BEGIN
  UPDATE Libros
  SET cantidad_en_stock = cantidad_en_stock - NEW.cantidad
  WHERE id_libro = NEW.id_libro;
END;//
DELIMITER ;
```

Se comprobó su funcionamiento insertando nuevos registros en Items_Pedido. Se observó que el campo `cantidad_en_stock` se actualizaba correctamente.

Captura del trigger:

```
![Trigger funcionamiento](capturas/trigger_actualizar_stock.png)
```

## Consultas SQL y optimizacion

Consulta para listar los clientes que compraron libros de ciencia ficción en el último mes:

```sql
SELECT DISTINCT c.nombre, c.apellido
FROM Clientes c
JOIN Pedidos p ON c.id_cliente = p.id_cliente
JOIN Items_Pedido ip ON p.id_pedido = ip.id_pedido
JOIN Libros l ON ip.id_libro = l.id_libro
WHERE l.genero = 'Ciencia Ficción'
  AND p.fecha_pedido >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH);
```

Para optimizarla se crearon los siguientes índices:

```sql
CREATE INDEX idx_genero ON Libros(genero);
CREATE INDEX idx_fecha ON Pedidos(fecha_pedido);
```

## Capturas de pantalla

### Creación de tablas

```
![Tablas creadas](capturas/creacion_tablas.png)
```

### Ingesta de datos

```
![Datos insertados](capturas/ingesta_datos.png)
```

### Trigger funcionando

```
![Trigger activo](capturas/trigger_funciona.png)
```

### Error por duplicación o claves ajenas

```
![Error clave ajena](capturas/error_clave_extranjera.png)
![Error duplicada](capturas/error_clave_primaria.png)
```

### Consulta optimizada

```
![Consulta optimizada](capturas/consulta_idx_genero_fecha.png)
```

## Conclusiones

El desarrollo del modelo relacional, su implementación y pruebas permiten validar el funcionamiento correcto de las restricciones de integridad, triggers, y consultas optimizadas. MySQL fue una elección adecuada para asegurar la consistencia de datos y facilitar el trabajo futuro de ampliación del sistema.
