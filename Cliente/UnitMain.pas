unit UnitMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, XPMan, ScktComp, ComCtrls, Buttons, StdCtrls, ImgList,
  Menus,
  UnitFormControl, jpeg;

type
  TFormMain = class(TForm)
    ListViewConexiones: TListView;
    StatusBar: TStatusBar;
    ServerSocket: TServerSocket;
    XPManifest: TXPManifest;
    ImageTitulo: TImage;
    BtnEscuchar: TSpeedButton;
    PopupMenuConexiones: TPopupMenu;
    Abrir1: TMenuItem;
    N1: TMenuItem;
    Ping1: TMenuItem;
    Cambiarnombre1: TMenuItem;
    ImageList: TImageList;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Image1: TImage;
    SpeedButton3: TSpeedButton;
    procedure BtnEscucharClick(Sender: TObject);
    procedure ServerSocketClientConnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ServerSocketClientDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ServerSocketClientError(Sender: TObject;
      Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
      var ErrorCode: Integer);
    procedure ListViewConexionesContextPopup(Sender: TObject;
      MousePos: TPoint; var Handled: Boolean);
    procedure Abrir1Click(Sender: TObject);
    procedure ServerSocketClientRead(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure Cambiarnombre1Click(Sender: TObject);
    procedure Ping1Click(Sender: TObject);

  private
    { Private declarations }
  public
    procedure EliminarConexion(Socket: TCustomWinSocket);
    { Public declarations }
  end;

var
  FormMain: TFormMain;

implementation

uses UnitOpciones, UnitAbout;

{$R *.dfm}

procedure TFormMain.BtnEscucharClick(Sender: TObject);
begin
  if BtnEscuchar.Caption = 'Escuchar' then
  begin
    try
      ServerSocket.Port := StrToInt(FormOpciones.EditPuerto.Text);
      ServerSocket.Open;
      FormOpciones.EditPuerto.Enabled := False;
      BtnEscuchar.Caption := 'Detener';
      StatusBar.Panels[0].Text := 'Esperando conexiones';
    except
      MessageDlg('El puerto ' + FormOpciones.EditPuerto.Text + ' ya está en uso o hay un firewall bloqueandolo, elija otro', mtWarning, [mbok], 0);
    end;
  end
  else
  begin
    ServerSocket.Close;
    ListViewConexiones.Clear;
    FormOpciones.EditPuerto.Enabled := True;
    BtnEscuchar.Caption := 'Escuchar';
    StatusBar.Panels[0].Text := 'Escucha detenida';
  end;
end;

procedure TFormMain.ServerSocketClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
var
  item: TlistItem;
  NuevaVentanaControl: TFormControl;
begin
  item := ListViewConexiones.Items.Add;
  item.Caption := Socket.RemoteAddress;
  item.SubItems.Add(' ');
  item.SubItems.Add(' ');
  item.SubItems.Add(' ');
  item.SubItems.Add(' ');
  item.SubItems.Add(' ');
  NuevaVentanaControl := TFormControl.Create(self, socket);
  //Para identificar esta conexión usaremos el Socket.Handle que lo guardaremos
  //como un objeto SubItems.Objects[0]
  item.SubItems.Objects[0] := TObject(Socket.Handle);
  //Guardamos tmb la ventana para ponder mostrarla
  item.SubItems.Objects[1] := NuevaVentanaControl;
  //Enviando esto recibimos del server la información para mostrar en el ListView IP-Nombre-CPU-SO-VER
  Socket.SendText('MAININFO');
end;

//Buscamos y eliminamos el socket que se ha desconectado en el listview
procedure TFormMain.EliminarConexion(Socket: TCustomWinSocket);
var
  i: integer;
begin
  //Buscamos y eliminamos el item del ListView
  for i := 0 to ListViewConexiones.Items.Count - 1 do
    if Socket.Handle = HWND(ListViewConexiones.Items[i].SubItems.Objects[0]) then
    begin
      //Cerramos la ventana que tenga asignada , si la tiene
      if ListViewConexiones.Items[i].SubItems.Objects[1] <> nil then
        (ListViewConexiones.Items[i].SubItems.Objects[1] as TFormControl).Close;
      ListViewConexiones.Items[i].Delete;
    end;
end;

procedure TFormMain.ServerSocketClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  EliminarConexion(Socket);
end;

procedure TFormMain.ServerSocketClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  EliminarConexion(Socket);
  ErrorCode := 0;
end;

procedure TFormMain.ListViewConexionesContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
begin
  if ListViewConexiones.Selected = nil then //No se ha seleccionado item, deshabilitar menu
  begin
    PopupMenuConexiones.Items[0].Enabled := False;
    PopupMenuConexiones.Items[2].Enabled := False;
    PopupMenuConexiones.Items[3].Enabled := False;
  end
  else
  begin
    PopupMenuConexiones.Items[0].Enabled := True;
    PopupMenuConexiones.Items[2].Enabled := True;
    PopupMenuConexiones.Items[3].Enabled := True;
  end;
end;

//Al dar al boton abrir
procedure TFormMain.Abrir1Click(Sender: TObject);
begin
  if ListViewConexiones.Selected <> nil then
    (ListViewConexiones.Selected.SubItems.Objects[1] as TFormControl).Show;
end;

procedure TFormMain.ServerSocketClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
var
  i: integer;
  item: TListItem;
  Recibido: String;
begin
  //Buscamos a que item corresponde la conexión
  for i := 0 to ListViewConexiones.Items.Count - 1 do
    if Socket.Handle = HWND(ListViewConexiones.Items[i].SubItems.Objects[0]) then
    begin
      item := ListViewConexiones.Items[i];
      //Enviarle la conexión a la ventana de ese item, si la tiene
      if item.SubItems.Objects[1] <> nil then
        (item.SubItems.Objects[1] as TFormControl).OnRead(Socket);
    end;
end;

procedure TFormMain.SpeedButton1Click(Sender: TObject);
begin
  FormOpciones.ShowModal();
end;

procedure TFormMain.SpeedButton2Click(Sender: TObject);
begin
  FormAbout.ShowModal;
end;

procedure TFormMain.Cambiarnombre1Click(Sender: TObject);
begin
  MessageDlg('Lo siento, esta opción no está implementada', mtInformation, [mbok], 0);
end;

procedure TFormMain.Ping1Click(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to ServerSocket.Socket.ActiveConnections -1 do
    if ServerSocket.Socket.Connections[i].Handle = HWND(ListViewConexiones.Selected.SubItems.Objects[0]) then
    begin
      ServerSocket.Socket.Connections[i].SendText('PING');
      //Como objeto 2 guardamos una captura dle tiempo en milisegundo
      ListViewConexiones.Selected.SubItems.Objects[2] := TObject(GetTickCount());
    end;
end;



end.
