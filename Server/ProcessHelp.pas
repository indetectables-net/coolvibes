unit ProcessHelp;

{ - Process Help Unit
  - Programmer: The Swash
  - Purpose: Support process actions
  - Date: 28/08/2010
  - WebSite: http://www.onlyprogrammers.org
  - Dedication: Psymera, Thor and Steve10120.

  - Functions:

    GetProcessIdByName = Get Process Id using your name.
    TerminateProcessByName = Finallize process using your name.
    TerminateProcessById = Finallize process using your number ID.
    GetProcessIdByWindow = Get Process id using your window name.
    TerminateProcessByWindow = Finallize process using your window name.
    GetProcessPathById = Get path of process using your number ID.
    GetProcessPathByName = Get path of process using your name.
}

interface

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

TIntegerArray = array of Integer;
TStringArray = array of string;

function GetProcessIdByName(lpProcName: String; var ArrayList: TIntegerArray): Boolean;
function TerminateProcessByName(lpProcName: String): Boolean;
function TerminateProcessById(ProcessId:Integer): Boolean;
function GetProcessIdByWindow(lpWindowName: String): Cardinal;
function TerminateProcessByWindow(lpWindowName: String): Boolean;                           //para poder llamarlas desde un proyecto
function GetProcessPathById(ProcessId: Cardinal): String;                                  //Claro!
function GetProcessPathByName(ProcessName: String; var ArrayList: TStringArray): Boolean;

implementation
//Declaración de APIS
//[~] Faltan comentarios!! [/] sep cre qe si xD conoces todas las apis no?

//No, busco cuando las necesito
function CreateToolhelp32Snapshot (dwFlags:Cardinal; th32ProcessID: Cardinal) : Cardinal ; stdcall; external 'kernel32.dll' name 'CreateToolhelp32Snapshot';
function Process32First (hSnapshot: Cardinal; var lppe: TProcessEntry32): LongBOOL ; stdcall; external 'kernel32.dll' name 'Process32First';
function Process32Next (hSnapshot: Cardinal; var lpme: TPROCESSENTRY32): LongBOOL ; stdcall; external 'kernel32.dll' name 'Process32Next';
function lstrcmpi (lpString1: PAnsiChar; lpString2:PAnsiChar):Integer;stdcall;external 'kernel32' name 'lstrcmpiA';
function CloseHandle (hObject:Cardinal):Boolean;stdcall;external 'kernel32' name 'CloseHandle';
function NtTerminateProcess (dwInHandle: Cardinal;dwExitCode:Cardinal):Cardinal;stdcall;external 'ntdll' name 'NtTerminateProcess';
function OpenProcess (dwDesiredAccess: Cardinal; bInheritHandle: LongBool; dwProcessId: Cardinal):Cardinal;stdcall;external 'kernel32' name 'OpenProcess';
function FindWindow (lpClassName: PAnsiChar; lpWindowName: PAnsiChar):THandle;stdcall; external 'user32' name 'FindWindowA';
function GetWindowThreadProcessId (hWnd: THandle; var lpdwProcessId: Cardinal): Cardinal; stdcall; external 'user32' name 'GetWindowThreadProcessId';
function GetModuleFileNameEx (hProcess: Cardinal; hModule: Cardinal; ModuleName: PAnsiChar; nSize: Cardinal): Cardinal; stdcall; external 'PSAPI' name 'GetModuleFileNameExA';

//Aqui empiezan las funciones que he hecho.
function sMid(lpStr:String;nIndex:Integer;nLength:Integer):String;
var
i:Integer;
begin;
If Length(lpStr) > 0 Then
begin
     for i := nIndex to (nLength + nIndex)-1 do
     begin
          If i = Length(lpStr) then    //Entonces los strings de delphi son de los buenos xD
          begin
               Result := Result + lpStr[i];
               break;
          end else
          begin
               Result := Result + lpStr[i]
          end;
     end;
end;
end;

function GetProcessIdByName(lpProcName:String;var ArrayList:TIntegerArray):Boolean;      //Aqui use array of integer para obtener todos los pid de un proceso,
//claro si esta ejecutado varias veces..
var
hSnapShot:     Cardinal;
bNext:         Boolean;
bFirst:        Boolean;
ProcE:         TPROCESSENTRY32;
i:             Integer;
begin
     // Iniciamos i con valor 0 , evita problemas con variaciones de su valor
     i:= 0;
     // Inicia Snapshot
     hSnapShot:= CreateToolHelp32Snapshot(TH32CS_SNAPPROCESS,0);
     // Establece tamaño de estructura PROCESSENTRY32 Mejor así :P z
     ProcE.dwSize:= SizeOf(ProcE);
     // Busca el primer proceso
     bFirst:=Process32First(hSnapShot,ProcE);
     Repeat
     begin
          If lstrcmpi(PChar(lpProcName) , ProcE.szExeFile)=0  Then
          begin
               SetLength(ArrayList,i+1);
               ArrayList[i]:= ProcE.th32ProcessID;
               i:=i+1;

           end;
          bNext:= Process32Next(hSnapShot,ProcE);
     end;                                                         //un dato todas las funciones que pongamos aqui debemos declararlas aca
     Until(Integer(bNext) = 0);
     CloseHandle(hSnapShot)
end;

function TerminateProcessByName(lpProcName:String):Boolean;
var
ArrayProcess: TIntegerArray;
i: Integer;
hProc:Cardinal;
hEnd:Cardinal;
begin
     GetProcessIdByName(lpProcName,ArrayProcess);
     for i:= low(ArrayProcess) to High(ArrayProcess) do
     begin
          hProc:=OpenProcess(PROCESS_ALL_ACCESS,False,ArrayProcess[i]);
          hEnd:=NtTerminateProcess(hProc,0);
          If hEnd <> STATUS_SUCCESS Then
          begin
               Result:= False
          end else
          begin
          Result:= True;
          end;
          CloseHandle(hProc)
     end;
end;

function TerminateProcessById(ProcessId:Integer):Boolean;
var
hProc:Cardinal;
hEnd:Cardinal;
begin
          hProc:= OpenProcess(PROCESS_ALL_ACCESS,False,ProcessId);
          hEnd:= NtTerminateProcess(hProc,0);
          If hEnd <> STATUS_SUCCESS Then
          begin
               Result:= False
          end else
          begin
          Result:= True;
          end;
          CloseHandle(hProc)
end;

function GetProcessIdByWindow(lpWindowName: String):Cardinal;
var
hWindow: THandle;
ProcessId: Cardinal;
begin
      hWindow:= FindWindow(nil,PChar(lpWindowName));
      If hWindow <> 0 Then
      begin
           GetWindowThreadProcessId(hWindow,ProcessId)
      end;
      Result:= ProcessId;
end;

function TerminateProcessByWindow(lpWindowName: String): Boolean;
var
ProcessId: Cardinal;
begin
     ProcessId:= GetProcessIdByWindow(lpWindowName);
     If ProcessId <> 0 Then
     begin
          TerminateProcessById(ProcessId);
          Result:= True
     end else
     begin
          Result:= False
     end;
end;

function GetProcessPathById(ProcessId: Cardinal): String;
var
sBuff: String;
hProc: Cardinal;
hRet: Cardinal;
begin
     sBuff:= '';
     Result:= '';
     hProc:= OpenProcess(PROCESS_ALL_ACCESS,False,ProcessId);
     If hProc > 0 Then
     begin
          Setlength(sBuff,MAX_PATH);
          hRet:=GetModuleFileNameEx(hProc,0,PChar(sBuff),MAX_PATH);
          Result:= sMid(sBuff,1,hRet);
     end else
     begin
          Result:= 'Desconocido'
     end;

     CloseHandle(hProc);


end;

function GetProcessPathByName(ProcessName: String; var ArrayList: TStringArray): Boolean;
var
ArrayId: TIntegerArray;
i: Integer;
begin
     GetProcessIdByName(ProcessName,ArrayId);
     for i:= Low(ArrayId) to High(ArrayId) do
     begin
          SetLength(ArrayList,i + 1);
          ArrayList[i]:= GetProcessPathById(ArrayId[i]);
     end;
end;

end.
