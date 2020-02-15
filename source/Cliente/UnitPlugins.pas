unit UnitPlugins;

interface

uses
  Windows, Classes;
  
  type
    TPlugin = class(TObject)
  public
    H : THandle;
    Autor : string;
    PluginName : string;
    Path : string;
    Con : integer;
    Subido : boolean;
    //Funciones de la dll
    dAutor : function: string;stdcall;
    dPluginName : function: string;stdcall;
    dConectar : function(pU:string;pConID: integer):pointer;stdcall;
    dPluginClick : procedure(dForm:pointer);stdcall;
    dRecData : procedure(Form:Pointer;data:string);stdcall;
    dDesconectado : procedure(Form:Pointer);stdcall;

    dForm : Pointer;
    constructor Create(H:THandle); overload;
    procedure   Conectar(pU:string;pConID: integer);
    procedure   PluginClick();
    procedure   RecData(dData:string);
    procedure   Desconectado();
  end;

implementation

constructor TPlugin.Create(H:THandle);
begin
  if H = 0 then exit;
  @dAutor        := GetProcAddress(H, 'Autor');
  @dPluginName   := GetProcAddress(H, 'PluginName');
  @dConectar     := GetProcAddress(H, 'Conectar');
  @dPluginClick  := GetProcAddress(H, 'PluginClick');
  @dRecData      := GetProcAddress(H, 'RecData');
  @dDesconectado := GetProcAddress(H, 'Desconectado');
  
  if @dAutor <> nil then
    Autor      := dAutor();
  if @dPluginName <> nil then
    PluginName := dPluginName();
end;

procedure TPlugin.Conectar(pU:string;pConID: integer);
begin
  dForm := dConectar(pU,pConID);
end;

procedure TPlugin.PluginClick(); //Click en el plugin
begin
  dPluginClick(dForm);
end;

procedure TPlugin.RecData(dData:string);  //Recibir Datos
begin
  dRecData(dForm, dData);
end;

procedure TPlugin.Desconectado();  //Recibir Datos
begin
  dDesconectado(dForm);
end;

begin

end.
