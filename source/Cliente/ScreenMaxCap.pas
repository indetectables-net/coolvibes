unit ScreenMaxCap;

interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, Forms,
  ExtCtrls, IdTCPServer, Menus, gnugettext, ComCtrls;

type
  TScreenMax = class(TForm)
    PopupMenu1: TPopupMenu;
    Capturar1: TMenuItem;
    Automtico1: TMenuItem;
    N1: TMenuItem;
    T0: TMenuItem;
    T1: TMenuItem;
    T2: TMenuItem;
    T5: TMenuItem;
    T10: TMenuItem;
    T30: TMenuItem;
    Calidad1: TMenuItem;
    N10: TMenuItem;
    N20: TMenuItem;
    N30: TMenuItem;
    N40: TMenuItem;
    N50: TMenuItem;
    N60: TMenuItem;
    N70: TMenuItem;
    N80: TMenuItem;
    N90: TMenuItem;
    N100: TMenuItem;
    none: TMenuItem;
    No: TMenuItem;
    ransparente1: TMenuItem;
    TR100: TMenuItem;
    TR150: TMenuItem;
    TR200: TMenuItem;
    TR255: TMenuItem;
    Siempreencima1: TMenuItem;
    ProgressBar: TProgressBar;
    vp: TMenuItem;
    ScrollBox1: TScrollBox;
    ImgCaptura: TImage;
    procedure FormCanResize(Sender: TObject; var NewWidth,
      NewHeight: Integer; var Resize: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Capturar1Click(Sender: TObject);
    procedure NoClick(Sender: TObject);
    procedure T0Click(Sender: TObject);
    procedure N10Click(Sender: TObject);
    procedure ImgCapturaContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure TR100Click(Sender: TObject);
    procedure Siempreencima1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure vpClick(Sender: TObject);
  private
    { Private declarations }
  public
    Servidor: TIdPeerThread;
    MyFormControl: TObject;
    Proportional: Boolean;
    constructor Create(aOwner: TComponent; Picture: TPicture;
      Serv: TIdPeerThread; FC: TObject);
    { Public declarations }
  end;

var
  ScreenMax: TScreenMax;

implementation
uses UnitFormControl, UnitMain;
{$R *.dfm}

constructor TScreenMax.Create(aOwner: TComponent; Picture: TPicture;
  Serv: TIdPeerThread; FC: TObject);
begin
  inherited Create(aOwner);
  Servidor := Serv;
  ImgCaptura.Picture := picture;
  MyFormControl := FC;
  Self.Caption := Self.Caption + '  ' + (MyFormControl as TFormControl).MyItem.Caption;
  proportional := True;
end;

procedure TScreenMax.FormCanResize(Sender: TObject; var NewWidth,
  NewHeight: Integer; var Resize: Boolean);
begin //Seguimos la proporción
  if (proportional) then
    if ((MyFormControl as TFormControl).alturapantalla <> 0) then
      Newwidth := (NewHeight * (MyFormControl as TFormControl).anchurapantalla div (MyFormControl as TFormControl).alturapantalla);
end;

procedure TScreenMax.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  (MyFormControl as TFormControl).CheckBoxAutoCapturaScreen.Checked := False;
  (MyFormControl as TFormControl).FormVisorCaptura := nil;
  Self.Destroy;
end;

procedure TScreenMax.Capturar1Click(Sender: TObject);
begin
  (MyFormControl as TFormControl).BtnCapturarScreen.Click;
end;

procedure TScreenMax.NoClick(Sender: TObject); //Desactiva el automatico
begin
  (MyFormControl as TFormControl).CheckBoxAutoCapturaScreen.Checked := False;
end;

procedure TScreenMax.T0Click(Sender: TObject); //Establece el intervalo
begin
  (MyFormControl as TFormControl).SpinCaptureScreen.Value := StrToIntDef(Copy((Sender as TMenuItem).Name, 2, 2), 2);
  (MyFormControl as TFormControl).CheckBoxAutoCapturaScreen.Checked := True;
end;

procedure TScreenMax.N10Click(Sender: TObject);
begin
  (MyFormControl as TFormControl).trackbarcalidad.Position := StrToIntDef(Copy((Sender as TMenuItem).Name, 2, 3), 0);
end;

procedure TScreenMax.ImgCapturaContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
var
  auto: Integer;
  Calidad: Integer;
  i: Integer;
begin
  Automtico1.Checked := (MyFormControl as TFormControl).CheckBoxAutoCapturaScreen.Checked;
  No.Checked := not Automtico1.Checked;
  auto := (MyFormControl as TFormControl).SpinCaptureScreen.Value;
  calidad := (MyFormControl as TFormControl).TrackBarCalidad.Position;

  T0.Checked := False;
  T1.Checked := False;
  T2.Checked := False;
  T5.Checked := False;
  T10.Checked := False;
  T30.Checked := False;

  if not No.Checked then
    case auto of
      0: T0.Checked := True;
      1: T1.Checked := True;
      2: T2.Checked := True;
      5: T5.Checked := True;
      10: T10.Checked := True;
      30: T30.Checked := True;
    end;

  N10.Checked := False;
  N20.Checked := False;
  N30.Checked := False;
  N40.Checked := False;
  N50.Checked := False;
  N60.Checked := False;
  N70.Checked := False;
  N80.Checked := False;
  N90.Checked := False;
  N100.Checked := False;
  case calidad of
    10: N10.Checked := True;
    20: N20.Checked := True;
    30: N30.Checked := True;
    40: N40.Checked := True;
    50: N50.Checked := True;
    60: N60.Checked := True;
    70: N70.Checked := True;
    80: N80.Checked := True;
    90: N90.Checked := True;
    100: N100.Checked := True;
  end;

end;

procedure TScreenMax.TR100Click(Sender: TObject); //Establece transparencia
begin
  Self.AlphaBlendValue := StrToIntDef(Copy((Sender as TMenuItem).Name, 3, 3), 255);
end;

procedure TScreenMax.Siempreencima1Click(Sender: TObject);
begin
  Siempreencima1.Checked := not Siempreencima1.Checked;

  if (Siempreencima1.Checked) then
    Self.FormStyle := fsStayOnTop
  else
    Self.FormStyle := fsNormal;
end;

procedure TScreenMax.FormCreate(Sender: TObject);
begin
  UseLanguage(Formmain.idioma);
  TranslateComponent(Self);
  Self.DoubleBuffered := True; //Evita parpadeos
  Self.Position := poDesktopCenter; //Posición predeterminada
end;

procedure TScreenMax.vpClick(Sender: TObject);
begin
  (Sender as TMenuItem).Checked := not (Sender as TMenuItem).Checked;
  Proportional := (Sender as TMenuItem).Checked;
end;

end.
