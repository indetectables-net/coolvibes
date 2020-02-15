unit MiniReg;

{
  lightweight replacement for TRegistry. Does not use Classes or SysUtils. Intended
  for space-limited applets where only the commonly used functions are necessary.
  Returns True if Successful, else False.

  Written by Ben Hochstrasser (bhoc@surfeu.ch).
  This code is GPL.

}

interface

uses Windows;

function RegSetString(RootKey: HKEY; Name: string; Value: string): boolean;
function RegSetMultiString(RootKey: HKEY; Name: string; Value: string): boolean;
function RegSetExpandString(RootKey: HKEY; Name: string; Value: string): boolean;
function RegSetDWORD(RootKey: HKEY; Name: string; Value: cardinal): boolean;
function RegSetBinary(RootKey: HKEY; Name: string; Value: array of byte): boolean;
function RegGetString(RootKey: HKEY; Name: string; var Value: string): boolean;
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


end.
