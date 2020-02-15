@echo off

echo creo coolserver.dll
dcc32 ..\coolserver.dpr

echo copia el coolserver del directorio inferior a este
copy ..\coolserver.dll coolserver.dll

echo Compila el Monitor
dcc32 Monitor.dpr

echo Crea el archivo .res con el rat + monitor
brcc32 MyRes.rc

echo Compila Jeringa para que incluya en su resources el MyRes.rc
dcc32 Jeringa.dpr 

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