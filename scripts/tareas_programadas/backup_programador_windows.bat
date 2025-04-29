:: Script para usar en el Programador de Tareas de Windows
:: Ejecuta backup de la base de datos

@echo off
set FECHA=%DATE:~6,4%-%DATE:~3,2%-%DATE:~0,2%
set HORA=%TIME:~0,2%%TIME:~3,2%
mysqldump -u root -pTuPassword libros_rincon > C:\backups\libros_rincon_%FECHA%_%HORA%.sql
