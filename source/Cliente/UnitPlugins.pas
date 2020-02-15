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
    //Funciones de la dll
    dAutor : function: string;stdcall;
    dPluginName : function: string;stdcall;
    dConectar : function(pU:string;pConID,pID : integer):pointer;stdcall;
    dPluginClick : procedure(dForm:pointer);stdcall;
    dRecData : procedure(Form:Pointer;data:string);stdcall;

    dForm : Pointer;
    constructor Create(H:THandle); overload;
    procedure   Conectar(pU:string;pConID,pID: integer);
    procedure   PluginClick();
    procedure   RecData(dData:string);
  end;

implementation

constructor TPlugin.Create(H:THandle);
begin
  @dAutor       := GetProcAddress(H, 'Autor');
  @dPluginName  := GetProcAddress(H, 'PluginName');
  @dConectar    := GetProcAddress(H, 'Conectar');
  @dPluginClick := GetProcAddress(H, 'PluginClick');
  @dRecData     := GetProcAddress(H, 'RecData');
  if @dAutor <> nil then
    Autor      := dAutor();
  if @dPluginName <> nil then
    PluginName := dPluginName();
end;

procedure TPlugin.Conectar(pU:string;pConID,pID: integer);
begin
  dForm := dConectar(pU,pConID,pID);
end;

procedure TPlugin.PluginClick(); //Click en el plugin
begin
  dPluginClick(dForm);
end;

procedure TPlugin.RecData(dData:string);  //Recibir Datos
begin
  dRecData(dForm, dData);
end;

begin

end.
