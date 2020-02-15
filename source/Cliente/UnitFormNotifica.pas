unit UnitFormNotifica;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls;

type
  TFormNotifica = class(TForm)
    LabelIP:    TLabel;
    LabelName:  TLabel;
    ImageFondo: TImage;
    ImageClose: TImage;
    Timer:      TTimer;
    LabelConect: TLabel;
    procedure ImageCloseClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ImageFondoClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private

    { Private declarations }
  public
    PosY:     integer;
    Subiendo: boolean;
    Item:     TListItem;
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
  FormMain.NotificandoOnline := false;
  Close;
end;

procedure TFormNotifica.TimerTimer(Sender: TObject);
begin
  if Subiendo = True then
  begin
    if Top > PosY + 1 then
    begin
      Top    := Top - 2;
      Height := Height + 2;
      Repaint;
      sleep(5);
    end
    else
    begin
      Subiendo := False;
      Timer.Interval := 3000;
    end;
  end   //Bajando
  else
  begin
    Timer.Interval := 5;
    if Top < (PosY + Altura) then
    begin
      Top    := Top + 2;
      Height := Height - 2;
      Repaint;
      sleep(5);
    end
    else
    begin
      FormMain.NotificandoOnline := false;
      Free;
    end;
  end;
end;

procedure TFormNotifica.FormCreate(Sender: TObject);
var
  Zona: TRect;
begin
  SystemParametersInfo(SPI_GETWORKAREA, 0, @Zona, 0);
  Left     := Zona.Right - Width - 10;
  Top      := Zona.Bottom;
  PosY     := Top - Height;
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
end;


end.
