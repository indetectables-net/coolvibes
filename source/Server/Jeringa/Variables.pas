unit Variables;

interface

uses
 Windows, SettingsDef;

var
  MCompartida: THandle;       //Para escribir la configuracion a memoria
  MCompartida2: THandle;
  MCompartida3: THandle;
  ConfigCompartida : PConfigCompartida;
  ConfigLeida: PSettings;    //Para leer la configuracion
  Configuracion:   TSettings;
  StartInfo: TStartupInfo;
  ProcInfo:  TProcessInformation;
implementation

end.
