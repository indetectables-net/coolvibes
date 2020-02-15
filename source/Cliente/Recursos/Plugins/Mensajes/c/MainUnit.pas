unit MainUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms,
  StdCtrls, ComCtrls, ExtCtrls, Graphics, dialogs, winsock, ImgList,
  Buttons;




type
  TFormMain = class(TForm)
    GrpBoxTipoMensaje: TGroupBox;
    ImgError: TImage;
    ImgAsterisk: TImage;
    ImgWarning: TImage;
    ImgInfo: TImage;
    RdBtnError: TRadioButton;
    RdBtnPregunta: TRadioButton;
    RdBtnExclamacion: TRadioButton;
    RdBtnInfo: TRadioButton;
    RdBtnVacio: TRadioButton;
    RdGrpBotonesMensaje: TRadioGroup;
    BtnEnviarMensaje: TSpeedButton;
    MemoMensaje: TMemo;
    EditTituloMensaje: TEdit;
    LabelTituloMensaje: TLabel;
    StatusBar: TStatusBar;
    procedure BtnEnviarMensajeClick(Sender: TObject);
  private
  
  public
    ConID: integer;
    PID : integer;
    stoprequested:boolean;
    procedure RecData(data:string);
    procedure Enviar(Texto:string);
  end;


implementation

{$R *.dfm}

procedure TFormMain.RecData(data:string);
var
  Tipo : integer;
  Text : string;
begin
  Tipo := strtointdef(Data,-1);
  case tipo of
    idOk: Text := 'OK';
    idCancel: Text := 'Cancelar';
    idRetry: Text := 'Reintentar';
    idYes: Text := 'Sí';
    idNo: Text := 'No';
    idAbort: Text := 'Abortar';
    idIgnore: Text := 'Ignorar';
  end;
  StatusBar.Panels[1].Text := Text;
end;

procedure TFormMain.Enviar(Texto:string);
var
  Enviar: string;
begin
  Enviar := 'PLUGINDATA|Mensajes|'+Texto+#10;
  Send(self.ConID, Enviar[1], Length(Enviar), 0);
end;

procedure TFormMain.BtnEnviarMensajeClick(Sender: TObject);
var
  Tipo: string;
begin
  if RdGrpBotonesMensaje.ItemIndex <> -1 then
  begin
    if RdBtnError.Checked then
      Tipo := 'WARN'
    else if RdBtnPregunta.Checked then
      Tipo := 'QUES'
    else if RdBtnExclamacion.Checked then
      Tipo := 'EXCL'
    else if RdBtnInfo.Checked then
      Tipo := 'INFO'
    else if RdBtnVacio.Checked then
      Tipo := 'VACI';
    Enviar('MSJN' + MemoMensaje.Text + '|' +
    EditTituloMensaje.Text + '|' + Tipo + '|' +
    PChar(IntToStr(RdGrpBotonesMensaje.ItemIndex)) + '|');
    end
    else
      MessageDlg('Selecciona algún tipo de botón', mtWarning, [mbOK], 0);
  end;


end.
