library MensajesC;

uses
  windows,
  forms,
  MainUnit in 'MainUnit.pas'{FormMain};

{$R *.res}

function Autor: string; stdcall;
begin
  result := 'Coolvibes Team';
end;

function PluginName: string; stdcall;
begin
  result := 'Mensajes';
end;

function Conectar(pU:string;pConID: integer):pointer; stdcall; 
var
  frm: TFormMain;
begin
  frm := TFormMain.Create(nil);
  frm.Caption := 'Mensajes - '+pU;    //Identificador del pc remoto
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

exports Autor, Conectar, RecData, Desconectado, PluginName;
begin
end.
