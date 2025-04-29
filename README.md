# Proyecto Práctico: Administración y Automatización de una Base de Datos para "Libros del Rincón"

## 📚 Descripción General

Este proyecto consiste en diseñar, implementar y automatizar tareas esenciales de administración de bases de datos para la librería online ficticia **"Libros del Rincón"**. El objetivo es demostrar conocimientos de diseño relacional, gestión de usuarios, scripting, automatización, optimización de consultas y planificación de tareas administrativas utilizando **MySQL** como SGBD.

## 🛠️ Tecnologías y Herramientas

- **SGBD**: MySQL
- **Editor**: Visual Studio Code
- **Control de versiones**: Git + GitHub
- **Documentación**: Markdown (con exportación a PDF)
- **Extensiones VSCode**:
  - Markdown PDF
  - Markdown Preview Enhanced
  - Prettier
  - Paste Image
  - Markdown All in One

## 📁 Estructura del Proyecto

```
proyecto-db-libros-rincon/
├── .vscode/
│   └── settings.json
├── docs/
│   ├── informe_final.md
│   ├── informe_final.pdf
│   └── images/
├── scripts/
│   └── mysql/
│       ├── 01_crear_bd_y_tablas.sql
│       ├── 02_usuarios_y_permisos.sql
│       ├── 03_insertar_datos.sql
│       ├── 04_script_automatizacion.sql
│       └── 05_consulta_optimizada.sql
├── README.md
└── .gitignore
```

## 🧱 Diseño de la Base de Datos (UF1468)

Se diseñó el siguiente esquema relacional:

- **Libros** (`id_libro`, `titulo`, `autor`, `genero`, `precio`, `cantidad_en_stock`)
- **Clientes** (`id_cliente`, `nombre`, `apellido`, `email`, `telefono`)
- **Pedidos** (`id_pedido`, `id_cliente`, `fecha_pedido`, `monto_total`)
- **Items_Pedido** (`id_pedido`, `id_libro`, `cantidad`, `precio_por_item`)

### 🔑 Justificación de diseño:

- Se utilizaron claves primarias autoincrementales.
- Relaciones:
  - `Pedidos` → `Clientes` (1:N)
  - `Items_Pedido` → `Pedidos`, `Libros` (N:M descompuesta)
- Tipos de datos adecuados (INT, VARCHAR, DATE, DECIMAL).

## 👤 Gestión de Usuarios y Permisos (UF1469)

Se crearon los siguientes roles:

- **Gerente**: Acceso total a todas las tablas.
- **AgenteVentas**: Acceso de lectura a `Libros`, `Clientes`, `Pedidos` y escritura solo en `Pedidos`.

Los scripts correspondientes están en `02_usuarios_y_permisos.sql`.

## 🧪 Inserción de Datos de Ejemplo (UF1469)

Cada tabla fue poblada con al menos 10 registros significativos.
Consulta el script `03_insertar_datos.sql`.

## 🤖 Automatización (UF1470)

Se implementó un **trigger** para la gestión de inventario:

- Al insertar un nuevo ítem en `Items_Pedido`, se actualiza automáticamente `cantidad_en_stock` en `Libros`.

También se incluye un script alternativo para **respaldo de la base de datos** con `mysqldump`, y una estructura para informes diarios por género.

Scripts disponibles en `04_script_automatizacion.sql`.

## ⚙️ Optimización de Consultas (UF1470)

Consulta compleja:

> Lista todos los clientes que han comprado libros del género "Ciencia Ficción" en el último mes.

- Se usó `EXPLAIN` para analizar rendimiento.
- Se recomendó un índice sobre `Libros.genero` y `Pedidos.fecha_pedido`.

Consulta y análisis en `05_consulta_optimizada.sql`.

## ⏲️ Planificación de Tareas Administrativas (UF1468)

- **Windows**: Se propone usar el **Programador de Tareas** para ejecutar un script de respaldo (`.bat` con `mysqldump`) diariamente.
- **Linux (opcional)**: Se incluye ejemplo con `cron` como alternativa secundaria.

## 📄 Documentación

El informe completo se encuentra en:

- `docs/informe_final.md` (editable)
- `docs/informe_final.pdf` (exportado)

## 🔗 Repositorio

Este proyecto está disponible en GitHub: [https://github.com/tuusuario/proyecto-db-libros-rincon](https://github.com/tuusuario/proyecto-db-libros-rincon)

---

> Desarrollado como práctica de UF1468, UF1469 y UF1470.
