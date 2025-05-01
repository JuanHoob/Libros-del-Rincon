mysql -u root -pTuContraseña libros_rincon < "%~dp0\..\scripts\mysql\06_informe_diario_ventas.sql" > "%~dp0\informe_ventas_%FECHA%.csv"
