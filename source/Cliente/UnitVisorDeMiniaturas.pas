unit UnitVisorDeMiniaturas;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, Spin,IdTCPServer, Menus, ImgList, gnugettext;
                                                  
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
    SpinTamanoRelativo: TSpinEdit;
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
    procedure TrackBarCalidadChange(Sender: TObject);
    procedure ImageThumnailClick(Sender: TObject);
    procedure PopupColaDeMiniaturasPopup(Sender: TObject);
    procedure Eliminardelacola1Click(Sender: TObject);
    procedure PedirdorTimerTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    pidiendo : boolean;
  public
    { Public declarations }

    Servidor:     TIdPeerThread;
    FormControl: TObject;
    EnviarClicks: boolean;
    constructor Create(aOwner: TComponent;Serv: TIdPeerThread;fc:Tobject);
    procedure aniadirThumbnail(path: string);
    procedure pedirthumbnail();
    procedure callback();
  end;

var
  FormVisorDeMiniaturas: TFormVisorDeMiniaturas;

implementation

uses UnitFormControl, UnitMain;
{$R *.dfm}

constructor TFormVisorDeMiniaturas.Create(aOwner: TComponent;Serv: TIdPeerThread;fc:Tobject);
begin
  inherited Create(aOwner);
  Servidor     := Serv;
  FormControl := fc;
  PageControlMiniaturas.ActivePage := TabSheetOpciones;
end;

procedure TFormVisorDeMiniaturas.TrackBarCalidadChange(Sender: TObject);
begin
  LabelPosicionCompresJpg.Caption := IntToStr(TrackBarCalidad.Position) + '%';
end;

procedure TFormVisorDeMiniaturas.aniadirThumbnail(path: string);
var
  Item : TListItem;
begin
  Item := ListViewColaThumbnails.Items.Add;
  item.ImageIndex := 1;
  item.Caption := extractfilename(path);
  item.SubItems.Add(path);
  StatusBar.Panels[1].Text := inttostr(ListViewColaThumbnails.items.count);
  {if not pidiendo then
    pedirthumbnail(); } //Mejor dejarle configurar las opciones primero
end;


procedure TFormVisorDeMiniaturas.ImageThumnailClick(Sender: TObject);
begin
  pedirthumbnail();
end;

procedure TFormVisorDeMiniaturas.pedirthumbnail();
begin
  pedirdortimer.enabled := false;
  if pidiendo then exit;
  if ListviewColaThumbnails.Items.Count = 0 then exit;
  pidiendo := true;
  LabelAviso.Caption := '';//quitamos el aviso
  if (FormControl as TFormControl).RecibiendoJPG then
  begin
  pidiendo := false;
  pedirdortimer.enabled := true;
  exit;
  end;
  StatusBar.Panels[3].Text := _('Recibiendo Thumbnail');
  if RadioAutomatico.Checked then
  begin
    (FormControl as TFormControl).PedirPorSegundoSocket(2,'GETTHUMB|'+
    ListviewColaThumbnails.Items[0].subitems[0]+
    '|'+inttostr(ImageThumnail.Width)+
    '|'+inttostr(ImageThumnail.Height)+
    '|'+inttostr(TrackBarCalidad.Position)+'|')
  end
  else
    (FormControl as TFormControl).PedirPorSegundoSocket(2,'GETTHUMB|'+
    ListviewColaThumbnails.Items[0].subitems[0]+
    '|'+inttostr(6666666)+ //Para saber que se utiliza el tamaño relativo
    '|'+inttostr(SpinTamanoRelativo.value)+
    '|'+inttostr(TrackBarCalidad.Position)+'|');
end;

procedure TFormVisorDeMiniaturas.callback();
begin
  if(CheckBoxAutoGuardado.Checked) then
  begin
    (FormControl as TFormControl).CrearDirectoriosUsuario;
    ImageThumnail.Picture.SaveToFile(ExtractFilePath(ParamStr(0)) + 'Usuarios\'+(FormControl as TFormControl).NombrePC+'\Thumbnails\'+ListviewColaThumbnails.Items[0].caption);
  end;
  ListviewColaThumbnails.Items[0].Delete; //Eliminamos el primer item
  StatusBar.Panels[1].Text := inttostr(ListViewColaThumbnails.items.count);
  pidiendo := false;
  StatusBar.Panels[3].Text := _('En espera');
  if ComboBoxModoDeVisionado.Text = _('Automático') then
    pedirthumbnail();
end;

procedure TFormVisorDeMiniaturas.PopupColaDeMiniaturasPopup(
  Sender: TObject);
begin
if ListViewColaThumbnails.Selected <> nil then
PopupColaDeMiniaturas.Items[0].Enabled := true
else
PopupColaDeMiniaturas.Items[0].Enabled := false
end;

procedure TFormVisorDeMiniaturas.Eliminardelacola1Click(Sender: TObject);
var
  mslistviewitem, tmpitem:Tlistitem;
begin
  mslistviewitem := ListViewColaThumbnails.Selected;
  while Assigned(mslistviewitem) do
  begin
    tmpitem := mslistviewitem;
    mslistviewitem := ListViewColaThumbnails.GetNextItem(mslistviewitem, sdAll, [isSelected]);
    if(not(pidiendo and (ListviewColaThumbnails.Items[0]=tmpitem))) then
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
    TranslateComponent(self);
end;

end.
