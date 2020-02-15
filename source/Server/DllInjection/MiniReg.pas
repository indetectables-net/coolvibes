unit MiniReg;

{
  lightweight replacement for TRegistry. Does not use Classes or SysUtils. Intended
  for space-limited applets where only the commonly used functions are necessary.
  Returns True if Successful, else False.

  Written by Ben Hochstrasser (bhoc@surfeu.ch).
  This code is GPL.

  Function Examples:

  procedure TForm1.Button1Click(Sender: TObject);
  var
    ba1, ba2: array of byte;
    n: integer;
    s: String;
    d: Cardinal;
  begin
    setlength(ba1, 10);
    for n := 0 to 9 do ba1[n] := byte(n);

    RegSetString(HKEY_CURRENT_USER, 'Software\My Company\Test\foo\bar\TestString', 'TestMe');
    RegSetExpandString(HKEY_CURRENT_USER, 'Software\My Company\Test\foo\bar\TestExpandString', '%SystemRoot%\Test');
    RegSetMultiString(HKEY_CURRENT_USER, 'Software\My Company\Test\foo\bar\TestMultiString', 'String1'#0'String2'#0'String3');
    RegSetDword(HKEY_CURRENT_USER, 'Software\My Company\Test\foo\bar\TestDword', 7);
    RegSetBinary(HKEY_CURRENT_USER, 'Software\My Company\Test\foo\bar\TestBinary', ba1);

    To set the default value for a key, end the key name with a '\':
    RegSetString(HKEY_CURRENT_USER, 'Software\My Company\Test\', 'Default Value');
    RegGetString(HKEY_CURRENT_USER, 'Software\My Company\Test\foo\bar\TestString', s);
    RegGetMultiString(HKEY_CURRENT_USER, 'Software\My Company\Test\foo\bar\TestMultiString', s);
    RegGetExpandString(HKEY_CURRENT_USER, 'Software\My Company\Test\foo\bar\TestExpandString', s);
    RegGetAnyString(HKEY_CURRENT_USER, 'Software\My Company\Test\foo\bar\TestMultiString', s, StringType);
    RegSetAnyString(HKEY_CURRENT_USER, 'Software\My Company\Test\foo\bar\TestMultiString', s, StringType);
    RegGetDWORD(HKEY_CURRENT_USER, 'Software\My Company\Test\foo\bar\TestDword', d);
    RegGetBinary(HKEY_CURRENT_USER, 'Software\My Company\Test\foo\bar\TestBinary', s);
    SetLength(ba2, Length(s));
    for n := 1 to Length(s) do ba2[n-1] := byte(s[n]);
    Button1.Caption := IntToStr(Length(ba2));

    if RegKeyExists(HKEY_CURRENT_USER, 'Software\My Company\Test\foo') then
      if RegValueExists(HKEY_CURRENT_USER, 'Software\My Company\Test\foo\bar\TestBinary') then
        MessageBox(GetActiveWindow, 'OK', 'OK', MB_OK);
    RegDelValue(HKEY_CURRENT_USER, 'Software\My Company\Test\foo\bar\TestString');
    RegDelKey(HKEY_CURRENT_USER, 'Software\My Company\Test\foo\bar');
    RegDelKey(HKEY_CURRENT_USER, 'Software\My Company\Test\foo');
    RegDelKey(HKEY_CURRENT_USER, 'Software\My Company\Test');
    RegDelKey(HKEY_CURRENT_USER, 'Software\My Company');
    if RegEnumKeys(HKEY_CURRENT_USER, 'Software\My Company', s) then
      ListBox1.Text := s;
    if RegEnumValues(HKEY_CURRENT_USER, 'Software\My Company', s) then
      ListBox1.Text := s;
    if RegConnect('\\server1', HKEY_LOCAL_MACHINE, RemoteKey) then
    begin
      RegGetString(RemoteKey, 'Software\My Company\Test\foo\bar\TestString', s);
      RegDisconnect(RemoteKey);
    end;
  end;
}

interface

uses Windows;

function RegSetString(RootKey: HKEY; Name: string; Value: string): boolean;
function RegSetMultiString(RootKey: HKEY; Name: string; Value: string): boolean;
function RegSetExpandString(RootKey: HKEY; Name: string; Value: string): boolean;
function RegSetDWORD(RootKey: HKEY; Name: string; Value: cardinal): boolean;
function RegSetBinary(RootKey: HKEY; Name: string; Value: array of byte): boolean;
function RegGetString(RootKey: HKEY; Name: string; var Value: string): boolean;
function RegGetMultiString(RootKey: HKEY; Name: string; var Value: string): boolean;
function RegGetExpandString(RootKey: HKEY; Name: string; var Value: string): boolean;
function RegGetAnyString(RootKey: HKEY; Name: string; var Value: string;
  var ValueType: cardinal): boolean;
function RegSetAnyString(RootKey: HKEY; Name: string; Value: string;
  ValueType: cardinal): boolean;
function RegGetDWORD(RootKey: HKEY; Name: string; var Value: cardinal): boolean;
function RegGetBinary(RootKey: HKEY; Name: string; var Value: string): boolean;
function RegGetValueType(RootKey: HKEY; Name: string; var Value: cardinal): boolean;
function RegValueExists(RootKey: HKEY; Name: string): boolean;
function RegKeyExists(RootKey: HKEY; Name: string): boolean;
function RegConnect(MachineName: string; RootKey: HKEY; var RemoteKey: HKEY): boolean;
function RegDisconnect(RemoteKey: HKEY): boolean;


implementation

function LastPos(Needle: char; Haystack: string): integer;
begin
  for Result := Length(Haystack) downto 1 do
    if Haystack[Result] = Needle then
      Break;
end;

function RegConnect(MachineName: string; RootKey: HKEY; var RemoteKey: HKEY): boolean;
begin
  Result := (RegConnectRegistry(PChar(MachineName), RootKey, RemoteKey) = ERROR_SUCCESS);
end;

function RegDisconnect(RemoteKey: HKEY): boolean;
begin
  Result := (RegCloseKey(RemoteKey) = ERROR_SUCCESS);
end;

function RegSetValue(RootKey: HKEY; Name: string; ValType: cardinal;
  PVal: Pointer; ValSize: cardinal): boolean;
var
  SubKey: string;
  n:      integer;
  dispo:  DWORD;
  hTemp:  HKEY;
begin
  Result := False;
  n      := LastPos('\', Name);
  if n > 0 then
  begin
    SubKey := Copy(Name, 1, n - 1);
    if RegCreateKeyEx(RootKey, PChar(SubKey), 0, nil, REG_OPTION_NON_VOLATILE,
      KEY_WRITE, nil, hTemp, @dispo) = ERROR_SUCCESS then
    begin
      SubKey := Copy(Name, n + 1, Length(Name) - n);
      if SubKey = '' then
        Result := (RegSetValueEx(hTemp, nil, 0, ValType, PVal, ValSize) = ERROR_SUCCESS)
      else
        Result := (RegSetValueEx(hTemp, PChar(SubKey), 0, ValType, PVal, ValSize) =
          ERROR_SUCCESS);
      RegCloseKey(hTemp);
    end;
  end;
end;

function RegGetValue(RootKey: HKEY; Name: string; ValType: cardinal;
  var PVal: Pointer; var ValSize: cardinal): boolean;
var
  SubKey: string;
  n:      integer;
  MyValType: DWORD;
  hTemp:  HKEY;
  Buf:    Pointer;
  BufSize: cardinal;
  PKey:   PChar;
begin
  Result := False;
  n      := LastPos('\', Name);
  if n > 0 then
  begin
    SubKey := Copy(Name, 1, n - 1);
    if RegOpenKeyEx(RootKey, PChar(SubKey), 0, KEY_READ, hTemp) = ERROR_SUCCESS then
    begin
      SubKey := Copy(Name, n + 1, Length(Name) - n);
      if SubKey = '' then
        PKey := nil
      else
        PKey := PChar(SubKey);
      if RegQueryValueEx(hTemp, PKey, nil, @MyValType, nil, @BufSize) =
        ERROR_SUCCESS then
      begin
        GetMem(Buf, BufSize);
        if RegQueryValueEx(hTemp, PKey, nil, @MyValType, Buf, @BufSize) =
          ERROR_SUCCESS then
        begin
          if ValType = MyValType then
          begin
            PVal    := Buf;
            ValSize := BufSize;
            Result  := True;
          end
          else
          begin
            FreeMem(Buf);
          end;
        end
        else
        begin
          FreeMem(Buf);
        end;
      end;
      RegCloseKey(hTemp);
    end;
  end;
end;

function RegSetAnyString(RootKey: HKEY; Name: string; Value: string;
  ValueType: cardinal): boolean;
begin
  case ValueType of
    REG_SZ, REG_EXPAND_SZ:
      Result := RegSetValue(RootKey, Name, ValueType, PChar(Value + #0),
        Length(Value) + 1);
    Reg_MULTI_SZ:
      Result := RegSetValue(RootKey, Name, ValueType, PChar(Value + #0#0),
        Length(Value) + 2);
    else
      Result := False;
  end;
end;

function RegSetString(RootKey: HKEY; Name: string; Value: string): boolean;
begin
  Result := RegSetValue(RootKey, Name, REG_SZ, PChar(Value + #0), Length(Value) + 1);
end;

function RegSetMultiString(RootKey: HKEY; Name: string; Value: string): boolean;
begin
  Result := RegSetValue(RootKey, Name, REG_MULTI_SZ, PChar(Value + #0#0),
    Length(Value) + 2);
end;

function RegSetExpandString(RootKey: HKEY; Name: string; Value: string): boolean;
begin
  Result := RegSetValue(RootKey, Name, REG_EXPAND_SZ, PChar(Value + #0),
    Length(Value) + 1);
end;

function RegSetDword(RootKey: HKEY; Name: string; Value: cardinal): boolean;
begin
  Result := RegSetValue(RootKey, Name, REG_DWORD, @Value, SizeOf(cardinal));
end;

function RegSetBinary(RootKey: HKEY; Name: string; Value: array of byte): boolean;
begin
  Result := RegSetValue(RootKey, Name, REG_BINARY, @Value[Low(Value)], length(Value));
end;

function RegGetString(RootKey: HKEY; Name: string; var Value: string): boolean;
var
  Buf:     Pointer;
  BufSize: cardinal;
begin
  Result := False;
  Value  := '';
  if RegGetValue(RootKey, Name, REG_SZ, Buf, BufSize) then
  begin
    Dec(BufSize);
    SetLength(Value, BufSize);
    if BufSize > 0 then
      Move(Buf^, Value[1], BufSize);
    FreeMem(Buf);
    Result := True;
  end;
end;

function RegGetMultiString(RootKey: HKEY; Name: string; var Value: string): boolean;
var
  Buf:     Pointer;
  BufSize: cardinal;
begin
  Result := False;
  Value  := '';
  if RegGetValue(RootKey, Name, REG_MULTI_SZ, Buf, BufSize) then
  begin
    Dec(BufSize);
    SetLength(Value, BufSize);
    if BufSize > 0 then
      Move(Buf^, Value[1], BufSize);
    FreeMem(Buf);
    Result := True;
  end;
end;

function RegGetExpandString(RootKey: HKEY; Name: string; var Value: string): boolean;
var
  Buf:     Pointer;
  BufSize: cardinal;
begin
  Result := False;
  Value  := '';
  if RegGetValue(RootKey, Name, REG_EXPAND_SZ, Buf, BufSize) then
  begin
    Dec(BufSize);
    SetLength(Value, BufSize);
    if BufSize > 0 then
      Move(Buf^, Value[1], BufSize);
    FreeMem(Buf);
    Result := True;
  end;
end;

function RegGetAnyString(RootKey: HKEY; Name: string; var Value: string;
  var ValueType: cardinal): boolean;
var
  Buf:     Pointer;
  BufSize: cardinal;
  bOK:     boolean;
begin
  Result := False;
  Value  := '';
  if RegGetValueType(Rootkey, Name, ValueType) then
  begin
    case ValueType of
      REG_SZ, REG_EXPAND_SZ, REG_MULTI_SZ:
        bOK := RegGetValue(RootKey, Name, ValueType, Buf, BufSize);
      else
        bOK := False;
    end;
    if bOK then
    begin
      Dec(BufSize);
      SetLength(Value, BufSize);
      if BufSize > 0 then
        Move(Buf^, Value[1], BufSize);
      FreeMem(Buf);
      Result := True;
    end;
  end;
end;

function RegGetDWORD(RootKey: HKEY; Name: string; var Value: cardinal): boolean;
var
  Buf:     Pointer;
  BufSize: cardinal;
begin
  Result := False;
  Value  := 0;
  if RegGetValue(RootKey, Name, REG_DWORD, Buf, BufSize) then
  begin
    Value := PDWord(Buf)^;
    FreeMem(Buf);
    Result := True;
  end;
end;

function RegGetBinary(RootKey: HKEY; Name: string; var Value: string): boolean;
var
  Buf:     Pointer;
  BufSize: cardinal;
begin
  Result := False;
  Value  := '';
  if RegGetValue(RootKey, Name, REG_BINARY, Buf, BufSize) then
  begin
    SetLength(Value, BufSize);
    Move(Buf^, Value[1], BufSize);
    FreeMem(Buf);
    Result := True;
  end;
end;

function RegValueExists(RootKey: HKEY; Name: string): boolean;
var
  SubKey: string;
  n:      integer;
  hTemp:  HKEY;
begin
  Result := False;
  n      := LastPos('\', Name);
  if n > 0 then
  begin
    SubKey := Copy(Name, 1, n - 1);
    if RegOpenKeyEx(RootKey, PChar(SubKey), 0, KEY_READ, hTemp) = ERROR_SUCCESS then
    begin
      SubKey := Copy(Name, n + 1, Length(Name) - n);
      Result := (RegQueryValueEx(hTemp, PChar(SubKey), nil, nil, nil, nil) =
        ERROR_SUCCESS);
      RegCloseKey(hTemp);
    end;
  end;
end;

function RegGetValueType(RootKey: HKEY; Name: string; var Value: cardinal): boolean;
var
  SubKey: string;
  n:      integer;
  hTemp:  HKEY;
  ValType: cardinal;
begin
  Result := False;
  Value  := REG_NONE;
  n      := LastPos('\', Name);
  if n > 0 then
  begin
    SubKey := Copy(Name, 1, n - 1);
    if (RegOpenKeyEx(RootKey, PChar(SubKey), 0, KEY_READ, hTemp) = ERROR_SUCCESS) then
    begin
      SubKey := Copy(Name, n + 1, Length(Name) - n);
      if SubKey = '' then
        Result := (RegQueryValueEx(hTemp, nil, nil, @ValType, nil, nil) = ERROR_SUCCESS)
      else
        Result := (RegQueryValueEx(hTemp, PChar(SubKey), nil, @ValType, nil, nil) =
          ERROR_SUCCESS);
      if Result then
        Value := ValType;
      RegCloseKey(hTemp);
    end;
  end;
end;

function RegKeyExists(RootKey: HKEY; Name: string): boolean;
var
  hTemp: HKEY;
begin
  Result := False;
  if RegOpenKeyEx(RootKey, PChar(Name), 0, KEY_READ, hTemp) = ERROR_SUCCESS then
  begin
    Result := True;
    RegCloseKey(hTemp);
  end;
end;

end.