unit UnitEstadisticasConexiones;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, ImgList, Menus, gnugettext;

type
  TFormEstadisticasConexiones = class(TForm)
    Panel1: TPanel;
    GroupBoxOpciones: TGroupBox;
    ListViewEstadisticas: TListView;
    ImageList: TImageList;
    LabelNConexiones: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
    Procedure NuevoEvento(tipo:integer;itemc:tlistitem);
  end;

var
  FormEstadisticasConexiones: TFormEstadisticasConexiones;

implementation

{$R *.dfm}
  Procedure TFormEstadisticasConexiones.NuevoEvento(tipo:integer;itemc:tlistitem);
  var
    Item : TListItem;
    Eventos : array[0..10] of string;
  begin
    Eventos[0] := _('Nueva Conexión');
    Eventos[1] := _('Desconexión');
    Item := ListViewEstadisticas.Items.Add;
    Item.ImageIndex := Tipo;
    item.Caption := Eventos[Tipo];
    item.SubItems.Add(Itemc.SubItems[9]);
    item.SubItems.Add(formatdatetime('hh:mm:ss',now));
    item.SubItems.Add(Itemc.SubItems[0]);     
    item.SubItems.Add(Itemc.caption);
  end;
end.
