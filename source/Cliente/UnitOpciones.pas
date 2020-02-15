unit UnitOpciones;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, unitMain,unitVariables, ComCtrls, gnugettext,
  ExtCtrls, ImgList;

type
  TFormOpciones = class(TForm)
    BtnGuardar:    TSpeedButton;
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
    procedure BtnGuardarClick(Sender: TObject);
    procedure CheckBoxPreguntarAlSalirClick(Sender: TObject);
    procedure CheckBoxCloseToTrayClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormOpciones: TFormOpciones;

implementation

uses UnitFormControl;

{$R *.dfm}


procedure TFormOpciones.BtnGuardarClick(Sender: TObject);
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
    
  FormMain.TimerMandarPing.Interval := strtointdef(EditPingTimerInterval.Text, 30)*1000;
  FormMain.TimerMandarPing.Enabled := CheckBoxMandarPingAuto.Checked;
  FormMain.StatusBar.Panels[1].Text := _('Puerto(s): ') + FormOpciones.EditPuerto.Text;

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
  s : string;
const
  ENTER = #13+#10;
begin

  s :=            '%CoolDir% => '+_('Directorio de coolvibes');
  s := s + ENTER+ '%Identificator% => '+_('Nombre del servidor');
  s := s + ENTER+ '%UserName% => '+_('Nombre de usuario del servidor');
  s := s + ENTER+ '%PCName% => '+_('Nombre de PC del servidor');

  LabeledEditDirUser.Hint := s;
  LabeledDirScreen.Hint := s;
  LabeledDirWebcam.Hint := s;
  LabeledDirThumbs.Hint := s;
  LabeledDirDownloads.Hint := s;

end;

end.
