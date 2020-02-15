unit UnitEstadisticasConexiones;

interface

uses
  SysUtils, Classes, Controls, Forms,
  ComCtrls, StdCtrls, ExtCtrls, gnugettext,
  Buttons, ImgList;

type
  TFormEstadisticasConexiones = class(TForm)
    Panel1: TPanel;
    GroupBoxOpciones: TGroupBox;
    ListViewEstadisticas: TListView;
    ImageList: TImageList;
    LabelNConexiones: TLabel;
    SpeedButton1: TSpeedButton;
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure NuevoEvento(tipo: Integer; itemc: tlistitem);
  end;

var
  FormEstadisticasConexiones: TFormEstadisticasConexiones;

implementation

{$R *.dfm}

procedure TFormEstadisticasConexiones.NuevoEvento(tipo: Integer; itemc: tlistitem);
var
  Item: TListItem;
  Eventos: array[0..10] of string;
begin
  Eventos[0] := _('Nueva Conexión');
  Eventos[1] := _('Desconexión');
  Item := ListViewEstadisticas.Items.Add;
  Item.ImageIndex := Tipo;
  item.Caption := Eventos[Tipo];
  item.SubItems.Add(Itemc.SubItems[9]);
  item.SubItems.Add(FormatDateTime('hh:mm:ss', now));
  item.SubItems.Add(Itemc.SubItems[0]);
  item.SubItems.Add(Itemc.Caption);
end;

procedure TFormEstadisticasConexiones.SpeedButton1Click(Sender: TObject);
begin
  Self.Close;
end;

end.
