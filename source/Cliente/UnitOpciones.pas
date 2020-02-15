unit UnitOpciones;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls,
  unitMain,
  unitVariables, ComCtrls;

type
  TFormOpciones = class(TForm)
    LabelPuerto:   TLabel;
    EditPuerto:    TEdit;
    BtnGuardar:    TSpeedButton;
    CheckBoxPreguntarAlSalir: TCheckBox;
    GrpBoxAlSalir: TGroupBox;
    CheckBoxCloseToTray: TCheckBox;
    GrpBoxServerDesconect: TGroupBox;
    CheckBoxNotiMsnDesc: TCheckBox;
    GroupBoxConexion: TGroupBox;
    CheckBoxEscucharAlIniciar: TCheckBox;
    LabelPreguntarAlSalir: TLabel;
    CheckBoxMandarPingAuto: TCheckBox;
    CheckBoxMinimizeToTray: TCheckBox;
    CheckBoxNotificacionMsn: TCheckBox;
    EditPingTimerInterval: TEdit;
    Label1: TLabel;
    CheckBoxAutoRefrescar: TCheckBox;
    procedure BtnGuardarClick(Sender: TObject);
    procedure CheckBoxPreguntarAlSalirClick(Sender: TObject);
    procedure CheckBoxCloseToTrayClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormOpciones: TFormOpciones;

implementation

uses UnitColumnasManager, UnitFormControl;

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
  FormMain.StatusBar.Panels[1].Text := 'Puerto: ' + FormOpciones.EditPuerto.Text;
  
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



procedure TFormOpciones.SpeedButton1Click(Sender: TObject);
begin
FormColumnasManager.show;
end;

end.
