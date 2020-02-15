program Coolvibes;

uses
  Forms,
  UnitMain in 'UnitMain.pas' {FormMain},
  UnitFormControl in 'UnitFormControl.pas' {FormControl},
  UnitFormReg in 'UnitFormReg.pas' {FormReg},
  ScreenMaxCap in 'ScreenMaxCap.pas' {ScreenMax},
  UnitOpciones in 'UnitOpciones.pas' {FormOpciones},
  UnitAbout in 'UnitAbout.pas' {FormAbout},
  Unit1 in 'Unit1.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Coolvibes';
  Application.CreateForm(TFormMain, FormMain);
  Application.CreateForm(TFormOpciones, FormOpciones);
  Application.CreateForm(TFormAbout, FormAbout);
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
