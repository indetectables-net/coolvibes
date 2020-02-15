unit ScreenMaxCap;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, IdTCPServer, Menus, gnugettext, ComCtrls;

type
  TScreenMax = class(TForm)
    ImgCaptura: TImage;
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
    Servidor:     TIdPeerThread;
    MyFormControl : TObject;
    Proportional : boolean;
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
  Servidor     := Serv;
  ImgCaptura.Picture := picture;
  MyFormControl := FC;
  self.Caption := self.Caption +'  '+ (MyFormControl as TFormControl).MyItem.caption;
  proportional := true;
end;

procedure TScreenMax.FormCanResize(Sender: TObject; var NewWidth,
  NewHeight: Integer; var Resize: Boolean);
begin            //seguimos la proporción
  if(proportional)then
    if ((MyFormControl as TFormControl).alturapantalla <> 0) then
      Newwidth := (NewHeight*(MyFormControl as TFormControl).anchurapantalla div (MyFormControl as TFormControl).alturapantalla);
end;

procedure TScreenMax.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  (MyFormControl as TFormControl).CheckBoxAutoCapturaScreen.checked := false;
  (MyFormControl as TFormControl).FormVisorCaptura := nil;
  self.Destroy;
end;

procedure TScreenMax.Capturar1Click(Sender: TObject);
begin
  (MyFormControl as TFormControl).BtnCapturarScreen.click;
end;

procedure TScreenMax.NoClick(Sender: TObject); //Desactiva el automatico
begin
  (MyFormControl as TFormControl).CheckBoxAutoCapturaScreen.checked := false;
end;

procedure TScreenMax.T0Click(Sender: TObject);//Establece el intervalo
begin
  (MyFormControl as TFormControl).SpinCaptureScreen.value := strtointdef(copy((sender as Tmenuitem).Name,2,2),2);
  (MyFormControl as TFormControl).CheckBoxAutoCapturaScreen.checked := true;
end;

procedure TScreenMax.N10Click(Sender: TObject);
begin
  (MyFormControl as TFormControl).trackbarcalidad.position := strtointdef(copy((Sender as Tmenuitem).name,2,3),0);
end;

procedure TScreenMax.ImgCapturaContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
var
  auto : integer;
  Calidad : integer;
  i : integer;
begin
  Automtico1.checked := (MyFormControl as TFormControl).CheckBoxAutoCapturaScreen.checked;
  No.checked := not Automtico1.checked;
  auto := (MyFormControl as TFormControl).SpinCaptureScreen.value;
  calidad := (MyFormControl as TFormControl).TrackBarCalidad.Position;

  T0.Checked := false;
  T1.Checked := false;
  T2.Checked := false;
  T5.Checked := false;
  T10.Checked := false;
  T30.Checked := false;

  if not No.Checked then
    case auto of
      0  :  T0.Checked := true;
      1  :  T1.Checked := true;
      2  :  T2.Checked := true;
      5  :  T5.Checked := true;
      10 :  T10.Checked := true;
      30 :  T30.Checked := true;
    end;


  N10.Checked  := false;
  N20.Checked  := false;
  N30.Checked  := false;
  N40.Checked  := false;
  N50.Checked  := false;
  N60.Checked  := false;
  N70.Checked  := false;
  N80.Checked  := false;
  N90.Checked  := false;
  N100.Checked := false;
  case calidad of
    10  : N10.Checked  := true;
    20  : N20.Checked  := true;
    30  : N30.Checked  := true;
    40  : N40.Checked  := true;
    50  : N50.Checked  := true;
    60  : N60.Checked  := true;
    70  : N70.Checked  := true;
    80  : N80.Checked  := true;
    90  : N90.Checked  := true;
    100 : N100.Checked  := true;
  end;


end;

procedure TScreenMax.TR100Click(Sender: TObject); //Establece transparencia
begin
  self.AlphaBlendValue := strtointdef(copy((sender as Tmenuitem).Name,3,3),255);
end;

procedure TScreenMax.Siempreencima1Click(Sender: TObject);
begin
  Siempreencima1.Checked := not Siempreencima1.Checked;
  
  if(Siempreencima1.Checked) then
    self.FormStyle := fsStayOnTop
  else
    self.FormStyle := fsNormal;
end;

procedure TScreenMax.FormCreate(Sender: TObject);
begin
  UseLanguage(Formmain.idioma);
  TranslateComponent(self);
  self.DoubleBuffered := true;  //Evita parpadeos
end;

procedure TScreenMax.vpClick(Sender: TObject);
begin
  (Sender as Tmenuitem).checked := not (Sender as Tmenuitem).checked;
  Proportional := (Sender as Tmenuitem).checked;
end;

end.
