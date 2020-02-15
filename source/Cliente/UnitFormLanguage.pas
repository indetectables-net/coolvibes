unit UnitFormLanguage;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ShellApi;

type
  TFormSeleccionarIdioma = class(TForm)
    Button1: TButton;
    cmbLanguages: TComboBox;
    LabelAutor: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure cmbLanguagesChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormSeleccionarIdioma: TFormSeleccionarIdioma;

implementation

uses UnitMain;

{$R *.dfm}

procedure TFormSeleccionarIdioma.Button1Click(Sender: TObject);
begin
  FormMain.Idioma := copy(cmbLanguages.Text,1,2);
  FormMain.GuardarArchivoINI();
  FormMain.Traducir();
  self.Close;
end;

procedure TFormSeleccionarIdioma.cmbLanguagesChange(Sender: TObject);
var
  F : file;
  Tamano : integer;
  autor : string;
begin
  if fileexists(extractfilepath(paramstr(0))+'Recursos\Locale\'+copy(cmbLanguages.Text,1,2)+'\LC_MESSAGES\autor.txt') then
  begin
    FileMode := 0;
    AssignFile(F, extractfilepath(paramstr(0))+'Recursos\Locale\'+copy(cmbLanguages.Text,1,2)+'\LC_MESSAGES\autor.txt');
    Reset(F, 1);
    tamano := FileSize(F);
    SetLength(autor, tamano);
    BlockRead(F, autor[1], tamano);
    CloseFile(F);
  end
  else
    autor := '';
  LabelAutor.Caption := autor;
end;

end.
