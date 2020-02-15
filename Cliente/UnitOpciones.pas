unit UnitOpciones;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls;

type
  TFormOpciones = class(TForm)
    LabelPuerto: TLabel;
    EditPuerto: TEdit;
    SpeedButton1: TSpeedButton;
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormOpciones: TFormOpciones;

implementation

{$R *.dfm}

procedure TFormOpciones.SpeedButton1Click(Sender: TObject);
begin
  Close;
end;

end.
