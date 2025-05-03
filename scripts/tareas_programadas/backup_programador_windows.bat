@echo off
REM Obtener la fecha en formato AAAA-MM-DD (compatible con nombres de archivo)
for /f "tokens=1-3 delims=/- " %%a in ("%date%") do (
    set yyyy=%%c
    set mm=%%b
    set dd=%%a
)

REM Formatear la fecha
set fecha=%yyyy%-%mm%-%dd%

REM Ejecutar el script SQL y guardar la salida con la fecha incluida
mysql -u TU_USUARIO -pTU_CONTRASEÑA NOMBRE_BASE_DATOS < informe_ventas_genero.sql > resultado_%fecha%.txt
