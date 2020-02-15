unit UnitVisorDeMiniaturas;

interface

uses
  SysUtils, Classes, Graphics, Controls, Forms,
  ComCtrls, StdCtrls, ExtCtrls, IdTCPServer, Menus, gnugettext,
  ImgList, UnitFunciones;

type
  TFormVisorDeMiniaturas = class(TForm)
    PageControlMiniaturas: TPageControl;
    TabSheetPrincipal: TTabSheet;
    TabSheetCola: TTabSheet;
    TabSheetOpciones: TTabSheet;
    ImageThumnail: TImage;
    ListViewColaThumbnails: TListView;
    LabelCalidadJPG: TLabel;
    TrackBarCalidad: TTrackBar;
    LabelPosicionCompresJpg: TLabel;
    LabelTamanoJPG: TLabel;
    RadioAutomatico: TRadioButton;
    RadioManual: TRadioButton;
    CheckBoxAutoGuardado: TCheckBox;
    LabelPorCiento: TLabel;
    LabelModoDeVisionado: TLabel;
    ComboBoxModoDeVisionado: TComboBox;
    ProgressBarThumbnail: TProgressBar;
    ImageList1: TImageList;
    PopupColaDeMiniaturas: TPopupMenu;
    Eliminardelacola1: TMenuItem;
    LabelAviso: TLabel;
    StatusBar: TStatusBar;
    PedirdorTimer: TTimer;
    SpinTamanoRelativo: TEdit;
    procedure TrackBarCalidadChange(Sender: TObject);
    procedure ImageThumnailClick(Sender: TObject);
    procedure PopupColaDeMiniaturasPopup(Sender: TObject);
    procedure Eliminardelacola1Click(Sender: TObject);
    procedure PedirdorTimerTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    pidiendo: Boolean;
  public
    { Public declarations }

    Servidor: TIdPeerThread;
    FormControl: TObject;
    EnviarClicks: Boolean;
    constructor Create(aOwner: TComponent; Serv: TIdPeerThread; fc: TObject);
    procedure aniadirThumbnail(path: string);
    procedure pedirthumbnail();
    procedure callback();
  end;

var
  FormVisorDeMiniaturas: TFormVisorDeMiniaturas;

implementation

uses UnitFormControl, UnitMain;
{$R *.dfm}

constructor TFormVisorDeMiniaturas.Create(aOwner: TComponent; Serv: TIdPeerThread; fc: TObject);
begin
  inherited Create(aOwner);
  Servidor := Serv;
  FormControl := fc;
  PageControlMiniaturas.ActivePage := TabSheetOpciones;
end;

procedure TFormVisorDeMiniaturas.TrackBarCalidadChange(Sender: TObject);
begin
  LabelPosicionCompresJpg.Caption := IntToStr(TrackBarCalidad.Position) + '%';
end;

procedure TFormVisorDeMiniaturas.aniadirThumbnail(path: string);
var
  Item: TListItem;
begin
  Item := ListViewColaThumbnails.Items.Add;
  item.ImageIndex := 1;
  item.Caption := extractfilename(path);
  item.SubItems.Add(path);
  StatusBar.Panels[1].Text := IntToStr(ListViewColaThumbnails.Items.Count);
  {if not pidiendo then
                                                                  pedirthumbnail(); }//Mejor dejarle configurar las opciones primero
end;

procedure TFormVisorDeMiniaturas.ImageThumnailClick(Sender: TObject);
begin
  pedirthumbnail();
end;

procedure TFormVisorDeMiniaturas.pedirthumbnail();
begin
  pedirdortimer.Enabled := False;
  if pidiendo then Exit;
  if ListviewColaThumbnails.Items.Count = 0 then Exit;
  pidiendo := True;
  LabelAviso.Caption := ''; //quitamos el aviso
  if (FormControl as TFormControl).RecibiendoJPG then
    begin
      pidiendo := False;
      pedirdortimer.Enabled := True;
      Exit;
    end;
  StatusBar.Panels[3].Text := _('Recibiendo Thumbnail');
  if RadioAutomatico.Checked then
    begin
      //(FormControl as TFormControl).Servidor.Connection.Writeln('GETTHUMB|' +
      ConnectionWriteln(Servidor, 'GETTHUMB|' +
        ListviewColaThumbnails.Items[0].subitems[0] +
        '|' + IntToStr(ImageThumnail.Width) +
        '|' + IntToStr(ImageThumnail.Height) +
        '|' + IntToStr(TrackBarCalidad.Position) + '|')
    end
  else
    //(FormControl as TFormControl).Servidor.Connection.Writeln('GETTHUMB|' +
    ConnectionWriteln(Servidor, 'GETTHUMB|' +
      ListviewColaThumbnails.Items[0].subitems[0] +
      '|' + IntToStr(6666666) + //Para saber que se utiliza el tamaño relativo
      '|' + SpinTamanoRelativo.text +
      '|' + IntToStr(TrackBarCalidad.Position) + '|');
end;

procedure TFormVisorDeMiniaturas.callback();
begin
  if (CheckBoxAutoGuardado.Checked) then
    begin
      (FormControl as TFormControl).CrearDirectoriosUsuario;
      ImageThumnail.Picture.SaveToFile((FormControl as TFormControl).DirMiniaturas + ListviewColaThumbnails.Items[0].Caption);
    end;
  ListviewColaThumbnails.Items[0].Delete; //Eliminamos el primer item

  StatusBar.Panels[1].Text := IntToStr(ListViewColaThumbnails.Items.Count);
  pidiendo := False;
  StatusBar.Panels[3].Text := _('En espera');
  if ComboBoxModoDeVisionado.Text = _('Automático') then
    pedirthumbnail();
end;

procedure TFormVisorDeMiniaturas.PopupColaDeMiniaturasPopup(
  Sender: TObject);
begin
  if ListViewColaThumbnails.Selected <> nil then
    PopupColaDeMiniaturas.Items[0].Enabled := True
  else
    PopupColaDeMiniaturas.Items[0].Enabled := False
end;

procedure TFormVisorDeMiniaturas.Eliminardelacola1Click(Sender: TObject);
var
  mslistviewitem, tmpitem: Tlistitem;
begin
  mslistviewitem := ListViewColaThumbnails.Selected;
  while Assigned(mslistviewitem) do
    begin
      tmpitem := mslistviewitem;
      mslistviewitem := ListViewColaThumbnails.GetNextItem(mslistviewitem, sdAll, [isSelected]);
      if (not (pidiendo and (ListviewColaThumbnails.Items[0] = tmpitem))) then
        tmpitem.Delete;
    end;
end;

procedure TFormVisorDeMiniaturas.PedirdorTimerTimer(Sender: TObject);
begin
  pedirthumbnail();
end;

procedure TFormVisorDeMiniaturas.FormCreate(Sender: TObject);
begin
  UseLanguage(Formmain.idioma);
  TranslateComponent(Self);
end;

end.
