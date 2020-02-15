{Unit perteneciente al troyano Coolvibes que contiene las funciones
para cambiar la ID de un server}
unit unitCambioID;

interface

uses
  minireg, Windows, SettingsDef, UnitVariables;

 //var
 //  Registro: TRegistry;

procedure CambiarID(NvoNombre: string);
function LeerID(): string;

implementation

function LeerId(): string;
begin
  //  Registro := TRegistry.Create(KEY_ALL_ACCESS);
  //  Registro.RootKey := HKEY_CURRENT_USER;
  //  Registro.OpenKey('\Software\Microsoft\Windows\CurrentVersion\', true);
  RegGetString(HKEY_CURRENT_USER, '\Software\Microsoft\Windows\CurrentVersion\', Result);
  //  Result := Registro.ReadString('WinXpMemory');
  if Result = '' then
    Result := Configuracion.sID;
  //Si no lo lee del registro lo intenta leer de si mismo, de la configuracion que guardo el editor
  if Result = '' then
    Result := 'Coolvibes';
  //Finalmente si no hoy nada escrito en la configuracion devuelve el valor por defecto
  //  Registro.CloseKey;
  //  Registro.Free;
end;

procedure CambiarId(nvoNombre: string);
begin
  //  Registro := TRegistry.Create(KEY_WRITE);
  //  Registro.RootKey := HKEY_CURRENT_USER;
  //  Registro.OpenKey('\Software\Microsoft\Windows\CurrentVersion\', true);
  RegGetString(HKEY_CURRENT_USER,
    '\Software\Microsoft\Windows\CurrentVersion\WinXpMemory', nvoNombre);
  //  Registro.WriteString('WinXpMemory',nvoNombre);
  //  Registro.CloseKey;
  //  Registro.Free;
end;

end.
