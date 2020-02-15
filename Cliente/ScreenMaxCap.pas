unit ScreenMaxCap;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls;

type
  TScreenMax = class(TForm)
    ImgCapturaGrande: TImage;
  private
    { Private declarations }
  public
    constructor Create(aOwner: TComponent; Picture: TPicture);
    { Public declarations }
  end;

var
  ScreenMax: TScreenMax;

implementation

{$R *.dfm}

constructor TScreenMax.Create(aOwner: TComponent; Picture: TPicture);
begin
  inherited Create(aOwner);
  ImgCapturaGrande.Picture := Picture;
end;

end.
