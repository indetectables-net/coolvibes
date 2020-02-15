unit UnitColumnasManager;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ComCtrls, Menus;

type
  TFormColumnasManager = class(TForm)
    ListViewColumnas: TListView;
    SpeedButtonCerrar: TSpeedButton;
    PopupMenuColumnas: TPopupMenu;
    Subir1: TMenuItem;
    Bajar1: TMenuItem;
    Eliminar1: TMenuItem;
    SpeedButtonPredeterminado: TSpeedButton;
    procedure SpeedButtonCerrarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure PopupMenuColumnasPopup(Sender: TObject);
    procedure Subir1Click(Sender: TObject);
    procedure Bajar1Click(Sender: TObject);
    procedure Eliminar1Click(Sender: TObject);
    procedure ActualizarColumnas();
    procedure SpeedButtonPredeterminadoClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormColumnasManager: TFormColumnasManager;

implementation

uses UnitMain;

{$R *.dfm}

procedure TFormColumnasManager.SpeedButtonCerrarClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TFormColumnasManager.FormShow(Sender: TObject);
var
  i:integer;
  item:TListItem;
begin
  ListViewColumnas.Clear;
  for i:= 0 to FormMain.listviewconexiones.columns.count-1 do
  begin
    item := ListViewColumnas.Items.Add;
    item.Caption := inttostr(i);
    item.SubItems.Add(FormMain.listviewconexiones.Column[i].Caption);
  end;
end;

procedure TFormColumnasManager.PopupMenuColumnasPopup(Sender: TObject);
var
i:integer;
begin
  if Listviewcolumnas.Selected = nil then
  begin
     for i:= 0 to Popupmenucolumnas.Items.count-1 do
      Popupmenucolumnas.Items[i].Enabled := false;
  end
  else
  begin
    for i:= 0 to Popupmenucolumnas.Items.count-1 do
      Popupmenucolumnas.Items[i].Enabled := true;
  end;
end;

procedure TFormColumnasManager.Subir1Click(Sender: TObject);
var
  i:integer;
  columna :string;
  tmp : string;
begin
  i := ListViewColumnas.Selected.Index;
  columna := ListViewColumnas.Selected.SubItems[0];
  if (i <> 0) and (i<>1) then//No es el primero
  begin
    ListViewColumnas.Selected.SubItems[0] := ListViewColumnas.Items.Item[i - 1].SubItems[0];
    ListViewColumnas.Items.Item[i - 1].SubItems[0] := columna;
    ListViewColumnas.Items.Item[i - 1].Selected := true;
  end;
  actualizarcolumnas();
end;

procedure TFormColumnasManager.Bajar1Click(Sender: TObject);
var
  i:integer;
  columna :string;
  tmp : string;
begin
  i := ListViewColumnas.Selected.Index;
  if i = 0 then
  begin
    MessageDlg('La primera columna no puede ser editada', mtWarning, [mbOK], 0);
    exit;
  end;
  columna := ListViewColumnas.Selected.SubItems[0];
  if i <> ListViewColumnas.Items.Count-1 then//No es el ultimo
  begin
    ListViewColumnas.Selected.SubItems[0] := ListViewColumnas.Items.Item[i + 1].SubItems[0];
    ListViewColumnas.Items.Item[i + 1].SubItems[0] := columna;
    ListViewColumnas.Items.Item[i + 1].Selected := true;
  end;
  actualizarcolumnas();
end;

procedure TFormColumnasManager.Eliminar1Click(Sender: TObject);
var
  antiguonombre : string;
  nuevonombre : string;
  i:integer;
begin
  i := listviewcolumnas.Selected.Index;
  if(i=0) then exit;
  FormMain.ListViewConexiones.columns.Delete(FormMain.buscaridcolumnapornombre(listviewcolumnas.Selected.SubItems[0])+1);
  self.OnShow(nil);
end;

procedure TFormColumnasManager.actualizarcolumnas();
var
i:integer;
begin
  for i:=0 to listviewcolumnas.items.count-1 do
  begin
    FormMain.ListViewConexiones.Columns[i].Caption := listviewcolumnas.items[i].SubItems[0];
  end;
  FormMain.TimerMandarPingTimer(nil);  //Para que mande un ping y se ordenen las columnas
end;
procedure TFormColumnasManager.SpeedButtonPredeterminadoClick(
  Sender: TObject);
  var
  i: integer;
  c: Tlistcolumn;
begin
   Formmain.listviewconexiones.Columns.Clear;
  for i:=0 to 8 do
  begin
    c:= FormMain.ListViewConexiones.columns.Add;
    c.Caption := FormMain.columnas[i];
    c.Width := 100;
  end;
  self.OnShow(nil);
end;

end.
