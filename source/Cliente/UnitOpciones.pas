unit UnitOpciones;

interface

uses
  Windows, SysUtils, Classes, Controls, Forms,
  Buttons, StdCtrls, unitMain, unitVariables, ComCtrls, gnugettext,
  ExtCtrls, ImgList, Dialogs, UnitPlugins, Menus;

type
  TFormOpciones = class(TForm)
    BtnGuardar: TSpeedButton;
    PageControlOpciones: TPageControl;
    TabConexion: TTabSheet;
    LabelPuerto: TLabel;
    EditPuerto: TEdit;
    TabNotificaciones: TTabSheet;
    General: TTabSheet;
    GrpBoxAlSalir: TGroupBox;
    CheckBoxPreguntarAlSalir: TCheckBox;
    CheckBoxCloseToTray: TCheckBox;
    GroupBoxConexion: TGroupBox;
    Label1: TLabel;
    CheckBoxEscucharAlIniciar: TCheckBox;
    CheckBoxMandarPingAuto: TCheckBox;
    EditPingTimerInterval: TEdit;
    CheckBoxMinimizeToTray: TCheckBox;
    CheckBoxAutoRefrescar: TCheckBox;
    CheckBoxCerrarControlAlDesc: TCheckBox;
    CheckBoxNotificacionMsn: TCheckBox;
    CheckBoxNotiMsnDesc: TCheckBox;
    CheckBoxGloboalPedirS: TCheckBox;
    CheckBoxAlertaSonora: TCheckBox;
    EditRutaArchivoWav: TEdit;
    TabDirectorios: TTabSheet;
    LabeledEditDirUser: TLabeledEdit;
    LabeledDirScreen: TLabeledEdit;
    LabeledDirWebcam: TLabeledEdit;
    LabeledDirThumbs: TLabeledEdit;
    LabeledDirDownloads: TLabeledEdit;
    CheckBoxCCIndependiente: TCheckBox;
    ImageList: TImageList;
    TabPlugins: TTabSheet;
    ListViewPlugins: TListView;
    SpeedButtonAniadirPlugin: TSpeedButton;
    OpenDialog: TOpenDialog;
    SpeedButton1: TSpeedButton;
    procedure BtnGuardarClick(Sender: TObject);
    procedure CheckBoxPreguntarAlSalirClick(Sender: TObject);
    procedure CheckBoxCloseToTrayClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButtonAniadirPluginClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Pluginadd(Path:string);
  private
    { Private declarations }
  public
    { Public declarations }
    Plugins : string;
  end;

var
  FormOpciones: TFormOpciones;

implementation

{$R *.dfm}

procedure TFormOpciones.BtnGuardarClick(Sender: TObject);
var
  i:integer;
begin
  if CheckBoxPreguntarAlSalir.Checked then
    FormMain.OnCloseQuery := FormMain.FormCloseQuery
  else if CheckBoxCloseToTray.Checked then
    FormMain.OnCloseQuery := FormMain.FormCloseQueryMinimizarAlTray
  else
    FormMain.OnCloseQuery := nil;

  if CheckBoxNotificacionMsn.Checked then
    NotificacionMsn := True
  else
    NotificacionMsn := False;

  if CheckBoxNotiMsnDesc.Checked then
    NotiMsnServerDesc := True
  else
    NotiMsnServerDesc := False;

  if CheckBoxMinimizeToTray.Checked then
    Application.OnMinimize := FormMain.MinimizeToTrayClick
  else
    Application.OnMinimize := nil;

  FormMain.TimerMandarPing.Interval := StrToIntDef(EditPingTimerInterval.Text, 30) * 1000;
  FormMain.TimerMandarPing.Enabled := CheckBoxMandarPingAuto.Checked;
  FormMain.StatusBar.Panels[1].Text := _('Puerto(s): ') + FormOpciones.EditPuerto.Text;
  Plugins := '';
  for i:=0 to listviewplugins.Items.Count-1 do
    Plugins := Plugins+listviewplugins.Items[i].SubItems[1]+'|';

  FormMain.GuardarArchivoINI();
  Close;
end;

procedure TFormOpciones.CheckBoxPreguntarAlSalirClick(Sender: TObject);
begin
  if CheckBoxCloseToTray.Checked and CheckBoxPreguntarAlSalir.Checked then
    CheckBoxCloseToTray.Checked := False;
end;

procedure TFormOpciones.CheckBoxCloseToTrayClick(Sender: TObject);
begin
  if CheckBoxCloseToTray.Checked and CheckBoxPreguntarAlSalir.Checked then
    CheckBoxPreguntarAlSalir.Checked := False;
end;

procedure TFormOpciones.FormCreate(Sender: TObject);
var
  s: string;
const
  ENTER = #13 + #10;
begin
  PageControlOpciones.ActivePage := General;
  s := '%CoolDir% => ' + _('Directorio de coolvibes');
  s := s + ENTER + '%Identificator% => ' + _('Nombre del servidor');
  s := s + ENTER + '%UserName% => ' + _('Nombre de usuario del servidor');
  s := s + ENTER + '%PCName% => ' + _('Nombre de PC del servidor');

  LabeledEditDirUser.Hint := s;
  LabeledDirScreen.Hint := s;
  LabeledDirWebcam.Hint := s;
  LabeledDirThumbs.Hint := s;
  LabeledDirDownloads.Hint := s;

end;

procedure TFormOpciones.SpeedButtonAniadirPluginClick(Sender: TObject);
begin
  Opendialog.FilterIndex := 0;
  OpenDialog.InitialDir := extractfilepath(paramstr(0));

  OpenDialog.Execute;

  Pluginadd(Opendialog.filename);
end;

procedure TFormOpciones.Pluginadd(Path:string);
var
  h : THandle;
  Plugin : TPlugin;
  Item : TListItem;
  NuevaPath : string;
  mitem : Tmenuitem;
  procedure Creadir(dir: string);
  var
    tmp: string;
  begin
    while Pos('\', dir) > 0 do
      begin
        tmp := tmp + Copy(dir, 1, Pos('\', dir));
        Delete(dir, 1, Pos('\', dir));
        if not directoryexists(tmp) then
          CreateDirectory(PChar(tmp), nil);
      end;
  end;
begin
  if path = '' then exit;
  try
    H := Loadlibrary(PChar(Path));
  except
    exit;
  end;

  if H = 0 then exit;    //Error al cargar la dll
  Plugin := TPlugin.Create(H);

  if (Plugin.Autor = '') and (Plugin.PluginName = '') then exit; //No es un plugin
  Nuevapath := extractfilepath(paramstr(0))+'Recursos\Plugins\'+Plugin.PluginName+'\';

  //"Instalamos" el plugin
  Creadir(NuevaPath);
  Nuevapath := Nuevapath+extractfilename(Path);
  copyfile(pchar(Path),pchar(NuevaPath), false); //La dll del cliente

  copyfile(pchar(copy(Path,1,length(Path)-5)+'S.dll'),pchar(extractfilepath(NuevaPath)+extractfilename(copy(Path,1,length(Path)-5)+'S.dll')), false); //el server

  Item := ListViewPlugins.Items.Add;
  item.ImageIndex := 4;
  item.Caption := Plugin.PluginName;
  item.SubItems.Add(Plugin.Autor);
  item.SubItems.Add(Nuevapath);
  mitem := TMenuItem.Create(Formmain.PopupMenuConexiones);
  mitem.Caption := item.caption;
  mitem.OnClick := Formmain.PluginClick;
  mitem.Hint := item.Caption;
  mitem.ImageIndex := 260;
  Formmain.Plugins.Add(mitem);
end;
procedure TFormOpciones.SpeedButton1Click(Sender: TObject);
begin
  if ListViewPlugins.Selected = nil then exit;
  ListViewPlugins.Selected.Delete;
end;

end.
