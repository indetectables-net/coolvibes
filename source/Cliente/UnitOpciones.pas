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
    CheckBoxGuardarPluginsEnDisco: TCheckBox;
    EditEstado: TEdit;
    TabAyuda: TTabSheet;
    GroupBoxAyuda: TGroupBox;
    CheckBoxAyuda1: TCheckBox;
    CheckBoxAyuda2: TCheckBox;
    CheckBoxAyuda3: TCheckBox;
    TabApariencia: TTabSheet;
    CheckBoxIncluirTreeView: TCheckBox;
    CheckBoxTreeViewCC: TCheckBox;
    CheckBoxPanelInferior: TCheckBox;
    CheckBoxCapturaInferior: TCheckBox;
    CheckBoxSplash: TCheckBox;
    procedure BtnGuardarClick(Sender: TObject);
    procedure CheckBoxPreguntarAlSalirClick(Sender: TObject);
    procedure CheckBoxCloseToTrayClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButtonAniadirPluginClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Pluginadd(Path:string);
    procedure PageControlOpcionesChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
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
  PluginHandle : THandle;
  Plugin : TPlugin;
  Item : TListItem;
  MenuItem : Tmenuitem;
  ServerPluginPath, ClientPluginPath, PluginFolder: string;
  i : integer;

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
  if Path = '' then
    exit;

  ClientPluginPath := StringReplace(Path, '%cooldir%', extractfiledir(ParamStr(0)), [rfReplaceAll, rfIgnoreCase]);
  ServerPluginPath := Copy(ClientPluginPath, 1, length(ClientPluginPath) - 5) + 'S.dll';

  //Si existe el plugin para el servidor
  if not FileExists(ServerPluginPath) then
  begin
    EditEstado.Text := _('No existe el plugin por parte del servidor, asegurate de que están en la misma carpeta');
    exit;
  end;

  try
    PluginHandle := Loadlibrary(PChar(ClientPluginPath));
    if PluginHandle = 0 then
    begin
      EditEstado.Text := _('Imposible cargar el plugin');
      exit;
    end;
  except
    EditEstado.Text := _('Imposible cargar el plugin');
    exit;
  end;

  Plugin := TPlugin.Create(PluginHandle);
  for i:= 0 to ListViewPlugins.Items.Count-1 do
  begin
    //Ya está cargado el plugin con ese nombre
    if ListViewPlugins.Items[i].caption = Plugin.PluginName then
      begin
        EditEstado.Text := _('Ya está cargado un plugin con ese nombre');
        exit;
      end;
  end;

  //No es un plugin
  if (Plugin.Autor = '') and (Plugin.PluginName = '') then
    exit;

  //Instalamos el plugin
  PluginFolder := extractfilepath(paramstr(0)) + 'Recursos\Plugins\' + Plugin.PluginName + '\';
  Creadir(PluginFolder);
  CopyFile(pchar(ClientPluginPath), pchar(PluginFolder + Plugin.PluginName + 'C.dll'), false);
  CopyFile(pchar(ServerPluginPath), pchar(PluginFolder + Plugin.PluginName + 'S.dll'), false);

  Item := ListViewPlugins.Items.Add;
  Item.ImageIndex := 4;
  Item.Caption := Plugin.PluginName;
  Item.SubItems.Add(Plugin.Autor);
  Item.SubItems.Add(Path);

  MenuItem := TMenuItem.Create(FormMain.PopupMenuConexiones);
  MenuItem.Caption := Item.caption;
  MenuItem.OnClick := FormMain.PluginClick;
  MenuItem.Hint := Item.Caption;
  MenuItem.ImageIndex := 260;
  Item.Data := MenuItem;

  Formmain.Plugins.Add(MenuItem);
end;

procedure TFormOpciones.SpeedButton1Click(Sender: TObject);
var
  index : integer;
begin
  if ListViewPlugins.Selected = nil then exit;
  index := TMenuItem(ListViewPlugins.Selected.data).MenuIndex;
  Formmain.Plugins.Delete(index);
  ListViewPlugins.Selected.Delete;
end;

procedure TFormOpciones.PageControlOpcionesChange(Sender: TObject);
begin
    EditEstado.Text := '';
end;

procedure TFormOpciones.FormShow(Sender: TObject);
begin
  FormOpciones.ShowHint := CheckboxAyuda1.Checked;
end;

end.
