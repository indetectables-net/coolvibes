Unit UnitInstalledApplications;

interface

uses
  windows;

const
  regTarget = 'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall';
  sepDos = '#2#';

function ListarApp(Clave: String): String;

implementation

function lerreg(Key:HKEY; Path:string; Value, Default: string): string;
Var
  Handle:hkey;
  RegType:integer;
  DataSize:integer;
begin
  Result := Default;
  if (RegOpenKeyEx(Key, pchar(Path), 0, KEY_QUERY_VALUE, Handle) = ERROR_SUCCESS) then
  begin
    if RegQueryValueEx(Handle, pchar(Value), nil, @RegType, nil, @DataSize) = ERROR_SUCCESS then
    begin
      SetLength(Result, Datasize);
      RegQueryValueEx(Handle, pchar(Value), nil, @RegType, PByte(pchar(Result)), @DataSize);
      SetLength(Result, Datasize - 1);
    end;
    RegCloseKey(Handle);
  end;
end;

function GetValueName(chave, valor: string): string;
begin
  try
    Result := lerreg(HKEY_LOCAL_MACHINE, pchar(chave), pchar(valor), '');
  except
    Result := '';
  end;
end;

function ToKey(Clave: String): HKEY;
begin
  if Clave = 'HKEY_CLASSES_ROOT' then
    Result := HKEY_CLASSES_ROOT
  else if Clave = 'HKEY_CURRENT_CONFIG' then
    Result := HKEY_CURRENT_CONFIG
  else if Clave = 'HKEY_CURRENT_USER' then
    Result := HKEY_CURRENT_USER
  else if Clave = 'HKEY_LOCAL_MACHINE' then
    Result := HKEY_LOCAL_MACHINE
  else if Clave = 'HKEY_USERS' then
    Result := HKEY_USERS
  else
    Result:=0;
end;

function ListarApp(Clave: String): String;
var
  phkResult: hkey;
  lpName: PChar;
  lpcbName, dwIndex: Cardinal;
  lpftLastWriteTime: FileTime;
  DispName, UninstStr, QuietUninstallStr: string;
begin
  if clave = '' then
  begin
	  Result := '';
	  exit;
  end;

  RegOpenKeyEx(ToKey(Copy(Clave, 1, Pos('\', Clave) - 1)),
               PChar(Copy(Clave, Pos('\', Clave) + 1, Length(Clave))),
               0,
               KEY_ENUMERATE_SUB_KEYS,
               phkResult);

  lpcbName := 255;
  GetMem(lpName, lpcbName);
  dwIndex := 0;

  while RegEnumKeyEx(phkResult, dwIndex, @lpName[0] , lpcbName, nil, nil, nil, @lpftLastWriteTime) = ERROR_SUCCESS do
  begin
    DispName := GetValueName(regTarget + '\' + lpname, 'DisplayName');

    if DispName <> '' then
    begin
      Result := Result + DispName + sepDos;
	    UninstStr := GetValueName(regTarget + '\' + lpname, 'UninstallString');
      QuietUninstallStr := GetValueName(regTarget + '\' + lpname, 'QuietUninstallString');
	
      if QuietUninstallStr <> '' then
        Result := Result + QuietUninstallStr + sepDos + 'S' + sepDos + #13#10
      else if UninstStr <> '' then
        Result := Result + UninstStr + sepDos + 'N' + sepDos + #13#10
	    else
        Result := Result + ' ' + sepDos + 'X' + sepDos + #13#10;
    end;
    
	Inc(dwIndex);
    lpcbName := 255;
  end;
  RegCloseKey(phkResult);
end;

end.

