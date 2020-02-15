unit UnitFormNotifica;

interface

uses
  Windows, SysUtils, Classes, Controls, Forms,
  StdCtrls, ExtCtrls, ComCtrls, gnugettext, Graphics;

type
  TFormNotifica = class(TForm)
    LabelIP: TLabel;
    LabelName: TLabel;
    ImageFondo: TImage;
    ImageClose: TImage;
    Timer: TTimer;
    LabelConect: TLabel;
    procedure ImageCloseClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ImageFondoClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure CreateParams(var Params: TCreateParams); override;
    { Private declarations }
  public
    PosY: Integer;
    Subiendo: Boolean;
    Item: TListItem;
    constructor Create(aOwner: TComponent; tItem: TListItem);
    { Public declarations }
  end;

const
  Altura = 105;

var
  FormNotifica: TFormNotifica;

implementation

uses UnitMain;

{$R *.dfm}

constructor TFormNotifica.Create(aOwner: TComponent; tItem: TListItem);
begin
  inherited Create(aOwner);
  Item := tItem;
  LabelIP.Caption := Item.Caption;
  LabelName.Caption := Item.SubItems[0];
end;

procedure TFormNotifica.ImageCloseClick(Sender: TObject);
begin
  FormMain.NotificandoOnline := False;
  Close;
end;

procedure TFormNotifica.TimerTimer(Sender: TObject);
begin
  if Subiendo = True then
    begin
      if Top > PosY + 1 then
        begin
          Top := Top - 2;
          Height := Height + 2;
          Repaint;
          sleep(5);
        end
      else
        begin
          Subiendo := False;
          Timer.Interval := 3000;
        end;
    end //Bajando
  else
    begin
      Timer.Interval := 5;
      if Top < (PosY + Altura) then
        begin
          Top := Top + 2;
          Height := Height - 2;
          Repaint;
          sleep(5);
        end
      else
        begin
          FormMain.NotificandoOnline := False;
          Free;
        end;
    end;
end;

procedure TFormNotifica.FormCreate(Sender: TObject);
var
  Zona: TRect;
begin
  UseLanguage(Formmain.idioma);
  TranslateComponent(Self);
  Self.DoubleBuffered := True; //Evita parpadeos
  SystemParametersInfo(SPI_GETWORKAREA, 0, @Zona, 0);
  Left := Zona.Right - Width - 10;
  Top := Zona.Bottom;
  PosY := Top - Height;
  Subiendo := True;
end;

procedure TFormNotifica.ImageFondoClick(Sender: TObject);
begin
  Item.Selected := True;
  FormMain.Abrir1Click(nil);
end;

procedure TFormNotifica.FormShow(Sender: TObject);
begin
  Height := 0;
  if IsWindowVisible(Application.Handle) and (formmain.Visible = False) then //Si estamos en el tray
    ShowWindow(Application.Handle, SW_HIDE);
end;

procedure TFormNotifica.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.Style := Params.Style or WS_POPUP;
end;
end.
