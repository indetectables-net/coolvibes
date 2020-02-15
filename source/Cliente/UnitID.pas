unit UnitID;

interface

uses
  Classes, Controls, Forms,
  StdCtrls, Buttons, IdTCPServer, unitMain;

type
  TFormID = class(TForm)
    Label1: TLabel;
    EditID: TEdit;
    CmbIDAceptar: TSpeedButton;
    cmbIdCancelar: TSpeedButton;
    procedure cmbIdCancelarClick(Sender: TObject);
    procedure CmbIDAceptarClick(Sender: TObject);
    procedure EditIDKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormID: TFormID;

implementation

{$R *.dfm}

procedure TFormID.cmbIdCancelarClick(Sender: TObject);
begin
  FormID.Close;
end;

procedure TFormID.CmbIDAceptarClick(Sender: TObject);
var
  AThread: TIdPeerThread;
  Antiguo: string;
begin
  Antiguo := FormMain.ListViewConexiones.Selected.Caption;
  Delete(antiguo, 1, Pos('_', antiguo) - 1); //Dejamos el identificador
  //Buscamos la conexión que pertenece a ese item
  AThread := TidPeerThread(FormMain.ListViewConexiones.Selected.SubItems.Objects[0]);
  FormMain.ListViewConexiones.Selected.Caption := EditID.Text + Antiguo;
  Athread.Connection.Writeln('CAMBIOID' + EditID.Text);
  //Cambiar nombre al directorio de las descargas....???
  FormID.Close;
end;

procedure TFormID.EditIDKeyPress(Sender: TObject; var Key: Char);
begin
  if (key = '_') then key := #0;
end;

end.
