unit UnitFormLanguage;

interface

uses
  SysUtils, Classes, Controls, Forms,
  StdCtrls;

type
  TFormSeleccionarIdioma = class(TForm)
    Button1: TButton;
    cmbLanguages: TComboBox;
    LabelAutor: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure cmbLanguagesChange(Sender: TObject);
    function readfile(filen: string): string;
    procedure FormShow(Sender: TObject);
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
  FormMain.Idioma := Copy(cmbLanguages.Text, 1, 2);
  if ((not directoryexists(extractfilepath(ParamStr(0)) + 'Recursos\locale\' + Formmain.Idioma)) and (Formmain.Idioma <> 'ES')) or (Formmain.Idioma = '') then
    FormMain.Idioma := 'NONE'; //Para que se lo pida la siguiente vez
  Self.Close;
end;

function TFormSeleccionarIdioma.readfile(filen: string): string;
var
  F: file;
  Tamano: Integer;
begin
  if not fileexists(filen) then
    begin
      Result := '';
      Exit;
    end;
  FileMode := 0;
  AssignFile(F, filen);
  Reset(F, 1);
  tamano := FileSize(F);
  SetLength(Result, tamano);
  BlockRead(F, Result[1], tamano);
  CloseFile(F);
end;

procedure TFormSeleccionarIdioma.cmbLanguagesChange(Sender: TObject);
var
  autor: string;
begin
  autor := Readfile(extractfilepath(ParamStr(0)) + 'Recursos\Locale\' + Copy(cmbLanguages.Text, 1, 2) + '\LC_MESSAGES\autor.txt');
  LabelAutor.Caption := autor;
end;

procedure TFormSeleccionarIdioma.FormShow(Sender: TObject);
var
  Listado: TSearchRec;
  i: Integer;
begin //Cargamos los idiomas al combobox
  cmbLanguages.Items.Clear;

  cmbLanguages.Items.Add('ES - Español'); //Tiene preferencia :D

  i := FindFirst(extractfilepath(ParamStr(0)) + 'Recursos\locale\*.*', -faDirectory, Listado);
  while i = 0 do
    begin
      if (Length(listado.Name) = 2) and (Listado.Name <> '..') then
        cmblanguages.Items.Add(Listado.Name + ' - ' + ReadFile(extractfilepath(ParamStr(0)) + 'Recursos\locale\' + listado.Name + '\LC_MESSAGES\idioma.txt'));
      I := FindNext(Listado);
    end;
  FindClose(Listado);
end;

end.
