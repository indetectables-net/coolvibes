unit UnitFormSplash;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls;

type
  TFormSplash = class(TForm)
    ImageSplash: TImage;
    TimerSplash: TTimer;
    TimerTransparencia: TTimer;
    procedure FormShow(Sender: TObject);
    procedure TimerSplashTimer(Sender: TObject);
    procedure TimerTransparenciaTimer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormSplash: TFormSplash;
  i         : integer;
  Velocidadtransparencia : integer;
  RetrasoTransparencia : Integer;
implementation

uses UnitMain;

{$R *.dfm}

procedure TFormSplash.FormShow(Sender: TObject);
begin
  FormSplash.ImageSplash.Picture.LoadFromFile(ExtractFilePath(ParamStr(0))+'Recursos\Imagenes\Splash.jpg');
  FormSplash.Width  := FormSplash.ImageSplash.Picture.Width;
  FormSplash.Height := FormSplash.ImageSplash.Picture.Height;
  Velocidadtransparencia := 10;
  RetrasoTransparencia := 2000;
  TimerSplash.Interval := Retrasotransparencia;
  TimerSplash.Enabled := true;
  i := 0;
end;

procedure TFormSplash.TimerSplashTimer(Sender: TObject);
begin
  i := i + 1;
  if i = 1 then
     TimerTransparencia.Enabled := true;
end;

procedure TFormSplash.TimerTransparenciaTimer(Sender: TObject);
begin
  FormSplash.AlphaBlend := True;
  if (FormSplash.AlphaBlendValue > Velocidadtransparencia) then
    FormSplash.AlphaBlendValue := FormSplash.AlphaBlendValue-Velocidadtransparencia
  else
  begin
    TimerTransparencia.Enabled := false;
    TimerSplash.Enabled := false;
    self.Close;
  end;
end;

end.
