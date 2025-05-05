````markdown
<!-- Portada -->
<div class="cover">
  # Informe del Proyecto Práctico  
  ## Administración y Automatización de Base de Datos  
  ### “Libros del Rincón”  

  **Autor:** [Tu Nombre]  
  **Asignatura:** UF1468 / UF1469 / UF1470  
  **Fecha de entrega:** [DD/MM/AAAA]  

  ![Logo Librería](./docs/capturas/logo_libros_rincon.png){width=200px}
</div>

<div class="page-break"></div>

# Índice

1. [Introducción](#introducción)  
2. [Diseño de la Base de Datos (UF1468)](#diseño-de-la-base-de-datos-uf1468)  
3. [Creación de la Base de Datos y Gestión de Usuarios (UF1469)](#creación-de-la-base-de-datos-y-gestión-de-usuarios-uf1469)  
4. [Introducción de Datos (UF1469)](#introducción-de-datos-uf1469)  
5. [Automatización de Tareas (UF1470)](#automatización-de-tareas-uf1470)  
6. [Optimización de Consultas (UF1470)](#optimización-de-consultas-uf1470)  
7. [Planificación de Backups (UF1468)](#planificación-de-backups-uf1468)  
8. [Script Python para creación de pedidos](#script-python-para-creación-de-pedidos)  
9. [Dificultades y Conclusiones](#dificultades-y-conclusiones)  
10. [Anexos](#anexos)



## Introducción
Este documento recoge el desarrollo completo del proyecto práctico para la pequeña librería online “Libros del Rincón”. Incluye diseño relacional, creación de usuarios, inserción de datos, scripting de automatización, optimización de consultas y planificación de tareas administrativas.



## Diseño de la Base de Datos (UF1468)
Se eligió **MySQL** por su robustez y capacidad multiusuario. El esquema relacional consta de las tablas `Libros`, `Clientes`, `Pedidos` e `Items_Pedido`.

**Script de creación:** `scripts/mysql/01_creacion_bd.sql`
```sql
CREATE TABLE Libros (
  id_libro INT PRIMARY KEY AUTO_INCREMENT,
  titulo VARCHAR(255),
  autor VARCHAR(255),
  genero VARCHAR(100),
  precio DECIMAL(6,2),
  cantidad_en_stock INT
);
-- (Definición de las demás tablas sigue el mismo criterio)
````

**Justificación de diseño:**

* Claves primarias autoincrementales para unicidad.
* Claves foráneas para asegurar integridad.
* Tipos de datos adecuados (INT, VARCHAR, DATE, DECIMAL).

**Captura de creación de tablas:**
![Creación BD](./capturas/01_creacion_bd.png)

<div class="page-break"></div>

## Creación de la Base de Datos y Gestión de Usuarios (UF1469)

Se definieron dos roles:

* **gerente**: permisos totales.
* **agenteventas**: lectura de tablas principales y escritura en `Pedidos`.

**Script de permisos:** `scripts/mysql/02_usuarios_y_permisos.sql`

```sql
CREATE USER 'gerente'@'localhost' IDENTIFIED BY 'Gerente123';
GRANT ALL PRIVILEGES ON libros_rincon.* TO 'gerente'@'localhost';
CREATE USER 'agenteventas'@'localhost' IDENTIFIED BY 'Ventas123';
GRANT SELECT ON libros_rincon.Libros TO 'agenteventas'@'localhost';
GRANT SELECT ON libros_rincon.Clientes TO 'agenteventas'@'localhost';
GRANT SELECT, INSERT ON libros_rincon.Pedidos TO 'agenteventas'@'localhost';
```

**Captura de gestión de usuarios:**
![Usuarios y permisos](./capturas/02_usuarios_y_permisos.png)

<div class="page-break"></div>

## Introducción de Datos (UF1469)

Se poblaron las tablas con datos de prueba:

**Script de ejemplo:** `scripts/mysql/03_datos_ejemplo.sql`

```sql
INSERT INTO Libros (titulo, autor, genero, precio, cantidad_en_stock) VALUES
('1984','George Orwell','Ciencia Ficción',9.99,20), ...;
```

**Capturas de la ingesta:**

* Clientes  ![Clientes](./capturas/03_ingesta_datos_clientes.png)
* Libros    ![Libros](./capturas/03_ingesta_libros.png)
* Pedidos  ![Pedidos](./capturas/03_ingesta_pedidos.png)
* Items\_Pedido  ![Items Pedido](./capturas/03_ingesta_items_pedidos.png)

<div class="page-break"></div>

## Automatización de Tareas (UF1470)

### Trigger de stock

Actualiza automáticamente `cantidad_en_stock` al insertar un nuevo item:

**Script:** `scripts/mysql/04_trigger_actualizar_stock.sql`

```sql
DELIMITER //
CREATE TRIGGER actualizar_stock AFTER INSERT ON Items_Pedido
FOR EACH ROW BEGIN
  UPDATE Libros
    SET cantidad_en_stock = cantidad_en_stock - NEW.cantidad
    WHERE id_libro = NEW.id_libro;
END;//
DELIMITER ;
```

**Capturas:**

* Inserción  ![Trigger insertado](./capturas/comprobacion_trigger_insertado.png)
* Stock     ![Stock actualizado](./capturas/comprobacion_trigger_cantidad_stock.png)

### Informe diario de ventas (Windows)

Ejecuta diariamente un script `.bat`:

**Script:** `scripts/tareas_programadas/06_informe_ventas_diario.bat`

```bat
@echo off
for /f "tokens=2 delims==" %%i in ('wmic os get localdatetime /value') do set dt=%%i
set fecha=!dt:~0,4!-!dt:~4,2!-!dt:~6,2!
mysql -u TU_USUARIO -pTU_CONTRASEÑA libros_rincon < scripts/mysql/06_informe_diario_ventas.sql > ventas_%fecha%.txt
```

**Consulta SQL:** `scripts/mysql/06_informe_diario_ventas.sql`

```sql
SELECT CURDATE() AS fecha_informe, l.genero, SUM(ip.cantidad*ip.precio_por_item) AS total_ventas
FROM Items_Pedido ip
JOIN Libros l ON ip.id_libro=l.id_libro
JOIN Pedidos p ON ip.id_pedido=p.id_pedido
WHERE p.fecha_pedido=CURDATE()
GROUP BY l.genero;
```

**Capturas Windows:**

* Tarea  ![Scheduler](./capturas/creacion_tarea_programada_informe_ventas_win.PNG)
* Resultado  ![Resultado informe](./capturas/resultado_informe_tareawin.png)

<div class="page-break"></div>

### Informe diario de ventas (Linux - cron)

**Script bash:** `scripts/tareas_programadas/07_cron_informe_ventas.sh`

```bash
#!/bin/bash
fecha=$(date +"%F")
mysql -u TU_USUARIO -pTU_CONTRASEÑA libros_rincon < scripts/mysql/06_informe_diario_ventas.sql > ventas_$fecha.txt
```

**Crontab:**

```cron
0 8 * * * /ruta/a/07_cron_informe_ventas.sh
```

<div class="page-break"></div>

### Script Python para creación de pedidos

Permite insertar pedidos desde backend:

**Script:** `scripts/python/crear_pedido.py`

```python
import mysql.connector

def crear_pedido(id_cliente, id_libro, cantidad):
    db = mysql.connector.connect(user='TU_USUARIO', password='TU_CONTRASEÑA', host='localhost', database='libros_rincon')
    cursor = db.cursor()
    cursor.execute("INSERT INTO Pedidos (id_cliente, fecha_pedido, monto_total) VALUES (%s, CURDATE(), %s)",
                   (id_cliente, cantidad*obtener_precio(id_libro, cursor)))
    pedido_id = cursor.lastrowid
    precio = obtener_precio(id_libro, cursor)
    cursor.execute("INSERT INTO Items_Pedido VALUES (%s,%s,%s,%s)",
                   (pedido_id, id_libro, cantidad, precio))
    db.commit()
    cursor.close()
    db.close()


def obtener_precio(id_libro, cursor):
    cursor.execute("SELECT precio FROM Libros WHERE id_libro=%s", (id_libro,))
    return cursor.fetchone()[0]
```

<div class="page-break"></div>

## Optimización de Consultas (UF1470)

Consulta clientes de Ciencia Ficción último mes y creación de índices:

**Script:** `scripts/mysql/05_consulta_optimizacion.sql`

```sql
EXPLAIN SELECT DISTINCT c.nombre, c.apellido
FROM Clientes c
JOIN Pedidos p ON c.id_cliente=p.id_cliente
JOIN Items_Pedido ip ON p.id_pedido=ip.id_pedido
JOIN Libros l ON ip.id_libro=l.id_libro
WHERE l.genero='Ciencia Ficción' AND p.fecha_pedido>=DATE_SUB(CURDATE(), INTERVAL 1 MONTH);

CREATE INDEX idx_genero ON Libros(genero);
CREATE INDEX idx_fecha ON Pedidos(fecha_pedido);
```

**Captura:**
![EXPLAIN](./capturas/optimizacion_explain_index.png)

<div class="page-break"></div>

## Planificación de Backups (UF1468)

### Windows

```bat
@echo off
set fecha=%date:~6,4%-%date:~3,2%-%date:~0,2%
mysqldump -u TU_USUARIO -pTU_CONTRASEÑA libros_rincon > backup_%fecha%.sql
```

### Linux

```cron
0 2 * * * mysqldump -u TU_USUARIO -pTU_CONTRASEÑA libros_rincon > /ruta/backup_$(date +\%F).sql
```

**Capturas:**

* Backup Win  ![Backup Win](./capturas/creacionruta_carpeta_archivos_tareaprogramada_win.PNG)
* Backup Cron ![Backup Cron](./capturas/cron_backup.png)

<div class="page-break"></div>

## Dificultades y Conclusiones

1. Formateo de fecha en Windows para nombres de archivo.
2. Integridad referencial en inserciones manuales.
3. Configuración de CSS para exportación PDF.

El resultado es una solución completa, automática y bien documentada.

<div class="page-break"></div>

## Anexos

* Estructura de carpetas y scripts completos.
* Capturas en `docs/capturas`.
* Repositorio: [https://github.com/tu\_usuario/LIBROS-DEL-RINCON](https://github.com/tu_usuario/LIBROS-DEL-RINCON)

```
```
