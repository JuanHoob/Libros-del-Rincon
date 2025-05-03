@echo off
REM Ejecutar informe de ventas diario
mysql -u tu_usuario -pTuContraseña libros_rincon < "C:\ruta\completa\informe_ventas_genero.sql" > "C:\ruta\completa\resultado_informe.txt"

