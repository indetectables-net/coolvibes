unit UnitFormReg;

interface

uses
  Windows, Classes, Controls, Forms,
  Dialogs, StdCtrls, Buttons, IdTCPServer, gnugettext, sysutils, UnitFunciones;

type
  TFormReg = class(TForm)
    LabelNombre: TLabel;
    EditNombreValor: TEdit;
    LabelInformacion: TLabel;
    MemoInformacionValor: TMemo;
    BtnAceptar: TSpeedButton;
    BtnCancelar: TSpeedButton;
    procedure BtnCancelarClick(Sender: TObject);
    procedure BtnAceptarClick(Sender: TObject);
    procedure MemoInformacionValorKeyPress(Sender: TObject; var Key: char);
    procedure FormCreate(Sender: TObject);
    procedure MemoInformacionValorChange(Sender: TObject);
  private
    Servidor: TIdPeerThread;
    Ruta, Tipo: string;
    procedure CerrarVentana();
    { Private declarations }
  public
    constructor Create(aOwner: TComponent; Socket: TIdPeerThread;
  RegistroRuta, RegistroTipo: string;Creando : Boolean;Registronombre, Registrodatos:string);
    { Public declarations }
  end;

var
  FormReg: TFormReg;

implementation

uses UnitMain;

{$R *.dfm}

constructor TFormReg.Create(aOwner: TComponent; Socket: TIdPeerThread;
  RegistroRuta, RegistroTipo: string;Creando : Boolean;Registronombre, Registrodatos:string);
begin
  inherited Create(aOwner);
  Servidor := Socket;
  Ruta := RegistroRuta;
  Tipo := RegistroTipo;
  if Creando then
    Caption := _('Añadiendo valor ') + Tipo
  else
  begin
    if Tipo = 'REG_DWORD' then //El valor en dword nos lo pasan como 0x00000 (num) tenemos que extraer el "num"
    begin
      Delete(RegistroDatos, 1, pos('(', RegistroDatos));
      Registrodatos := Copy(RegistroDatos,1,pos(')',Registrodatos)-1);
    end;
    Caption := _('Modificando valor ') + Tipo;
  end;
  EditNombreValor.Text := RegistroNombre;

  MemoInformacionValor.Text := (RegistroDatos);
end;

procedure TFormReg.CerrarVentana();
begin
  //Deja todo como estaba
  EditNombreValor.Text := '';
  EditNombreValor.Enabled := True;
  MemoInformacionValor.Text := '';
  MemoInformacionValor.Enabled := True;
  Close;
end;

procedure TFormReg.BtnCancelarClick(Sender: TObject);
begin
  CerrarVentana();
end;

procedure TFormReg.BtnAceptarClick(Sender: TObject);
begin
  if Servidor.Connection.Connected then
    begin
      ConnectionWriteLn(Servidor,'ADDVALUE|' + Ruta + EditNombreValor.Text +
        '|' + Tipo + '|' + MemoInformacionValor.Text);
    end
  else
    MessageDlg(_('No estás conectado!'), mtWarning, [mbOK], 0);
  CerrarVentana();
end;

procedure TFormReg.MemoInformacionValorKeyPress(Sender: TObject; var Key: char);
var
  letra : string;
begin
  if (Tipo = 'REG_SZ') or (Tipo = 'REG_EXPAND_SZ') then
    if (key = #10) or (key = #13) then
      begin
        Key := #0;
        MessageBeep($FFFFFFFF);
      end;
  if Tipo = 'REG_BINARY' then
  begin
    //Si es un valor binario solo deja introducir valores hexadeciamles y espacios
    if not (key in ['0'..'9', 'A'..'F', 'a'..'f', ' ', #8]) then
      //#8 es el backspace, borrar
      begin
        key := #0;
        MessageBeep($FFFFFFFF);
      end;
    Letra := uppercase(Key);
    Key := char(Letra[1]);
  end;
  if Tipo = 'REG_DWORD' then //Si es un valor binario solo deja introducir números
    if (not (key in ['0'..'9', #8])) then
      begin
        key := #0;
        MessageBeep($FFFFFFFF);
      end;
end;

procedure TFormReg.FormCreate(Sender: TObject);
begin
  UseLanguage(Formmain.idioma);
  TranslateComponent(Self);
end;

procedure TFormReg.MemoInformacionValorChange(Sender: TObject);
var
  str : string;
  sel : integer;
begin
  if Tipo = 'REG_BINARY' then
  begin
    str := MemoInformacionValor.Text;
    if length(str) < 2 then exit;
    if POS(' ', Copy(Str, length(Str)-1,2)) = 0  then
    begin
      sel := Memoinformacionvalor.SelStart;
      Memoinformacionvalor.Text := Memoinformacionvalor.Text+' ';
      Memoinformacionvalor.SelStart := sel+1;
    end;
  end;
end;

end.
