unit UnitFormSendKeys;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, IdTCPServer, Menus, gnugettext;

type
  TFormSendKeys = class(TForm)
    MemoSendKeys: TMemo;
    BtnEnviar: TSpeedButton;
    EditTitulo: TEdit;
    EditHandle: TEdit;
    LabelHandle: TLabel;
    BtnEspeciales: TSpeedButton;
    PopupSendKeys: TPopupMenu;
    Enter1: TMenuItem;
    Control1: TMenuItem;
    Alt1: TMenuItem;
    Shift1: TMenuItem;
    BtnInformacion: TSpeedButton;
    Retroceso1: TMenuItem;
    Suprimir1: TMenuItem;
    Escape1: TMenuItem;
    N1: TMenuItem;
    Combinaciones1: TMenuItem;
    N2: TMenuItem;
    Msinformacin1: TMenuItem;
    AltF4Cerrarventana1: TMenuItem;
    ControlEscapeAbrirMenInicio1: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure BtnEnviarClick(Sender: TObject);
    procedure BtnEspecialesClick(Sender: TObject);
    procedure BtnInformacionClick(Sender: TObject);
    procedure Enter1Click(Sender: TObject);
    procedure Shift1Click(Sender: TObject);
    procedure Control1Click(Sender: TObject);
    procedure Alt1Click(Sender: TObject);
    procedure Retroceso1Click(Sender: TObject);
    procedure Suprimir1Click(Sender: TObject);
    procedure Escape1Click(Sender: TObject);
    procedure AltF4Cerrarventana1Click(Sender: TObject);
    procedure ControlEscapeAbrirMenInicio1Click(Sender: TObject);
    procedure Msinformacin1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    Servidor: TIdPeerThread;
    E: string;
  public
    { Public declarations }
    constructor Create(aOwner: TComponent; Socket: TIdPeerThread; Handle, Titulo: string);
  end;

var
  FormSendKeys: TFormSendKeys;

implementation

uses UnitMain;

{$R *.dfm}

constructor TFormSendKeys.Create(aOwner: TComponent; Socket: TIdPeerThread;
  Handle, Titulo: string);
begin
  inherited Create(aOwner);
  Servidor := Socket;
  EditHandle.Text := Handle;
  EditTitulo.Text := Titulo;
  E := #13#10;
end;

procedure TFormSendKeys.FormShow(Sender: TObject);
begin
  MemoSendKeys.Clear;
end;

procedure TFormSendKeys.BtnEnviarClick(Sender: TObject);
begin
  Servidor.Connection.WriteLn('SENDKEYS|' + EditHandle.Text + '|' + MemoSendKeys.Text);
  Close;
end;

procedure TFormSendKeys.BtnEspecialesClick(Sender: TObject);
begin
  PopupSendKeys.Popup(FormSendKeys.Left + BtnEspeciales.Left,
    FormSendKeys.Top + BtnEspeciales.Top);
end;

procedure TFormSendKeys.BtnInformacionClick(Sender: TObject);
begin
  MessageBox(Handle, PChar(
    'Enviar teclas envía las teclas indicadas. Soporta también teclas especiales, así:' +
    #13#10#13#10 + 'Modificadores:' + #13#10 + '+ = Shift' +
    #13#10 + '^ = Control' + #13#10 + '% = Alt' + #13#10 +
    'Rodee secuencias de caracteres o nombres de teclas con paréntesis con el fin de '
    +
    'modificarlos como un grupo. Por ejemplo, ''+abc'' "shiftea" únicamente ''a'', mientras que ''+(abc)'' "shiftea" '
    +
    'los tres caracteres.' + #13#10#13#10 +
    'Carácteres especiales:' + #13#10 + '~ = Enter' + E +
    '( = Empezar grupo modificador (ver más arriba)' + E +
    ') = Terminar grupo modificador (ver más arriba)' + E +
    '{ = Empezar nombre de tecla (ver más abajo)' + E +
    '} = Terminar nombre de tecla (ver más abajo)' + E + E +
    'Nombres de teclas (rodearlos con {}):' + E +
    'BS (Backspace), BREAK, CAPSLOCK, CLEAR, DEL, DELETE, DOWN, END, ENTER, ESC, ESCAPE, F1, F2, F3, F4, F5, F6, F7, F8, F9, F10, F11, F12, F13, F14, F15, F16, HELP, HOME, INS, LEFT, NUMLOCK, PGDN, PGUP, PRTSC, RIGHT, SCROLLLOCK, TAB, UP'), 'Información sobre enviar teclas...',
    Mb_Ok + Mb_IconInformation);
end;

procedure TFormSendKeys.Enter1Click(Sender: TObject);
begin
  MemoSendKeys.Text := MemoSendKeys.Text + '~';
end;

procedure TFormSendKeys.Shift1Click(Sender: TObject);
begin
  MemoSendKeys.Text := MemoSendKeys.Text + '+(';
end;

procedure TFormSendKeys.Control1Click(Sender: TObject);
begin
  MemoSendKeys.Text := MemoSendKeys.Text + '^(';
end;

procedure TFormSendKeys.Alt1Click(Sender: TObject);
begin
  MemoSendKeys.Text := MemoSendKeys.Text + '%(';
end;

procedure TFormSendKeys.Retroceso1Click(Sender: TObject);
begin
  MemoSendKeys.Text := MemoSendKeys.Text + '{BS}';
end;

procedure TFormSendKeys.Suprimir1Click(Sender: TObject);
begin
  MemoSendKeys.Text := MemoSendKeys.Text + '{DEL}';
end;

procedure TFormSendKeys.Escape1Click(Sender: TObject);
begin
  MemoSendKeys.Text := MemoSendKeys.Text + '{ESCAPE}';
end;

procedure TFormSendKeys.AltF4Cerrarventana1Click(Sender: TObject);
begin
  MemoSendKeys.Text := MemoSendKeys.Text + '%({F4})';
end;

procedure TFormSendKeys.ControlEscapeAbrirMenInicio1Click(Sender: TObject);
begin
  MemoSendKeys.Text := MemoSendKeys.Text + '^({ESCAPE})';
end;

procedure TFormSendKeys.Msinformacin1Click(Sender: TObject);
begin
  BtnInformacionClick(Sender);
end;

procedure TFormSendKeys.FormCreate(Sender: TObject);
begin
    UseLanguage(Formmain.idioma);
    TranslateComponent(self);
end;

end.
