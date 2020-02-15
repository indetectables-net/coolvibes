unit ScreenMaxCap;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, IdTCPServer, Menus;

type
  TScreenMax = class(TForm)
    ImgCaptura: TImage;
    PopupMenu1: TPopupMenu;
    Capturar1: TMenuItem;
    Automtico1: TMenuItem;
    N1: TMenuItem;
    N0s1: TMenuItem;
    N1s1: TMenuItem;
    N2s1: TMenuItem;
    N5s1: TMenuItem;
    N10s1: TMenuItem;
    N30s1: TMenuItem;
    Calidad1: TMenuItem;
    N101: TMenuItem;
    N201: TMenuItem;
    N301: TMenuItem;
    N61: TMenuItem;
    N71: TMenuItem;
    N601: TMenuItem;
    N701: TMenuItem;
    N801: TMenuItem;
    N901: TMenuItem;
    N1001: TMenuItem;
    N2: TMenuItem;
    No1: TMenuItem;
    ransparente1: TMenuItem;
    N1002: TMenuItem;
    N1501: TMenuItem;
    N2001: TMenuItem;
    No2: TMenuItem;
    Siempreencima1: TMenuItem;
    procedure FormCanResize(Sender: TObject; var NewWidth,
      NewHeight: Integer; var Resize: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Capturar1Click(Sender: TObject);
    procedure No1Click(Sender: TObject);
    procedure N0s1Click(Sender: TObject);
    procedure N1s1Click(Sender: TObject);
    procedure N2s1Click(Sender: TObject);
    procedure N5s1Click(Sender: TObject);
    procedure N10s1Click(Sender: TObject);
    procedure N30s1Click(Sender: TObject);
    procedure N101Click(Sender: TObject);
    procedure N201Click(Sender: TObject);
    procedure N301Click(Sender: TObject);
    procedure N61Click(Sender: TObject);
    procedure N71Click(Sender: TObject);
    procedure N601Click(Sender: TObject);
    procedure N701Click(Sender: TObject);
    procedure N801Click(Sender: TObject);
    procedure N901Click(Sender: TObject);
    procedure N1001Click(Sender: TObject);
    procedure ImgCapturaContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure N1002Click(Sender: TObject);
    procedure N1501Click(Sender: TObject);
    procedure N2001Click(Sender: TObject);
    procedure No2Click(Sender: TObject);
    procedure Siempreencima1Click(Sender: TObject);
  private
    { Private declarations }
  public
    Servidor:     TIdPeerThread;
    MyFormControl : TObject;
    constructor Create(aOwner: TComponent; Picture: TPicture;
  Serv: TIdPeerThread; FC: TObject);
    { Public declarations }
  end;

var
  ScreenMax: TScreenMax;

implementation
uses UnitFormControl;
{$R *.dfm}

constructor TScreenMax.Create(aOwner: TComponent; Picture: TPicture;
  Serv: TIdPeerThread; FC: TObject);
begin
  inherited Create(aOwner);
  Servidor     := Serv;
  ImgCaptura.Picture := picture;
  MyFormControl := FC;
end;

procedure TScreenMax.FormCanResize(Sender: TObject; var NewWidth,
  NewHeight: Integer; var Resize: Boolean);
  var
  i,o:integer;
begin            //seguimos la proporción
  i := self.Width - imgcaptura.width;
  o := self.Height - imgcaptura.height;
  
  Newwidth := ((NewHeight-o)*(MyFormControl as TFormControl).anchurapantalla div (MyFormControl as TFormControl).alturapantalla)+i;
end;

procedure TScreenMax.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  (MyFormControl as TFormControl).FormVisorCaptura := nil;
  self.Destroy;
end;

procedure TScreenMax.Capturar1Click(Sender: TObject);
begin
  (MyFormControl as TFormControl).BtnCapturarScreen.click;
end;

procedure TScreenMax.No1Click(Sender: TObject);
begin
(MyFormControl as TFormControl).CheckBoxAutoCapturaScreen.checked := false;
end;

procedure TScreenMax.N0s1Click(Sender: TObject);
begin
(MyFormControl as TFormControl).SpinCaptureScreen.value := 0;
(MyFormControl as TFormControl).CheckBoxAutoCapturaScreen.checked := true;
end;

procedure TScreenMax.N1s1Click(Sender: TObject);
begin
(MyFormControl as TFormControl).SpinCaptureScreen.value := 1;
(MyFormControl as TFormControl).CheckBoxAutoCapturaScreen.checked := true;
end;

procedure TScreenMax.N2s1Click(Sender: TObject);
begin
(MyFormControl as TFormControl).SpinCaptureScreen.value := 2;
(MyFormControl as TFormControl).CheckBoxAutoCapturaScreen.checked := true;
end;

procedure TScreenMax.N5s1Click(Sender: TObject);
begin
(MyFormControl as TFormControl).SpinCaptureScreen.value := 5;
(MyFormControl as TFormControl).CheckBoxAutoCapturaScreen.checked := true;
end;

procedure TScreenMax.N10s1Click(Sender: TObject);
begin
(MyFormControl as TFormControl).SpinCaptureScreen.value := 10;
(MyFormControl as TFormControl).CheckBoxAutoCapturaScreen.checked := true;
end;

procedure TScreenMax.N30s1Click(Sender: TObject);
begin
(MyFormControl as TFormControl).SpinCaptureScreen.value := 30;
(MyFormControl as TFormControl).CheckBoxAutoCapturaScreen.checked := true;
end;

procedure TScreenMax.N101Click(Sender: TObject);
begin
(MyFormControl as TFormControl).trackbarcalidad.position := 10;
end;

procedure TScreenMax.N201Click(Sender: TObject);
begin
(MyFormControl as TFormControl).trackbarcalidad.position := 20;
end;

procedure TScreenMax.N301Click(Sender: TObject);
begin
(MyFormControl as TFormControl).trackbarcalidad.position := 30;
end;

procedure TScreenMax.N61Click(Sender: TObject);
begin
(MyFormControl as TFormControl).trackbarcalidad.position := 40;
end;

procedure TScreenMax.N71Click(Sender: TObject);
begin
(MyFormControl as TFormControl).trackbarcalidad.position := 50;
end;

procedure TScreenMax.N601Click(Sender: TObject);
begin
(MyFormControl as TFormControl).trackbarcalidad.position := 60;
end;

procedure TScreenMax.N701Click(Sender: TObject);
begin
(MyFormControl as TFormControl).trackbarcalidad.position := 70;
end;

procedure TScreenMax.N801Click(Sender: TObject);
begin
(MyFormControl as TFormControl).trackbarcalidad.position := 80;
end;

procedure TScreenMax.N901Click(Sender: TObject);
begin
(MyFormControl as TFormControl).trackbarcalidad.position := 90;
end;

procedure TScreenMax.N1001Click(Sender: TObject);
begin
(MyFormControl as TFormControl).trackbarcalidad.position := 100;
end;

procedure TScreenMax.ImgCapturaContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
var
  auto : integer;
begin
  Automtico1.checked := (MyFormControl as TFormControl).CheckBoxAutoCapturaScreen.checked;
  No1.checked := not Automtico1.checked;
  auto := (MyFormControl as TFormControl).SpinCaptureScreen.value;

  N0S1.checked := false;
  N1S1.checked := false;
  N2S1.checked := false;
  N5S1.checked := false;
  N10S1.checked := false;
  N30S1.checked := false;
  
  if auto = 0 then
    N0S1.checked := true
  else
    N0S1.checked := false;
  if auto = 1 then
    N1S1.checked := true
  else
    N1S1.checked := false;
  if auto = 2 then
    N2S1.checked := true
  else
    N2S1.checked := false;
  if auto = 5 then
    N5S1.checked := true
  else
    N5S1.checked := false;
  if auto = 10 then
    N10S1.checked := true
  else
    N10S1.checked := false;
  if auto = 30 then
    N30S1.checked := true
  else
    N30S1.checked := false;

end;

procedure TScreenMax.N1002Click(Sender: TObject);
begin
  self.AlphaBlendValue := 100;
end;

procedure TScreenMax.N1501Click(Sender: TObject);
begin
self.AlphaBlendValue := 150;
end;

procedure TScreenMax.N2001Click(Sender: TObject);
begin
  self.AlphaBlendValue := 200;
end;

procedure TScreenMax.No2Click(Sender: TObject);
begin
  self.AlphaBlendValue := 255;
end;

procedure TScreenMax.Siempreencima1Click(Sender: TObject);
begin
  Siempreencima1.Checked := not Siempreencima1.Checked;

  if(Siempreencima1.Checked) then
    self.FormStyle := fsStayOnTop
  else
    self.FormStyle := fsNormal;
end;

end.
