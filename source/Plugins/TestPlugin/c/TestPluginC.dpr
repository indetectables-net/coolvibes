library TestPluginC;


uses
  windows,
  forms,
  MainUnit in 'MainUnit.pas'{FormMain};

{$R *.res}


function Autor: string; stdcall;
begin
  result := 'Autor';
end;

function PluginName: string; stdcall;
begin
  result := 'TestPlugin v1.0';
end;

function Conectar(pU:string;pConID,pID : integer):pointer; stdcall;
var
  frm: TFormMain;
begin
  frm := TFormMain.Create(nil);
  frm.Caption := pU;
  frm.ConID := pConID;
  frm.PID := pID;
  frm.Show;
  Result := Pointer(frm);
end;

procedure PluginClick(Form:Pointer); stdcall;
begin
  if assigned(Form) then
    TFormMain(Form).show;
end;

procedure RecData(Form:Pointer;data:string);stdcall;
begin
  if assigned(Form) then
    TFormMain(Form).Recdata(data);
end;

exports Autor, Conectar, PluginClick, RecData, PluginName;
begin
end.
