unit ScreenMaxCap;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, IdTCPServer;

type
  TScreenMax = class(TForm)
    ImgCapturaGrande: TImage;
    procedure ImgCapturaGrandeMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
  private
    { Private declarations }
  public
    Servidor:     TIdPeerThread;
    EnviarClicks: boolean;
    constructor Create(aOwner: TComponent; Picture: TPicture;
      Serv: TIdPeerThread; EnviarC: boolean);
    { Public declarations }
  end;

var
  ScreenMax: TScreenMax;

implementation

{$R *.dfm}

constructor TScreenMax.Create(aOwner: TComponent; Picture: TPicture;
  Serv: TIdPeerThread; EnviarC: boolean);
begin
  inherited Create(aOwner);
  ImgCapturaGrande.Picture := Picture;
  Servidor     := Serv;
  EnviarClicks := EnviarC;
end;

procedure TScreenMax.ImgCapturaGrandeMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: integer);
var
  AltoCap, AnchoCap: integer;
begin
  if EnviarClicks then
  begin
    AnchoCap := imgCapturaGrande.Picture.Width;
    AltoCap := imgCapturaGrande.Picture.Height;
    X := (X * AnchoCap) div imgCapturaGrande.Width; //Una regla de tres
    Y := (Y * AltoCap) div imgCapturaGrande.Height;
    if button = mbLeft then
      servidor.Connection.WriteLn('MOUSEP' + IntToStr(X) + '|' +
        IntToStr(y) + '|' + 'CLICKIZQ' + '|')
    else if button = mbRight then
      servidor.Connection.WriteLn('MOUSEP' + IntToStr(X) + '|' +
        IntToStr(y) + '|' + 'CLICKDER' + '|');
  end;
end;

end.
